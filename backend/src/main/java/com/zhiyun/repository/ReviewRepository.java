package com.zhiyun.repository;

import com.zhiyun.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, String> {

    @Query("select r from Review r left join fetch r.user left join fetch r.product order by r.createdAt desc")
    List<Review> findAllWithUserAndProduct();

    @Query("""
        select r from Review r
        left join fetch r.user
        where r.product.id = :productId
        order by r.createdAt desc
        """)
    List<Review> findByProductIdWithUser(String productId);

    @Query("""
        select r from Review r
        left join fetch r.user
        left join fetch r.product
        order by r.createdAt desc
        """)
    List<Review> findTop6WithUserAndProduct();

    Optional<Review> findFirstByUserIdAndProductId(String userId, String productId);
}
