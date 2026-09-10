package com.zhiyun.controller;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.service.AuthService;
import com.zhiyun.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 商品与首页 —— 移植自 app/page.tsx / shop/page.tsx / products/page.tsx / products/[slug]/page.tsx 的 SSR 数据查询
 * GET /api/home           首页数据
 * GET /api/shop           商城首页
 * GET /api/products       商品列表（?cat=&sort=&q=）
 * GET /api/products/{slug} 商品详情
 */
@RestController
public class ProductController {

    @Autowired private ProductService productService;
    @Autowired private AuthService authService;

    @GetMapping("/home")
    public Map<String, Object> home() {
        return productService.getHomeData();
    }

    @GetMapping("/shop")
    public Map<String, Object> shop() {
        return productService.getShopData();
    }

    @GetMapping("/products")
    public Object products(@RequestParam(required = false, defaultValue = "") String cat,
                           @RequestParam(required = false, defaultValue = "default") String sort,
                           @RequestParam(required = false, defaultValue = "") String q) {
        return productService.getProducts(cat, sort, q);
    }

    @GetMapping("/products/{slug}")
    public Map<String, Object> detail(@PathVariable String slug) {
        SafeUser u = authService.getCurrentUser();
        return productService.getProductDetail(slug, u);
    }
}
