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

    long countByUserId(String userId);
    long countBySessionId(String sessionId);

    Optional<CartItem> findByProductIdAndUserId(String productId, String userId);
    Optional<CartItem> findByProductIdAndSessionId(String productId, String sessionId);

    void deleteByUserId(String userId);
}
