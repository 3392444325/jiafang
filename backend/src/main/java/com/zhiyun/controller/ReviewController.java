package com.zhiyun.controller;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.exception.BizException;
import com.zhiyun.service.AuthService;
import com.zhiyun.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 评价提交 —— 移植自 app/api/reviews/route.ts
 * 仅购买过该商品（订单状态 PAID/SHIPPED/COMPLETED）的用户可发表一次评价
 */
@RestController
@RequestMapping("/reviews")
public class ReviewController {

    @Autowired private ReviewService reviewService;
    @Autowired private AuthService authService;

    @PostMapping
    public Map<String, Object> submit(@RequestBody Map<String, Object> body) {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        int rating;
        try { rating = Integer.parseInt(String.valueOf(body.get("rating"))); }
        catch (Exception e) { rating = 0; }
        String id = reviewService.submit(
                (String) body.get("productId"), rating,
                (String) body.get("content"), u);
        return Map.of("ok", true, "id", id);
    }
}
