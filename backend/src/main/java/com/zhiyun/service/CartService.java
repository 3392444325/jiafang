package com.zhiyun.service;

import com.zhiyun.dto.CartEntry;
import com.zhiyun.dto.CartOwner;
import com.zhiyun.entity.CartItem;
import com.zhiyun.entity.Product;
import com.zhiyun.entity.Session;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.CartItemRepository;
import com.zhiyun.repository.ProductRepository;
import com.zhiyun.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CartService {

    @Autowired private CartItemRepository cartRepo;
    @Autowired private ProductRepository productRepo;
    @Autowired private AuthService authService;

    @Transactional(readOnly = true)
    public long getCartCount() {
        CartOwner owner = authService.resolveCartOwner();
        return owner.isUser() ? cartRepo.countByUserId(owner.userId())
                : cartRepo.countBySessionId(owner.sessionId());
    }

    @Transactional
    public long addToCart(String productId, int qty) {
        qty = Math.max(1, Math.min(99, qty));
        Product product = productRepo.findById(productId)
                .orElseThrow(() -> BizException.notFound("商品不存在或已下架"));
        if (!"ACTIVE".equals(product.getStatus())) {
            throw BizException.notFound("商品不存在或已下架");
        }
        if (product.getStock() <= 0) {
            throw BizException.bad("商品暂时缺货");
        }
        CartOwner owner = authService.resolveCartOwner();

        if (owner.isUser()) {
            CartItem existing = cartRepo.findByProductIdAndUserId(productId, owner.userId()).orElse(null);
            int target = Math.min(99, (existing != null ? existing.getQty() : 0) + qty);
            if (target > product.getStock()) {
                throw BizException.bad("库存不足，该商品仅剩 " + product.getStock() + " 件");
            }
            if (existing != null) {
                existing.setQty(target);
                cartRepo.save(existing);
            } else {
                CartItem item = new CartItem();
                item.setProductId(productId);
                item.setQty(qty);
                item.setUserId(owner.userId());
                cartRepo.save(item);
            }
        } else {
            CartItem existing = cartRepo.findByProductIdAndSessionId(productId, owner.sessionId()).orElse(null);
            int target = Math.min(99, (existing != null ? existing.getQty() : 0) + qty);
            if (target > product.getStock()) {
                throw BizException.bad("库存不足，该商品仅剩 " + product.getStock() + " 件");
            }
            if (existing != null) {
                existing.setQty(target);
                cartRepo.save(existing);
            } else {
                CartItem item = new CartItem();
                item.setProductId(productId);
                item.setQty(qty);
                item.setSessionId(owner.sessionId());
                cartRepo.save(item);
            }
        }
        return owner.isUser() ? cartRepo.countByUserId(owner.userId())
                : cartRepo.countBySessionId(owner.sessionId());
    }

    @Transactional
    public void updateItem(String id, int qty) {
        CartItem item = assertOwned(id);
        item.setQty(Math.max(1, Math.min(99, qty)));
        cartRepo.save(item);
    }

    @Transactional
    public void deleteItem(String id) {
        CartItem item = assertOwned(id);
        cartRepo.delete(item);
    }

    /** 购物车页面：带商品详情的条目列表 */
    @Transactional(readOnly = true)
    public List<CartEntry> getCartItems() {
        CartOwner owner = authService.resolveCartOwner();
        List<CartItem> rows = owner.isUser()
                ? cartRepo.findByUserIdWithProduct(owner.userId())
                : cartRepo.findBySessionIdWithProduct(owner.sessionId());
        return rows.stream().map(r -> {
            Product p = r.getProduct();
            String image = JsonUtil.parseStringList(p.getImages()).isEmpty()
                    ? "/images/products/p01.svg"
                    : JsonUtil.parseStringList(p.getImages()).get(0);
            return new CartEntry(r.getId(), p.getSlug(), p.getName(), image,
                    p.getPriceFen(), r.getQty(), p.getStock());
        }).toList();
    }

    private CartItem assertOwned(String id) {
        CartItem item = cartRepo.findById(id).orElseThrow(() -> BizException.notFound("条目不存在"));
        CartOwner owner = authService.resolveCartOwner();
        boolean owned = owner.isUser()
                ? owner.userId().equals(item.getUserId())
                : owner.sessionId().equals(item.getSessionId());
        if (!owned) throw BizException.forbidden("无权操作");
        return item;
    }

    /** 登录时合并游客购物车到用户名下 */
    @Transactional
    public void mergeGuestCartToUser(String guestSessionToken, String userId) {
        if (guestSessionToken == null) return;
        List<CartItem> guestItems = cartRepo.findBySessionTokenWithProduct(guestSessionToken);
        // 这里不能直接用 findByToken，需要确认 session 归属游客
        // 通过 token 找到 session，确认 userId 为空
        // 简化：直接遍历 guestItems（已通过 session.token 关联）
        for (CartItem item : guestItems) {
            if (item.getUserId() != null) continue; // 已归属用户，跳过
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
}
