package com.zhiyun.service;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.entity.*;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.*;
import com.zhiyun.util.FormatUtil;
import com.zhiyun.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 后台管理服务 —— 移植自 app/admin/actions.ts 与 app/admin 各 page.tsx 的数据查询
 * 所有方法均要求当前用户为 ADMIN
 */
@Service
public class AdminService {

    @Autowired private ProductRepository productRepo;
    @Autowired private CategoryRepository categoryRepo;
    @Autowired private OrderRepository orderRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private ReviewRepository reviewRepo;
    @Autowired private LeadRepository leadRepo;

    /** 校验管理员权限 */
    public void assertAdmin(SafeUser user) {
        if (user == null || !"ADMIN".equals(user.role())) {
            throw BizException.forbidden("无权限操作");
        }
    }

    // ===================== 数据看板 =====================

    @Transactional(readOnly = true)
    public Map<String, Object> dashboard() {
        long activeProducts = productRepo.countByStatus("ACTIVE");
        long totalOrders = orderRepo.count();
        long paidTotalFen = orderRepo.sumPaidTotalFen();
        long newLeads = leadRepo.countByStatus("NEW");

        // 7 日销售趋势
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        cal.add(Calendar.DATE, -6);
        Date since = cal.getTime();
        List<Order> recentPaid = orderRepo.findRecentPaid(since);

        List<Map<String, Object>> daily = new ArrayList<>();
        Calendar today = Calendar.getInstance();
        today.set(Calendar.HOUR_OF_DAY, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.SECOND, 0);
        today.set(Calendar.MILLISECOND, 0);
        for (int d = 6; d >= 0; d--) {
            Calendar day = (Calendar) today.clone();
            day.add(Calendar.DATE, -d);
            Calendar next = (Calendar) day.clone();
            next.add(Calendar.DATE, 1);
            long fen = recentPaid.stream()
                    .filter(o -> o.getPaidAt() != null
                            && !o.getPaidAt().before(day.getTime())
                            && o.getPaidAt().before(next.getTime()))
                    .mapToLong(Order::getTotalFen)
                    .sum();
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("label", (day.get(Calendar.MONTH) + 1) + "/" + day.get(Calendar.DATE));
            m.put("fen", fen);
            daily.add(m);
        }

        // 热销 Top5
        List<Product> topProducts = productRepo.findAllOrderBySalesDesc().stream().limit(5).toList();
        List<Map<String, Object>> topList = topProducts.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId());
            m.put("name", p.getName());
            m.put("categoryName", p.getCategory() != null ? p.getCategory().getName() : "");
            m.put("sales", p.getSales());
            m.put("priceFen", p.getPriceFen());
            return m;
        }).toList();

        // 订单状态分布
        List<OrderRepository.StatusCount> groups = orderRepo.countByStatus();
        Map<String, Long> statusCounts = new LinkedHashMap<>();
        for (String[] st : new String[][]{
                {"PENDING_PAYMENT", "待付款"}, {"PAID", "已付款"},
                {"SHIPPED", "已发货"}, {"COMPLETED", "已完成"}, {"CANCELLED", "已取消"}}) {
            statusCounts.put(st[0], 0L);
        }
        for (OrderRepository.StatusCount g : groups) {
            statusCounts.put(g.getStatus(), g.getCnt());
        }

        // 最近 5 单
        List<Order> recentOrders = orderRepo.findAllWithUser().stream().limit(5).toList();
        List<Map<String, Object>> recentList = recentOrders.stream().map(o -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", o.getId());
            m.put("orderNo", o.getOrderNo());
            m.put("status", o.getStatus());
            m.put("totalFen", o.getTotalFen());
            m.put("createdAt", o.getCreatedAt());
            m.put("userName", o.getUser() != null ? defaultIfNull(o.getUser().getName(), o.getUser().getEmail()) : "");
            return m;
        }).toList();

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("stats", Map.of(
                "activeProducts", activeProducts,
                "totalOrders", totalOrders,
                "paidTotalFen", paidTotalFen,
                "newLeads", newLeads));
        res.put("daily", daily);
        res.put("topProducts", topList);
        res.put("statusCounts", statusCounts);
        res.put("recentOrders", recentList);
        return res;
    }

    // ===================== 商品管理 =====================

    @Transactional(readOnly = true)
    public Map<String, Object> listProducts() {
        List<Product> products = productRepo.findAllOrderByCreatedAtDesc();
        List<Map<String, Object>> list = products.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId());
            m.put("slug", p.getSlug());
            m.put("name", p.getName());
            m.put("priceFen", p.getPriceFen());
            m.put("sales", p.getSales());
            m.put("stock", p.getStock());
            m.put("status", p.getStatus());
            m.put("featured", p.getFeatured());
            m.put("categoryId", p.getCategoryId());
            m.put("categoryName", p.getCategory() != null ? p.getCategory().getName() : "");
            return m;
        }).toList();
        List<Map<String, Object>> cats = categoryRepo.findAllByOrderBySortAsc().stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("name", c.getName());
            m.put("nameEn", c.getNameEn());
            m.put("slug", c.getSlug());
            return m;
        }).toList();
        return Map.of("products", list, "categories", cats);
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getProductForEdit(String id) {
        Product p = productRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("商品不存在"));
        List<Map<String, Object>> cats = categoryRepo.findAllByOrderBySortAsc().stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("name", c.getName());
            return m;
        }).toList();
        Map<String, Object> product = new LinkedHashMap<>();
        product.put("id", p.getId());
        product.put("name", p.getName());
        product.put("slug", p.getSlug());
        product.put("subtitle", p.getSubtitle());
        product.put("description", p.getDescription());
        product.put("priceFen", p.getPriceFen());
        product.put("stock", p.getStock());
        product.put("featured", p.getFeatured());
        product.put("categoryId", p.getCategoryId());
        product.put("images", JsonUtil.parseStringList(p.getImages()));
        return Map.of("product", product, "categories", cats);
    }

    @Transactional
    public String createProduct(String name, String categoryId, double priceYuan,
                                String description, String image, boolean featured, int stock) {
        if (isBlank(name) || isBlank(categoryId) || priceYuan <= 0 || stock < 0) {
            throw BizException.bad("请填写完整商品信息");
        }
        Product p = new Product();
        p.setSlug("zy-" + Long.toString(System.currentTimeMillis(), 36));
        p.setName(name);
        p.setCategoryId(categoryId);
        p.setDescription(isBlank(description) ? "织云出品，以东方织造致一世安眠。" : description);
        p.setPriceFen((int) Math.round(priceYuan * 100));
        p.setImages(JsonUtil.write(List.of(image != null && !image.isBlank() ? image : "/images/products/p01.svg")));
        p.setFeatured(featured);
        p.setStock(stock);
        p.setSales(0);
        p.setStatus("ACTIVE");
        return productRepo.save(p).getId();
    }

    @Transactional
    public void updateProduct(String id, String name, String subtitle, String description,
                              String categoryId, double priceYuan, int stock, boolean featured) {
        if (isBlank(id) || isBlank(name) || isBlank(categoryId)
                || priceYuan <= 0 || stock < 0) {
            throw BizException.bad("参数错误");
        }
        Product p = productRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("商品不存在"));
        p.setName(name);
        p.setSubtitle(isBlank(subtitle) ? null : subtitle);
        p.setDescription(isBlank(description) ? p.getDescription() : description);
        p.setCategoryId(categoryId);
        p.setPriceFen((int) Math.round(priceYuan * 100));
        p.setStock(stock);
        p.setFeatured(featured);
        productRepo.save(p);
    }

    @Transactional
    public void updateStock(String id, int stock) {
        if (isBlank(id) || stock < 0) throw BizException.bad("参数错误");
        Product p = productRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("商品不存在"));
        p.setStock(stock);
        productRepo.save(p);
    }

    @Transactional
    public void toggleProduct(String id) {
        Product p = productRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("商品不存在"));
        p.setStatus("ACTIVE".equals(p.getStatus()) ? "OFF" : "ACTIVE");
        productRepo.save(p);
    }

    @Transactional
    public String createCategory(String name, String nameEn, String tagline) {
        if (isBlank(name) || isBlank(nameEn)) throw BizException.bad("请填写分类名称与英文名");
        Category c = new Category();
        c.setSlug("cat-" + Long.toString(System.currentTimeMillis(), 36));
        c.setName(name);
        c.setNameEn(nameEn);
        c.setTagline(isBlank(tagline) ? null : tagline);
        Integer maxSort = categoryRepo.maxSort();
        c.setSort((maxSort == null ? 0 : maxSort) + 1);
        return categoryRepo.save(c).getId();
    }

    // ===================== 订单管理 =====================

    @Transactional(readOnly = true)
    public Map<String, Object> listOrders(String status, String q) {
        List<Order> all = orderRepo.findAllWithUserAndItems();
        List<Order> filtered = all.stream()
                .filter(o -> "all".equals(status) || status == null || status.equals(o.getStatus()))
                .filter(o -> q == null || q.isBlank()
                        || (o.getOrderNo() != null && o.getOrderNo().contains(q)))
                .toList();
        List<Map<String, Object>> list = filtered.stream().map(o -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", o.getId());
            m.put("orderNo", o.getOrderNo());
            m.put("status", o.getStatus());
            m.put("totalFen", o.getTotalFen());
            m.put("createdAt", o.getCreatedAt());
            m.put("paidAt", o.getPaidAt());
            m.put("payMethod", o.getPayMethod());
            m.put("userName", o.getUser() != null ? defaultIfNull(o.getUser().getName(), o.getUser().getEmail()) : "");
            m.put("items", o.getItems().stream().map(it -> {
                Map<String, Object> im = new LinkedHashMap<>();
                im.put("id", it.getId());
                im.put("nameSnap", it.getNameSnap());
                im.put("qty", it.getQty());
                im.put("priceFen", it.getPriceFen());
                return im;
            }).toList());
            return m;
        }).toList();
        return Map.of("orders", list, "status", status == null ? "all" : status, "q", q == null ? "" : q);
    }

    @Transactional
    public void updateOrderStatus(String id, String status) {
        if (!Set.of("PENDING_PAYMENT", "PAID", "SHIPPED", "COMPLETED", "CANCELLED").contains(status)) {
            throw BizException.bad("订单状态无效");
        }
        Order o = orderRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("订单不存在"));
        o.setStatus(status);
        if ("PAID".equals(status) && o.getPaidAt() == null) {
            o.setPaidAt(new Date());
        }
        orderRepo.save(o);
    }

    /** 导出全部订单 CSV（管理员） */
    @Transactional(readOnly = true)
    public String exportOrdersCsv() {
        List<Order> orders = orderRepo.findAllWithUserAndItems();
        Map<String, String> statusMap = new LinkedHashMap<>();
        statusMap.put("PENDING_PAYMENT", "待付款");
        statusMap.put("PAID", "已付款");
        statusMap.put("SHIPPED", "已发货");
        statusMap.put("COMPLETED", "已完成");
        statusMap.put("CANCELLED", "已取消");

        StringBuilder sb = new StringBuilder();
        sb.append("\uFEFF"); // BOM for Excel UTF-8
        sb.append(csvRow(new String[]{"订单号", "状态", "客户", "金额(元)", "支付方式",
                "下单时间", "支付时间", "商品"})).append("\r\n");
        for (Order o : orders) {
            String[] cols = {
                    o.getOrderNo(),
                    statusMap.getOrDefault(o.getStatus(), o.getStatus()),
                    o.getUser() != null ? defaultIfNull(o.getUser().getName(), o.getUser().getEmail()) : "",
                    String.format("%.2f", o.getTotalFen() / 100.0),
                    o.getPayMethod() != null ? FormatUtil.payMethodLabel(o.getPayMethod()) : "",
                    o.getCreatedAt() != null ? o.getCreatedAt().toInstant().toString() : "",
                    o.getPaidAt() != null ? o.getPaidAt().toInstant().toString() : "",
                    o.getItems().stream().map(it -> it.getNameSnap() + "x" + it.getQty())
                            .collect(Collectors.joining(" / "))
            };
            sb.append(csvRow(cols)).append("\r\n");
        }
        return sb.toString();
    }

    private String csvRow(String[] cols) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cols.length; i++) {
            if (i > 0) sb.append(",");
            String v = cols[i] == null ? "" : cols[i].replace("\"", "\"\"");
            sb.append("\"").append(v).append("\"");
        }
        return sb.toString();
    }

    // ===================== 客户管理 =====================

    @Transactional(readOnly = true)
    public Map<String, Object> listCustomers() {
        List<User> users = userRepo.findAllByOrderByCreatedAtDesc();
        List<Map<String, Object>> rows = new ArrayList<>();
        long totalSpent = 0;
        for (User u : users) {
            List<Order> orders = u.getOrders();
            int orderCount = orders.size();
            int paidCount = (int) orders.stream()
                    .filter(o -> Set.of("PAID", "SHIPPED", "COMPLETED").contains(o.getStatus()))
                    .count();
            long spent = orders.stream()
                    .filter(o -> Set.of("PAID", "SHIPPED", "COMPLETED").contains(o.getStatus()))
                    .mapToLong(Order::getTotalFen)
                    .sum();
            totalSpent += spent;
            Date lastOrderAt = orders.stream().map(Order::getCreatedAt)
                    .max(Date::compareTo).orElse(null);
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", u.getId());
            m.put("name", u.getName());
            m.put("email", u.getEmail());
            m.put("role", u.getRole());
            m.put("createdAt", u.getCreatedAt());
            m.put("orderCount", orderCount);
            m.put("paidCount", paidCount);
            m.put("spent", spent);
            m.put("lastOrderAt", lastOrderAt);
            rows.add(m);
        }
        rows.sort((a, b) -> {
            long d = (long) b.get("spent") - (long) a.get("spent");
            if (d != 0) return d < 0 ? -1 : 1;
            return Integer.compare((int) b.get("orderCount"), (int) a.get("orderCount"));
        });
        return Map.of("customers", rows, "totalSpent", totalSpent);
    }

    // ===================== 评论管理 =====================

    @Transactional(readOnly = true)
    public Map<String, Object> listReviews() {
        List<Review> reviews = reviewRepo.findAllWithUserAndProduct();
        List<Map<String, Object>> list = reviews.stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("rating", r.getRating());
            m.put("content", r.getContent());
            m.put("createdAt", r.getCreatedAt());
            m.put("userName", r.getUser() != null ? defaultIfNull(r.getUser().getName(), r.getUser().getEmail()) : "");
            m.put("productSlug", r.getProduct() != null ? r.getProduct().getSlug() : "");
            m.put("productName", r.getProduct() != null ? r.getProduct().getName() : "");
            return m;
        }).toList();
        double avg = reviews.isEmpty() ? 0
                : reviews.stream().mapToInt(Review::getRating).average().orElse(0);
        return Map.of("reviews", list, "avg", Math.round(avg * 10) / 10.0);
    }

    @Transactional
    public void deleteReview(String id) {
        if (isBlank(id)) throw BizException.bad("参数错误");
        reviewRepo.deleteById(id);
    }

    // ===================== 线索管理 =====================

    @Transactional(readOnly = true)
    public Map<String, Object> listLeads() {
        List<Lead> leads = leadRepo.findAllByOrderByStatusAscCreatedAtDesc();
        List<Map<String, Object>> list = leads.stream().map(l -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", l.getId());
            m.put("type", l.getType());
            m.put("name", l.getName());
            m.put("phone", l.getPhone());
            m.put("note", l.getNote());
            m.put("status", l.getStatus());
            m.put("createdAt", l.getCreatedAt());
            return m;
        }).toList();
        long newCount = leads.stream().filter(l -> "NEW".equals(l.getStatus())).count();
        return Map.of("leads", list, "newCount", newCount);
    }

    @Transactional
    public void updateLeadStatus(String id, String status) {
        if (!Set.of("NEW", "CONTACTED", "CLOSED").contains(status)) {
            throw BizException.bad("线索状态无效");
        }
        Lead l = leadRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("线索不存在"));
        l.setStatus(status);
        leadRepo.save(l);
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private String defaultIfNull(String s, String fallback) { return s != null ? s : fallback; }
}
