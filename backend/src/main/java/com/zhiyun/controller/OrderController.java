package com.zhiyun.controller;

import com.zhiyun.dto.Ok;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.exception.BizException;
import com.zhiyun.service.AuthService;
import com.zhiyun.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 订单 —— 移植自 app/api/orders/route.ts 与 [id] 下 route.ts
 * 创建订单要求登录；查看 / 支付仅限订单归属用户
 */
@RestController
@RequestMapping("/orders")
public class OrderController {

    @Autowired private OrderService orderService;
    @Autowired private AuthService authService;

    /** 我的订单列表 */
    @GetMapping
    public Map<String, Object> list() {
        SafeUser u = requireLogin();
        return Map.of("orders", orderService.listOrders(u.id()));
    }

    /** 创建订单 */
    @PostMapping
    public Map<String, Object> create(@RequestBody Map<String, Object> body) {
        SafeUser u = requireLogin();
        Boolean saveAddress = null;
        Object sav = body.get("saveAddress");
        if (sav instanceof Boolean b) saveAddress = b;
        else if (sav instanceof String s && !s.isBlank()) saveAddress = Boolean.parseBoolean(s);
        return orderService.createOrder(u.id(),
                (String) body.get("name"), (String) body.get("phone"),
                (String) body.get("province"), (String) body.get("city"),
                (String) body.get("district"), (String) body.get("detail"), saveAddress);
    }

    /** 订单详情 */
    @GetMapping("/{id}")
    public Map<String, Object> detail(@PathVariable String id) {
        SafeUser u = requireLogin();
        return orderService.getOrderDetail(id, u);
    }

    /** 模拟支付 */
    @PostMapping("/{id}/pay")
    public Map<String, Object> pay(@PathVariable String id, @RequestBody(required = false) Map<String, Object> body) {
        SafeUser u = requireLogin();
        String method = body == null ? "WECHAT" : (String) body.get("method");
        String paid = orderService.payOrder(id, u, method);
        return Map.of("ok", true, "payMethod", paid);
    }

    /** 客户取消订单（仅待付款） */
    @PostMapping("/{id}/cancel")
    public Map<String, Object> cancel(@PathVariable String id) {
        SafeUser u = requireLogin();
        orderService.cancelOrder(id, u);
        return Map.of("ok", true, "status", "CANCELLED");
    }

    /** 客户提交撤销申请（仅已付款；商家审核后退款取消） */
    @PostMapping("/{id}/cancel-request")
    public Ok requestCancel(@PathVariable String id) {
        SafeUser u = requireLogin();
        orderService.requestCancel(id, u);
        return Ok.yes();
    }

    private SafeUser requireLogin() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        return u;
    }
}
