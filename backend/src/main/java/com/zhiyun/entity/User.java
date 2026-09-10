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
@Table(name = "users")
@Getter @Setter @NoArgsConstructor
public class User {
    @Id
    @Column(length = 30)
    private String id;

    @Column(nullable = false, unique = true, length = 128)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 100)
    private String passwordHash;

    @Column(length = 64)
    private String name;

    @Column(length = 32)
    private String phone;

    @Column(nullable = false, length = 16)
    private String role = "CUSTOMER";

    @Column(name = "created_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<Address> addresses = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<Order> orders = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<CartItem> cartItems = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<Session> sessions = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE)
    private List<Review> reviews = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
        if (createdAt == null) createdAt = new Date();
    }
}
