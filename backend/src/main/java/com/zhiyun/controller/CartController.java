package com.zhiyun.controller;

import com.zhiyun.dto.CartEntry;
import com.zhiyun.dto.Ok;
import com.zhiyun.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 购物车 —— 移植自 app/api/cart/route.ts 与 [id]/route.ts
 * 游客与登录用户共用同一套端点（依据 zy_session cookie 解析归属）
 */
@RestController
@RequestMapping("/cart")
public class CartController {

    @Autowired private CartService cartService;

    /** 购物车数量（导航栏徽标） */
    @GetMapping
    public Map<String, Object> count() {
        return Map.of("count", cartService.getCartCount());
    }

    /** 购物车列表（带商品详情） */
    @GetMapping("/items")
    public Map<String, Object> items() {
        List<CartEntry> items = cartService.getCartItems();
        return Map.of("items", items);
    }

    /** 加入购物车 */
    @PostMapping
    public Map<String, Object> add(@RequestBody Map<String, Object> body) {
        String productId = (String) body.get("productId");
        int qty = toInt(body.get("qty"), 1);
        long count = cartService.addToCart(productId, qty);
        return Map.of("ok", true, "count", count);
    }

    @PatchMapping("/{id}")
    public Ok update(@PathVariable String id, @RequestBody Map<String, Object> body) {
        int qty = toInt(body.get("qty"), 1);
        cartService.updateItem(id, qty);
        return Ok.yes();
    }

    @DeleteMapping("/{id}")
    public Ok remove(@PathVariable String id) {
        cartService.deleteItem(id);
        return Ok.yes();
    }

    private int toInt(Object v, int def) {
        if (v == null) return def;
        if (v instanceof Number n) return n.intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) { return def; }
    }
}
