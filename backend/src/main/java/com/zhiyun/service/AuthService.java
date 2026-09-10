package com.zhiyun.service;

import com.zhiyun.dto.CartOwner;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.entity.CartItem;
import com.zhiyun.entity.Session;
import com.zhiyun.entity.User;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.CartItemRepository;
import com.zhiyun.repository.SessionRepository;
import com.zhiyun.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 认证与购物车归属解析 —— 移植自 lib/auth.ts
 * Session Cookie: zy_session（httpOnly, sameSite=lax, path=/, 30 天）
 */
@Service
public class AuthService {

    public static final String SESSION_COOKIE = "zy_session";
    private static final int SESSION_DAYS = 30;
    private static final SecureRandom RANDOM = new SecureRandom();
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(10);

    // ===== 登录防爆破：按邮箱计数，连续失败 5 次锁定 15 分钟 =====
    private static final int MAX_LOGIN_ATTEMPTS = 5;
    private static final long LOGIN_LOCK_MILLIS = 15 * 60 * 1000L;
    /** value: [失败次数, 锁定截止时间戳] */
    private final Map<String, long[]> loginAttempts = new ConcurrentHashMap<>();

    // ===== 游客会话创建限流：每 IP 每分钟最多 20 个（防脚本刷库） =====
    private static final int MAX_GUEST_SESSIONS_PER_WINDOW = 20;
    private static final long GUEST_WINDOW_MILLIS = 60_000L;
    /** value: [窗口内计数, 窗口起始时间戳] */
    private final Map<String, long[]> guestSessionCounter = new ConcurrentHashMap<>();

    @Autowired private HttpServletRequest request;
    @Autowired private HttpServletResponse response;
    @Autowired private SessionRepository sessionRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private CartItemRepository cartRepo;

    public String hashPassword(String plain) {
        return encoder.encode(plain);
    }

    public boolean verifyPassword(String plain, String hash) {
        return encoder.matches(plain, hash);
    }

    /** 读取当前登录用户（只读，渲染期安全） */
    @Transactional(readOnly = true)
    public SafeUser getCurrentUser() {
        String token = readCookie();
        if (token == null) return null;
        Session s = sessionRepo.findByToken(token).orElse(null);
        if (s == null || s.getExpiresAt().before(new Date()) || s.getUser() == null) return null;
        User u = s.getUser();
        return new SafeUser(u.getId(), u.getEmail(), u.getName(), u.getRole());
    }

    /** 解析购物车归属：登录用户→userId；游客→sessionId（不存在则创建游客会话并下发 cookie） */
    @Transactional
    public CartOwner resolveCartOwner() {
        String token = readCookie();
        if (token != null) {
            Session s = sessionRepo.findByToken(token).orElse(null);
            if (s != null && s.getExpiresAt().after(new Date())) {
                if (s.getUserId() != null) return CartOwner.user(s.getUserId());
                return CartOwner.session(s.getId());
            }
        }
        assertGuestSessionQuota();
        Session s = createSession(null);
        setCookie(s.getToken(), s.getExpiresAt());
        return CartOwner.session(s.getId());
    }

    /** 注册：创建用户并下发会话 cookie */
    @Transactional
    public SafeUser register(String email, String password, String name) {
        email = normalize(email);
        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            throw BizException.bad("邮箱格式不正确");
        }
        if (password == null || password.length() < 6) throw BizException.bad("密码至少 6 位");
        if (name == null || name.trim().isEmpty()) throw BizException.bad("请填写昵称");

        if (userRepo.existsByEmail(email)) throw BizException.conflict("该邮箱已注册");

