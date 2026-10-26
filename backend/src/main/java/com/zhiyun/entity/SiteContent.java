package com.zhiyun.entity;

import com.zhiyun.util.Cuid;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

/**
 * 页面设计内容表（key-value）：存储首页轮播、各版块图片与文案等可配置内容。
 * contentJson 为前端定义的任意 JSON 结构（对象或数组）。
 */
@Entity
@Table(name = "site_content")
@Getter @Setter @NoArgsConstructor
public class SiteContent {

    @Id
    @Column(length = 30)
    private String id;

    @Column(name = "content_key", nullable = false, unique = true, length = 64)
    private String contentKey;

    @Column(name = "content_json", nullable = false, columnDefinition = "TEXT")
    private String contentJson;

    @Column(name = "updated_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
        if (updatedAt == null) updatedAt = new Date();
    }
}
