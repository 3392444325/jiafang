package com.zhiyun.service;

import com.zhiyun.dto.CardProduct;
import com.zhiyun.dto.CategoryBrief;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.dto.ProductListResponse;
import com.zhiyun.entity.*;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.*;
import com.zhiyun.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ProductService {

    @Autowired private ProductRepository productRepo;
    @Autowired private CategoryRepository categoryRepo;
    @Autowired private ReviewRepository reviewRepo;
    @Autowired private OrderItemRepository orderItemRepo;
    @Autowired private SiteContentService siteContentService;

    private CardProduct toCard(Product p) {
        return toCard(p, null);
    }

    private CardProduct toCard(Product p, String tag) {
        String image = JsonUtil.parseStringList(p.getImages()).isEmpty()
                ? "/images/products/p01.jpg"
                : JsonUtil.parseStringList(p.getImages()).get(0);
        String resolvedTag = tag != null ? tag
                : (p.getCompareAtFen() != null ? "限时礼遇" : null);
        return new CardProduct(p.getSlug(), p.getName(), p.getSubtitle(),
                p.getPriceFen(), p.getCompareAtFen(), image, resolvedTag);
    }

    private CategoryBrief toBrief(Category c) {
        return new CategoryBrief(c.getSlug(), c.getName(), c.getNameEn(), c.getTagline(), c.getSort());
    }

    /** 首页数据：分类(各取1件)、评价(6)、联名商品 */
    @Transactional(readOnly = true)
    public Map<String, Object> getHomeData() {
        List<Category> categories = categoryRepo.findAllByOrderBySortAsc();
        List<Product> allActive = productRepo.findAllWithCategory();
        Map<String, List<Product>> prodsByCategory = allActive.stream()
                .collect(Collectors.groupingBy(Product::getCategoryId));
        List<Map<String, Object>> catList = new ArrayList<>();
        for (Category c : categories) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("slug", c.getSlug());
            m.put("name", c.getName());
            m.put("nameEn", c.getNameEn());
            m.put("tagline", c.getTagline());
            m.put("sort", c.getSort());
            prodsByCategory.computeIfAbsent(c.getId(), k -> new ArrayList<>())
                    .stream()
                    .filter(p -> "ACTIVE".equals(p.getStatus()))
                    .limit(1)
                    .findFirst()
                    .ifPresentOrElse(
                            p -> m.put("image", JsonUtil.parseStringList(p.getImages()).stream().findFirst()
                                    .orElse("/images/scenes/scene-1.jpg")),
                            () -> m.put("image", "/images/scenes/scene-1.jpg"));
            catList.add(m);
        }
        List<Review> reviews = reviewRepo.findTop6WithUserAndProduct();
        List<Map<String, Object>> reviewList = reviews.stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("rating", r.getRating());
            m.put("content", r.getContent());
            m.put("createdAt", r.getCreatedAt());
            m.put("userName", r.getUser().getName());
            m.put("productName", r.getProduct().getName());
            return m;
        }).toList();
        Product collab = productRepo.findBySlug("monet-garden-set").orElse(null);
        Map<String, Object> collabMap = null;
        if (collab != null && "ACTIVE".equals(collab.getStatus())) {
            collabMap = new LinkedHashMap<>();
            collabMap.put("slug", collab.getSlug());
            collabMap.put("name", collab.getName());
            collabMap.put("priceFen", collab.getPriceFen());
            collabMap.put("compareAtFen", collab.getCompareAtFen());
            collabMap.put("images", JsonUtil.parseStringList(collab.getImages()));
            collabMap.put("status", collab.getStatus());
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("categories", catList);
        res.put("reviews", reviewList);
        res.put("collab", collabMap);
        // 页面设计后台配置的内容（轮播/版块图片与文案），前台据此动态渲染
        res.put("content", siteContentService.getAll());
        return res;
    }

    /** 商城首页数据 */
    @Transactional(readOnly = true)
    public Map<String, Object> getShopData() {
        List<Product> featured = productRepo.findFeaturedActive().stream().limit(6).toList();
        List<Product> hotSales = productRepo.findActiveOrderBySalesDesc().stream().limit(4).toList();
        List<Category> categories = categoryRepo.findAllByOrderBySortAsc();

        List<CardProduct> featuredCards = new ArrayList<>();
        for (Product p : featured) {
            String tag = "monet-garden-set".equals(p.getSlug()) ? "大师联名"
                    : "wedding-gift-box".equals(p.getSlug()) ? "婚嫁臻礼"
                    : (p.getCompareAtFen() != null ? "限时礼遇" : null);
            featuredCards.add(toCard(p, tag));
        }
        List<Map<String, Object>> hotList = hotSales.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("slug", p.getSlug());
            m.put("name", p.getName());
            m.put("priceFen", p.getPriceFen());
            m.put("sales", p.getSales());
            return m;
        }).toList();
        List<CategoryBrief> catList = categories.stream().map(this::toBrief).toList();

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("featured", featuredCards);
        res.put("hotSales", hotList);
        res.put("categories", catList);
        res.put("content", siteContentService.getAll());
        return res;
    }

    /** 产品列表：cat/sort/q 筛选 */
    @Transactional(readOnly = true)
    public ProductListResponse getProducts(String cat, String sort, String q) {
        List<Category> categories = categoryRepo.findAllByOrderBySortAsc();
        Category active = categories.stream().filter(c -> c.getSlug().equals(cat)).findFirst().orElse(null);

        List<Product> products = productRepo.findAllWithCategory();
        List<Product> filtered = products.stream()
                .filter(p -> "ACTIVE".equals(p.getStatus()))
                .filter(p -> active == null || active.getId().equals(p.getCategoryId()))
                .filter(p -> q == null || q.isBlank()
                        || (p.getName() != null && p.getName().contains(q))
                        || (p.getSubtitle() != null && p.getSubtitle().contains(q))
                        || (p.getDescription() != null && p.getDescription().contains(q)))
                .toList();

        List<Product> sorted = new ArrayList<>(filtered);
        switch (sort) {
            case "price-asc" -> sorted.sort(Comparator.comparingInt(Product::getPriceFen));
            case "price-desc" -> sorted.sort(Comparator.comparingInt(Product::getPriceFen).reversed());
            case "sales" -> sorted.sort(Comparator.comparingInt(Product::getSales).reversed());
            default -> sorted.sort(Comparator.comparing(Product::getCreatedAt).reversed());
        }

        List<CardProduct> cards = sorted.stream().map(this::toCard).toList();
        boolean grouped = active == null && (q == null || q.isBlank()) && "default".equals(sort);

        String eyebrow = (q != null && !q.isBlank()) ? "Search" : (active != null ? "Collection" : "Products");
        String title = (q != null && !q.isBlank()) ? "「" + q + "」" : (active != null ? active.getName() : "产品展示");
        String desc = (q != null && !q.isBlank()) ? "为你找到 " + sorted.size() + " 件相关商品"
                : (active != null ? active.getTagline() : "被芯 · 枕芯 · 床品套件 · 夏凉 · 礼盒 — 为每一种睡眠而生");

        return new ProductListResponse(cards, categories.stream().map(this::toBrief).toList(),
                grouped, title, eyebrow, desc);
    }

    /** 商品详情 */
    @Transactional(readOnly = true)
    public Map<String, Object> getProductDetail(String slug, SafeUser currentUser) {
        Product product = productRepo.findBySlug(slug)
                .orElseThrow(() -> BizException.notFound("商品不存在"));
        if (!"ACTIVE".equals(product.getStatus())) throw BizException.notFound("商品不存在");

        List<String> images = JsonUtil.parseStringList(product.getImages());
        List<Map<String, String>> specs = JsonUtil.parseSpecList(product.getSpecs());
        List<Review> reviews = reviewRepo.findByProductIdWithUser(product.getId());

        double avgRating = reviews.isEmpty() ? 5.0
                : reviews.stream().mapToInt(Review::getRating).average().orElse(5.0);

        List<Product> related = productRepo.findAllWithCategory().stream()
                .filter(p -> p.getCategoryId().equals(product.getCategoryId())
                        && !p.getId().equals(product.getId()) && "ACTIVE".equals(p.getStatus()))
                .limit(4).toList();

        boolean canReview = false;
        if (currentUser != null) {
            boolean alreadyReviewed = reviewRepo.findFirstByUserIdAndProductId(
                    currentUser.id(), product.getId()).isPresent();
            boolean purchased = orderItemRepo.findFirstPurchased(product.getId(), currentUser.id()).isPresent();
            canReview = !alreadyReviewed && purchased;
        }

        Category cat = product.getCategory();
        Map<String, Object> categoryMap = new LinkedHashMap<>();
        categoryMap.put("slug", cat.getSlug());
        categoryMap.put("name", cat.getName());
        categoryMap.put("nameEn", cat.getNameEn());

        List<Map<String, Object>> reviewList = reviews.stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("rating", r.getRating());
            m.put("content", r.getContent());
            m.put("createdAt", r.getCreatedAt());
            m.put("userName", r.getUser() != null ? r.getUser().getName() : null);
            return m;
        }).toList();

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("id", product.getId());
        res.put("slug", product.getSlug());
        res.put("name", product.getName());
        res.put("subtitle", product.getSubtitle());
        res.put("description", product.getDescription());
        res.put("story", product.getStory());
        res.put("priceFen", product.getPriceFen());
        res.put("compareAtFen", product.getCompareAtFen());
        res.put("images", images);
        res.put("material", product.getMaterial());
        res.put("specs", specs);
        res.put("stock", product.getStock());
        res.put("sales", product.getSales());
        res.put("category", categoryMap);
        res.put("reviews", reviewList);
        res.put("related", related.stream().map(this::toCard).toList());
        res.put("avgRating", Math.round(avgRating * 10) / 10.0);
        res.put("canReview", canReview);
        res.put("loggedIn", currentUser != null);
        return res;
    }
}
