package com.zhiyun.util;

import com.zhiyun.exception.BizException;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 进程内简易限流器（单实例部署够用；多实例/集群需改为 Redis 等集中式方案）
 */
public final class RateLimit {

    private RateLimit() {}

    // ==================== 失败锁定（登录暴力破解防护） ====================

    private static final int MAX_FAILURES = 5;               // 连续失败次数上限
    private static final long LOCK_MILLIS = 15 * 60 * 1000L; // 达到上限后锁定 15 分钟
    private static final Map<String, FailEntry> FAILURES = new ConcurrentHashMap<>();

    private static class FailEntry {
        final AtomicInteger count = new AtomicInteger();
        volatile long lockedUntil;
    }

    /** 该 key 处于锁定状态则抛 429，剩余分钟数进提示文案 */
    public static void ensureNotLocked(String key) {
        FailEntry e = FAILURES.get(key);
        if (e == null) return;
        long remainMs = e.lockedUntil - System.currentTimeMillis();
        if (remainMs > 0) {
            long minutes = remainMs / 60000 + 1;
            throw new BizException(429, "尝试次数过多，请 " + minutes + " 分钟后再试");
        }
    }

    /** 记录一次失败；达到阈值后锁定该 key 并重新计数 */
    public static void recordFailure(String key) {
        FailEntry e = FAILURES.computeIfAbsent(key, k -> new FailEntry());
        if (e.count.incrementAndGet() >= MAX_FAILURES) {
            e.lockedUntil = System.currentTimeMillis() + LOCK_MILLIS;
            e.count.set(0);
        }
    }

    /** 成功后清除失败计数 */
    public static void clearFailures(String key) {
        FAILURES.remove(key);
    }

    // ==================== 固定窗口计数（表单提交频率限制） ====================

    private static final Map<String, Window> WINDOWS = new ConcurrentHashMap<>();

    private static class Window {
        final long start;
        final AtomicInteger count = new AtomicInteger();

        Window(long start) { this.start = start; }
    }

    /** 固定时间窗口内最多允许 max 次，超出返回 false */
    public static boolean tryAcquire(String key, int max, long windowMillis) {
        long now = System.currentTimeMillis();
        Window w = WINDOWS.compute(key, (k, old) ->
                (old == null || now - old.start >= windowMillis) ? new Window(now) : old);
        return w.count.incrementAndGet() <= max;
    }

    // ==================== 客户端 IP（限流 key 用） ====================

    /** 优先取反向代理传递的 X-Forwarded-For 首段；生产部署时应由 nginx 覆写（而非追加）该头防止伪造 */
    public static String clientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) {
            int i = xff.indexOf(',');
            return (i > 0 ? xff.substring(0, i) : xff).trim();
        }
        return request.getRemoteAddr();
    }
}
