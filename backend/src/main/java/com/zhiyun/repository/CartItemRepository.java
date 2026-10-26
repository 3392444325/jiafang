package com.zhiyun.repository;

import com.zhiyun.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, String> {

    @Query("select c from CartItem c left join fetch c.product where c.user.id = :userId order by c.createdAt desc")
    List<CartItem> findByUserIdWithProduct(String userId);

    @Query("select c from CartItem c left join fetch c.product where c.session.id = :sessionId order by c.createdAt desc")
    List<CartItem> findBySessionIdWithProduct(String sessionId);

    Optional<CartItem> findByProductIdAndUserId(String productId, String userId);
    Optional<CartItem> findByProductIdAndSessionId(String productId, String sessionId);

    void deleteByUserId(String userId);

    /** 清理挂在过期会话上的孤儿购物车条目（先于会话删除执行，避免外键约束阻塞） */
    long deleteBySession_ExpiresAtBefore(java.util.Date expires);

    /** 购物车内商品总件数（用于徽标） */
    @Query("select coalesce(sum(c.qty),0) from CartItem c where c.user.id = :userId")
    long sumQtyByUserId(String userId);

    @Query("select coalesce(sum(c.qty),0) from CartItem c where c.session.id = :sessionId")
    long sumQtyBySessionId(String sessionId);
}
