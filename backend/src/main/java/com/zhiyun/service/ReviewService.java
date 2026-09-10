package com.zhiyun.service;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.entity.Product;
import com.zhiyun.entity.Review;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.OrderItemRepository;
import com.zhiyun.repository.ProductRepository;
import com.zhiyun.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 评价服务 —— 移植自 app/api/reviews/route.ts
 * 仅购买过该商品（订单状态 PAID/SHIPPED/COMPLETED）的用户可发表一次评价
 */
@Service
public class ReviewService {

    @Autowired private ReviewRepository reviewRepo;
    @Autowired private ProductRepository productRepo;
    @Autowired private OrderItemRepository orderItemRepo;

    @Transactional
    public String submit(String productId, int rating, String content, SafeUser user) {
        if (user == null) throw BizException.unauthorized("请先登录");
        if (productId == null || productId.isBlank()) throw BizException.bad("参数错误");
        if (rating < 1 || rating > 5) throw BizException.bad("请选择 1-5 星评分");
        String c = content == null ? "" : content.trim();
        if (c.length() < 4 || c.length() > 500) throw BizException.bad("评价内容需 4-500 字");

        Product product = productRepo.findById(productId)
                .orElseThrow(() -> BizException.notFound("商品不存在"));

        boolean purchased = orderItemRepo.findFirstPurchased(productId, user.id()).isPresent();
        if (!purchased) throw BizException.forbidden("仅购买过该商品的用户可发表评价");

        if (reviewRepo.findFirstByUserIdAndProductId(user.id(), productId).isPresent()) {
            throw BizException.bad("你已评价过该商品");
        }

        Review r = new Review();
        r.setUserId(user.id());
        r.setProductId(productId);
        r.setRating(rating);
        r.setContent(c);
        return reviewRepo.save(r).getId();
    }
}