        User u = new User();
        u.setEmail(email);
        u.setPasswordHash(hashPassword(password));
        u.setName(name.trim());
        u.setRole("CUSTOMER");
        u = userRepo.save(u);
        mergeGuestSessionCart(u.getId());
        loginUser(u.getId());
        return new SafeUser(u.getId(), u.getEmail(), u.getName(), u.getRole());
    }

    /** 当前游客会话的购物车合并到用户名下，并删除旧游客会话 */
    private void mergeGuestSessionCart(String userId) {
        String oldToken = readCookie();
        if (oldToken == null) return;
        Session old = sessionRepo.findByToken(oldToken).orElse(null);
        if (old != null && old.getUserId() == null) {
            mergeGuestCart(old.getId(), userId);
            // 必须先 flush：Session.cartItems 配置了 cascade=REMOVE，
            // 若不先落库（条目 session_id 已置 NULL），删除会话时级联会把刚迁移的条目一并删除
            cartRepo.flush();
            sessionRepo.delete(old);
        }
    }

    /** 登录：校验密码 → 合并游客购物车 → 下发新会话 cookie */
    @Transactional
    public SafeUser login(String email, String password) {
        email = normalize(email);
        if (email == null) throw BizException.unauthorized("邮箱或密码不正确");
        checkLoginRateLimit(email);
        final String em = email;
        User u = userRepo.findByEmail(em)
                .orElseThrow(() -> {
                    recordLoginFailure(em);
                    return BizException.unauthorized("邮箱或密码不正确");
                });
        if (!verifyPassword(password, u.getPasswordHash())) {
            recordLoginFailure(em);
            throw BizException.unauthorized("邮箱或密码不正确");
        }
        clearLoginFailures(em);
        // 合并游客购物车
        mergeGuestSessionCart(u.getId());
        loginUser(u.getId());
        return new SafeUser(u.getId(), u.getEmail(), u.getName(), u.getRole());
    }

    /** 将游客 session 名下的购物车合并到用户名下 */
    private void mergeGuestCart(String guestSessionId, String userId) {
        List<CartItem> guestItems = cartRepo.findBySessionIdWithProduct(guestSessionId);
        for (CartItem item : guestItems) {
            if (item.getUserId() != null) continue;
            CartItem existing = cartRepo.findByProductIdAndUserId(item.getProductId(), userId).orElse(null);
            if (existing != null) {
                existing.setQty(Math.min(99, existing.getQty() + item.getQty()));
                cartRepo.save(existing);
                cartRepo.delete(item);
            } else {
                item.setUserId(userId);
                item.setSessionId(null);
                cartRepo.save(item);
            }
        }
    }

    /** 为已登录用户创建新会话并下发 cookie */
    @Transactional
    public Session loginUser(String userId) {
        Session s = createSession(userId);
        setCookie(s.getToken(), s.getExpiresAt());
        return s;
    }

    @Transactional
    public void logoutUser() {
        String token = readCookie();
        if (token != null) sessionRepo.deleteByToken(token);
        clearCookie();
    }

    private Session createSession(String userId) {
        Session s = new Session();
        s.setToken(generateToken());
        s.setUserId(userId);
        s.setExpiresAt(new Date(System.currentTimeMillis() + (long) SESSION_DAYS * 86400 * 1000));
        return sessionRepo.save(s);
    }

    private String generateToken() {
        byte[] buf = new byte[24];
        RANDOM.nextBytes(buf);
        StringBuilder sb = new StringBuilder(48);
        for (byte b : buf) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    public String readCookie() {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
        return Arrays.stream(cookies)
                .filter(c -> SESSION_COOKIE.equals(c.getName()))
                .map(Cookie::getValue)
                .findFirst()
                .orElse(null);
    }

    /** 登录限流检查：连续失败次数过多则拒绝 */
    private void checkLoginRateLimit(String email) {
        long[] a = loginAttempts.get(email);
        if (a != null && a[0] >= MAX_LOGIN_ATTEMPTS) {
            long remain = a[1] - System.currentTimeMillis();
            if (remain > 0) {
                throw BizException.tooMany("尝试次数过多，请约 " + (remain / 60000 + 1) + " 分钟后再试");
            }
            loginAttempts.remove(email);
        }
    }

    private void recordLoginFailure(String email) {
        long[] a = loginAttempts.computeIfAbsent(email, k -> new long[2]);
        if (a[0] >= MAX_LOGIN_ATTEMPTS && a[1] < System.currentTimeMillis()) a[0] = 0;
        a[0]++;
        if (a[0] >= MAX_LOGIN_ATTEMPTS) a[1] = System.currentTimeMillis() + LOGIN_LOCK_MILLIS;
    }

    private void clearLoginFailures(String email) {
        loginAttempts.remove(email);
    }

    /** 游客会话创建限流（按来源 IP），防止脚本刷爆 sessions 表 */
    private void assertGuestSessionQuota() {
        String ip = clientIp();
        long now = System.currentTimeMillis();
        long[] c = guestSessionCounter.computeIfAbsent(ip, k -> new long[]{0, now});
        if (now - c[1] > GUEST_WINDOW_MILLIS) {
            c[0] = 0;
            c[1] = now;
        }
        if (c[0] >= MAX_GUEST_SESSIONS_PER_WINDOW) {
            throw BizException.tooMany("请求过于频繁，请稍后再试");
        }
        c[0]++;
    }

    private String clientIp() {
        String xff = request.getHeader("X-Forwarded-For");
        return (xff != null && !xff.isBlank()) ? xff.split(",")[0].trim() : request.getRemoteAddr();
    }

    private String normalize(String email) {
        return email == null ? null : email.trim().toLowerCase();
    }

    private void setCookie(String token, Date expires) {
        // 手动拼接以支持 SameSite=Lax
        String cookie = SESSION_COOKIE + "=" + token
                + "; Path=/; HttpOnly; SameSite=Lax"
                + "; Expires=" + java.time.format.DateTimeFormatter.RFC_1123_DATE_TIME
                        .format(expires.toInstant().atZone(java.time.ZoneOffset.UTC));
        response.addHeader("Set-Cookie", cookie);
    }

    private void clearCookie() {
        String cookie = SESSION_COOKIE + "=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0";
        response.addHeader("Set-Cookie", cookie);
    }
}
