package com.zhiyun.repository;

import com.zhiyun.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, String> {
    List<Category> findAllByOrderBySortAsc();

    @Query("select coalesce(max(c.sort),0) from Category c")
    Integer maxSort();
}
