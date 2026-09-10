package com.zhiyun.entity;

import com.zhiyun.util.Cuid;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "leads")
@Getter @Setter @NoArgsConstructor
public class Lead {
    @Id
    @Column(length = 30)
    private String id;

    @Column(nullable = false, length = 16)
    private String type;

    @Column(nullable = false, length = 64)
    private String name;

    @Column(nullable = false, length = 32)
    private String phone;

    @Column(columnDefinition = "TEXT")
    private String note;

    @Column(nullable = false, length = 16)
    private String status = "NEW";

    @Column(name = "created_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
        if (createdAt == null) createdAt = new Date();
        if (status == null) status = "NEW";
    }
}
