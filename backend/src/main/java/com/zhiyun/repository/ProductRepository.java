package com.zhiyun.repository;

import com.zhiyun.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, String> {
    Optional<Product> findBySlug(String slug);

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

    /** 条件扣库存：仅当库存充足时扣减并增加销量，返回受影响行数（0=库存不足） */
    @Modifying
    @Query("""
            update Product p
            set p.stock = p.stock - :qty, p.sales = p.sales + :qty
            where p.id = :id and p.stock >= :qty
            """)
    int deductStock(String id, int qty);

    /** 回补库存与销量（订单取消） */
    @Modifying
    @Query("""
            update Product p
            set p.stock = p.stock + :qty, p.sales = case when p.sales >= :qty then p.sales - :qty else 0 end
            where p.id = :id
            """)
    int restoreStock(String id, int qty);
}
