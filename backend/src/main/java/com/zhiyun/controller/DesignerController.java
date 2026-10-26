package com.zhiyun.controller;

import com.zhiyun.dto.Ok;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.entity.Product;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.CategoryRepository;
import com.zhiyun.repository.ProductRepository;
import com.zhiyun.service.AdminService;
import com.zhiyun.service.AuthService;
import com.zhiyun.service.NewsService;
import com.zhiyun.service.SiteContentService;
import com.zhiyun.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 页面设计后台（/designer）—— 与 /admin 完全独立的独立入口
 * 内容配置：GET /api/designer/content、POST /api/designer/content/save
 * 商品发布与图片管理：GET/POST /api/designer/products、POST /api/designer/products/{id}/images
 * 所有端点要求 ADMIN
 */
@RestController
@RequestMapping("/designer")
public class DesignerController {

    @Autowired private SiteContentService siteContentService;
    @Autowired private AdminService adminService;
    @Autowired private NewsService newsService;
    @Autowired private ProductRepository productRepo;
    @Autowired private CategoryRepository categoryRepo;
    @Autowired private AuthService authService;

    // ============== 页面内容配置 ==============

    @GetMapping("/content")
    public Map<String, Object> content() {
        requireAdmin();
        return siteContentService.getAll();
    }

    @PostMapping("/content/save")
    public Ok saveContent(@RequestBody Map<String, Object> body) {
        requireAdmin();
        siteContentService.saveAll(body);
        return Ok.yes();
    }

    // ============== 品牌动态（新闻） ==============

    /** 全部文章（含未发布） */
    @GetMapping("/news")
    public Map<String, Object> newsList() {
        requireAdmin();
        return Map.of("news", newsService.listAll());
    }

    @PostMapping("/news")
    public Map<String, Object> createNews(@RequestBody Map<String, Object> body) {
        requireAdmin();
        String id = newsService.create(
                (String) body.get("title"), (String) body.get("category"),
                (String) body.get("cover"), (String) body.get("excerpt"),
                (String) body.get("content"),
                Boolean.TRUE.equals(body.get("featured")),
                !Boolean.FALSE.equals(body.get("published")));
        return Map.of("ok", true, "id", id);
    }

    @PostMapping("/news/update")
    public Ok updateNews(@RequestBody Map<String, Object> body) {
        requireAdmin();
        newsService.update(
                (String) body.get("id"), (String) body.get("title"),
                (String) body.get("category"), (String) body.get("cover"),
                (String) body.get("excerpt"), (String) body.get("content"),
                Boolean.TRUE.equals(body.get("featured")),
                !Boolean.FALSE.equals(body.get("published")));
        return Ok.yes();
    }

    @PostMapping("/news/delete")
    public Ok deleteNews(@RequestBody Map<String, Object> body) {
        requireAdmin();
        newsService.delete((String) body.get("id"));
        return Ok.yes();
    }

    // ============== 新品发布 / 图片管理 ==============

    /** 商品列表（含图片集），供图片管理 */
    @GetMapping("/products")
    public Map<String, Object> products() {
        requireAdmin();
        List<Map<String, Object>> list = productRepo.findAllOrderByCreatedAtDesc().stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId());
            m.put("name", p.getName());
            m.put("priceFen", p.getPriceFen());
            m.put("stock", p.getStock());
            m.put("status", p.getStatus());
            m.put("categoryId", p.getCategoryId());
            m.put("categoryName", p.getCategory() != null ? p.getCategory().getName() : "");
            m.put("images", JsonUtil.parseStringList(p.getImages()));
            return m;
        }).toList();
        List<Map<String, Object>> cats = categoryRepo.findAllByOrderBySortAsc().stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("name", c.getName());
            m.put("slug", c.getSlug());
            return m;
        }).toList();
        return Map.of("products", list, "categories", cats);
    }

    /** 新建商品：支持多图 URL 列表（写入 products.images） */
    @PostMapping("/products")
    public Map<String, Object> createProduct(@RequestBody Map<String, Object> body) {
        requireAdmin();
        String id = adminService.createProduct(
                (String) body.get("name"),
                (String) body.get("subtitle"),
                (String) body.get("categoryId"),
                toDouble(body.get("price")),
                body.get("stock") == null ? 999 : toInt(body.get("stock")),
                (String) body.get("description"),
                toStringList(body.get("images")),
                Boolean.TRUE.equals(body.get("featured")));
        return Map.of("ok", true, "id", id);
    }

    /** 更新商品图片集（多图 + 顺序） */
    @PostMapping("/products/{id}/images")
    public Ok updateImages(@PathVariable String id, @RequestBody Map<String, Object> body) {
        requireAdmin();
        List<String> images = toStringList(body.get("images"));
        if (images == null || images.isEmpty()) throw BizException.bad("至少保留一张图片");
        Product p = productRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("商品不存在"));
        p.setImages(JsonUtil.write(images));
        productRepo.save(p);
        return Ok.yes();
    }

    private void requireAdmin() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        if (!"ADMIN".equals(u.role())) throw BizException.forbidden("无权限操作");
    }

    private List<String> toStringList(Object v) {
        if (!(v instanceof List<?> list)) return null;
        return list.stream().map(String::valueOf).filter(s -> !s.isBlank()).toList();
    }

    private int toInt(Object v) {
        if (v instanceof Number n) return n.intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) {
            throw BizException.bad("参数格式错误: " + v);
        }
    }

    private double toDouble(Object v) {
        if (v instanceof Number n) return n.doubleValue();
        try { return Double.parseDouble(v.toString()); } catch (Exception e) {
            throw BizException.bad("参数格式错误: " + v);
        }
    }
}
