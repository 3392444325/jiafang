package com.zhiyun.entity;

import com.zhiyun.util.Cuid;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "orders")
@Getter @Setter @NoArgsConstructor
public class Order {
    @Id
    @Column(length = 30)
    private String id;

    @Column(name = "order_no", nullable = false, unique = true, length = 32)
    private String orderNo;

    @Column(nullable = false, length = 24)
    private String status = "PENDING_PAYMENT";

    @Column(name = "total_fen", nullable = false)
    private Integer totalFen;

    @Column(name = "user_id", nullable = false, length = 30)
    private String userId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;

    @Column(name = "address_json", nullable = false, columnDefinition = "TEXT")
    private String addressJson;

    @Column(name = "pay_method", length = 16)
    private String payMethod;

    @Column(name = "created_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "paid_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date paidAt;

    /** 客户撤销申请标记（仅已付款订单可申请，商家审核通过后取消） */
    @Column(name = "cancel_requested", nullable = false)
    private Boolean cancelRequested = false;

    @Column(name = "cancel_requested_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date cancelRequestedAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
        if (createdAt == null) createdAt = new Date();
        if (status == null) status = "PENDING_PAYMENT";
    }
}
