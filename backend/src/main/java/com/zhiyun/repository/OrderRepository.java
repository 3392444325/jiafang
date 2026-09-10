package com.zhiyun.repository;

import com.zhiyun.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, String> {

    @Query("select distinct o from Order o left join fetch o.items where o.user.id = :userId order by o.createdAt desc")
    List<Order> findByUserIdWithItems(String userId);

    @Query("select distinct o from Order o left join fetch o.items where o.id = :id")
    Optional<Order> findByIdWithItems(String id);

    @Query("select o from Order o left join fetch o.user order by o.createdAt desc")
    List<Order> findAllWithUser();

    @Query("select distinct o from Order o left join fetch o.user left join fetch o.items order by o.createdAt desc")
    List<Order> findAllWithUserAndItems();

    /** 近 N 日已付款订单（用于销售趋势） */
    @Query("""
            select o from Order o
            where o.status in ('PAID','SHIPPED','COMPLETED')
              and o.paidAt >= :since
            order by o.paidAt asc
            """)
    List<Order> findRecentPaid(Date since);

    /** 已付款订单销售额合计（分） */
    @Query("""
            select coalesce(sum(o.totalFen),0) from Order o
            where o.status in ('PAID','SHIPPED','COMPLETED')
            """)
    long sumPaidTotalFen();

    /** 按状态分组计数 */
    @Query("select o.status as status, count(o) as cnt from Order o group by o.status")
    List<StatusCount> countByStatus();

    interface StatusCount {
        String getStatus();
        Long getCnt();
    }
}
