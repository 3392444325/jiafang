package com.zhiyun.entity;

import com.zhiyun.util.Cuid;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(
    name = "cart_items",
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_cart_product_user", columnNames = {"product_id", "user_id"}),
        @UniqueConstraint(name = "uk_cart_product_session", columnNames = {"product_id", "session_id"})
    }
)
@Getter @Setter @NoArgsConstructor
public class CartItem {
    @Id
    @Column(length = 30)
    private String id;

    @Column(nullable = false)
    private Integer qty = 1;

    @Column(name = "product_id", nullable = false, length = 30)
    private String productId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", insertable = false, updatable = false)
    private Product product;

    @Column(name = "user_id", length = 30)
    private String userId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;

    @Column(name = "session_id", length = 30)
    private String sessionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", insertable = false, updatable = false)
    private Session session;

    @Column(name = "created_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
        if (createdAt == null) createdAt = new Date();
        if (qty == null) qty = 1;
    }
}
