package com.zhiyun.repository;

import com.zhiyun.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface OrderItemRepository extends JpaRepository<OrderItem, String> {

    List<OrderItem> findByOrderId(String orderId);

    @Query("""
        select oi from OrderItem oi
        where oi.product.id = :productId
          and oi.order.user.id = :userId
          and oi.order.status in ('PAID','SHIPPED','COMPLETED')
        """)
    Optional<OrderItem> findFirstPurchased(String productId, String userId);
}
