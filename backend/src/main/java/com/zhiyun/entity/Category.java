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
@Table(name = "categories")
@Getter @Setter @NoArgsConstructor
public class Category {
    @Id
    @Column(length = 30)
    private String id;

    @Column(nullable = false, unique = true, length = 64)
    private String slug;

    @Column(nullable = false, length = 64)
    private String name;

    @Column(name = "name_en", nullable = false, length = 128)
    private String nameEn;

    @Column(length = 128)
    private String tagline;

    @Column(nullable = false)
    private Integer sort = 0;

    @OneToMany(mappedBy = "category", cascade = CascadeType.REMOVE)
    private List<Product> products = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (id == null) id = Cuid.next();
    }
}
