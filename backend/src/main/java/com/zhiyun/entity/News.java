package com.zhiyun.entity;

import com.zhiyun.util.Cuid;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

/** 品牌动态（新闻）：后台可发布/撤稿，前台仅展示已发布文章 */
@Entity
@Table(name = "news")
@Getter @Setter @NoArgsConstructor
public class News {

    @Id
    @Column(length = 30)
    private String id;

    @Column(nullable = false, length = 128)
    private String title;

    @Column(nullable = false, length = 16)
    private String category = "品牌新闻";

    @Column(length = 255)
    private String cover;

    @Column(length = 500)
    private String excerpt;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    /** 头条（列表置顶展示） */
    @Column(nullable = false)
    private Boolean featured = false;

    @Column(nullable = false)
    private Boolean published = true;

    @Column(name = "published_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date publishedAt;

    @Column(name = "created_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
        if (createdAt == null) createdAt = new Date();
        if (category == null) category = "品牌新闻";
        if (featured == null) featured = false;
        if (published == null) published = true;
        if (published == true && publishedAt == null) publishedAt = createdAt;
    }
}
