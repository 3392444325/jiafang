package com.zhiyun.entity;

import com.zhiyun.util.Cuid;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "order_items")
@Getter @Setter @NoArgsConstructor
public class OrderItem {
    @Id
    @Column(length = 30)
    private String id;

    @Column(name = "order_id", nullable = false, length = 30)
    private String orderId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", insertable = false, updatable = false)
    private Order order;

    @Column(name = "product_id", nullable = false, length = 30)
    private String productId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", insertable = false, updatable = false)
    private Product product;

    @Column(name = "name_snap", nullable = false, length = 128)
    private String nameSnap;

    @Column(name = "image_snap", length = 255)
    private String imageSnap;

    @Column(name = "price_fen", nullable = false)
    private Integer priceFen;

    @Column(nullable = false)
    private Integer qty;

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
    }
}
