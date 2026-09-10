package com.zhiyun.repository;

import com.zhiyun.entity.Product;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, String> {
    Optional<Product> findBySlug(String slug);

    /** 悲观锁批量锁定商品（下单扣库存防超卖） */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select p from Product p where p.id in :ids")
    List<Product> findAllByIdForUpdate(@Param("ids") List<String> ids);

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
