package com.zhiyun.repository;

import com.zhiyun.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, String> {
    Optional<Product> findBySlug(String slug);

    /** 条件更新扣减库存并累加销量，库存不足时返回 0（防并发超卖） */
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("update Product p set p.stock = p.stock - :qty, p.sales = p.sales + :qty where p.id = :id and p.stock >= :qty")
    int deductStock(@Param("id") String id, @Param("qty") int qty);

    @Query("select p from Product p left join fetch p.category")
    List<Product> findAllWithCategory();

    @Query("select p from Product p left join fetch p.category where p.status = 'ACTIVE' order by p.sales desc")
    List<Product> findActiveOrderBySalesDesc();

    @Query("select p from Product p left join fetch p.category where p.featured = true and p.status = 'ACTIVE' order by p.createdAt asc")
    List<Product> findFeaturedActive();

    long countByStatus(String status);

    @Query("select p from Product p left join fetch p.category order by p.createdAt desc")
    List<Product> findAllOrderByCreatedAtDesc();

    @Query("select p from Product p left join fetch p.category order by p.sales desc")
    List<Product> findAllOrderBySalesDesc();
}
