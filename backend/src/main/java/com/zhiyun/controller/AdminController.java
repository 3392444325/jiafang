package com.zhiyun.controller;

import com.zhiyun.dto.Ok;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.exception.BizException;
import com.zhiyun.service.AdminService;
import com.zhiyun.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 后台管理 —— 移植自 app/admin/actions.ts 与 app/admin 各 page.tsx 的数据查询
 * 所有端点要求当前用户为 ADMIN，否则抛 403
 */
@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired private AdminService adminService;
    @Autowired private AuthService authService;

    // ============== 数据看板 ==============
    @GetMapping("/dashboard")
    public Map<String, Object> dashboard() {
        adminService.assertAdmin(requireAdmin());
        return adminService.dashboard();
    }

    // ============== 商品 ==============
    @GetMapping("/products")
    public Map<String, Object> products() {
        adminService.assertAdmin(requireAdmin());
        return adminService.listProducts();
    }

    @GetMapping("/products/{id}")
    public Map<String, Object> productForEdit(@PathVariable String id) {
        adminService.assertAdmin(requireAdmin());
        return adminService.getProductForEdit(id);
    }

    @PostMapping("/products/toggle")
    public Ok toggleProduct(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        adminService.toggleProduct((String) body.get("id"));
        return Ok.yes();
    }

    @PostMapping("/products/stock")
    public Ok updateStock(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        int stock = toInt(body.get("stock"));
        adminService.updateStock((String) body.get("id"), stock);
        return Ok.yes();
    }

    @PostMapping("/products/create")
    public Map<String, Object> createProduct(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        double price = toDouble(body.get("price"));
        boolean featured = Boolean.TRUE.equals(body.get("featured"));
        List<String> images = toStringList(body.get("images"));
        if (images == null || images.isEmpty()) {
            String single = (String) body.get("image");
            if (single != null && !single.isBlank()) images = List.of(single);
        }
        String id = adminService.createProduct(
                (String) body.get("name"), (String) body.get("subtitle"),
                (String) body.get("categoryId"), price,
                body.get("stock") == null ? 999 : toInt(body.get("stock")),
                (String) body.get("description"), images, featured);
        return Map.of("ok", true, "id", id);
    }

    @PostMapping("/products/update")
    public Ok updateProduct(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        double price = toDouble(body.get("price"));
        int stock = toInt(body.get("stock"));
        boolean featured = Boolean.TRUE.equals(body.get("featured"));
        adminService.updateProduct(
                (String) body.get("id"), (String) body.get("name"),
                (String) body.get("subtitle"), (String) body.get("description"),
                (String) body.get("categoryId"), price, stock, featured,
                toStringList(body.get("images")));
        return Ok.yes();
    }

    @PostMapping("/categories/create")
    public Map<String, Object> createCategory(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        String id = adminService.createCategory(
                (String) body.get("name"), (String) body.get("nameEn"),
                (String) body.get("tagline"));
        return Map.of("ok", true, "id", id);
    }

    // ============== 订单 ==============
    @GetMapping("/orders")
    public Map<String, Object> orders(@RequestParam(required = false, defaultValue = "all") String status,
                                      @RequestParam(required = false, defaultValue = "") String q) {
        adminService.assertAdmin(requireAdmin());
        return adminService.listOrders(status, q);
    }

    @PostMapping("/orders/status")
    public Ok updateOrderStatus(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        adminService.updateOrderStatus((String) body.get("id"), (String) body.get("status"));
        return Ok.yes();
    }

    /** 商家同意客户撤销申请（退款取消） */
    @PostMapping("/orders/cancel-approve")
    public Ok approveCancel(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        adminService.approveCancel((String) body.get("id"));
        return Ok.yes();
    }

    /** 商家拒绝客户撤销申请 */
    @PostMapping("/orders/cancel-reject")
    public Ok rejectCancel(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        adminService.rejectCancel((String) body.get("id"));
        return Ok.yes();
    }

    @GetMapping("/orders/export")
    public ResponseEntity<byte[]> exportCsv() {
        adminService.assertAdmin(requireAdmin());
        String csv = adminService.exportOrdersCsv();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("text/csv; charset=utf-8"));
        headers.set(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"orders-" + System.currentTimeMillis() + ".csv\"");
        return ResponseEntity.ok().headers(headers).body(csv.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    }

    // ============== 客户 ==============
    @GetMapping("/customers")
    public Map<String, Object> customers() {
        adminService.assertAdmin(requireAdmin());
        return adminService.listCustomers();
    }

    // ============== 评论 ==============
    @GetMapping("/reviews")
    public Map<String, Object> reviews() {
        adminService.assertAdmin(requireAdmin());
        return adminService.listReviews();
    }

    @PostMapping("/reviews/delete")
    public Ok deleteReview(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        adminService.deleteReview((String) body.get("id"));
        return Ok.yes();
    }

    // ============== 线索 ==============
    @GetMapping("/leads")
    public Map<String, Object> leads() {
        adminService.assertAdmin(requireAdmin());
        return adminService.listLeads();
    }

    @PostMapping("/leads/status")
    public Ok updateLeadStatus(@RequestBody Map<String, Object> body) {
        adminService.assertAdmin(requireAdmin());
        adminService.updateLeadStatus((String) body.get("id"), (String) body.get("status"));
        return Ok.yes();
    }

    private SafeUser requireAdmin() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        return u;
    }

    private int toInt(Object v) {
        if (v == null) throw BizException.bad("缺少必需参数");
        if (v instanceof Number n) return n.intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) {
            throw BizException.bad("参数格式错误: " + v);
        }
    }

    /** images 字段：字符串列表；非列表或缺失返回 null（表示未提供） */
    private List<String> toStringList(Object v) {
        if (!(v instanceof List<?> list)) return null;
        return list.stream().map(String::valueOf).filter(s -> !s.isBlank()).toList();
    }

    private double toDouble(Object v) {
        if (v == null) throw BizException.bad("缺少必需参数");
        if (v instanceof Number n) return n.doubleValue();
        try { return Double.parseDouble(v.toString()); } catch (Exception e) {
            throw BizException.bad("参数格式错误: " + v);
        }
    }
}
