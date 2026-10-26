package com.zhiyun.service;

import com.zhiyun.entity.News;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** 品牌动态（新闻）业务：后台 CRUD + 前台只读已发布文章 */
@Service
public class NewsService {

    @Autowired private NewsRepository newsRepo;

    // ===================== 后台 =====================

    @Transactional(readOnly = true)
    public List<Map<String, Object>> listAll() {
        return newsRepo.findAllByOrderByCreatedAtDesc().stream()
                .map(n -> toMap(n, true))
                .toList();
    }

    @Transactional
    public String create(String title, String category, String cover,
                         String excerpt, String content, boolean featured, boolean published) {
        News n = new News();
        n.setTitle(requireTitle(title));
        n.setCategory(isBlank(category) ? "品牌新闻" : category);
        n.setCover(blankToNull(cover));
        n.setExcerpt(blankToNull(excerpt));
        n.setContent(content == null ? "" : content);
        n.setFeatured(featured);
        applyPublish(n, published);
        return newsRepo.save(n).getId();
    }

    @Transactional
    public void update(String id, String title, String category, String cover,
                       String excerpt, String content, boolean featured, boolean published) {
        News n = newsRepo.findById(id)
                .orElseThrow(() -> BizException.notFound("文章不存在"));
        n.setTitle(requireTitle(title));
        n.setCategory(isBlank(category) ? n.getCategory() : category);
        n.setCover(blankToNull(cover));
        n.setExcerpt(blankToNull(excerpt));
        if (content != null) n.setContent(content);
        n.setFeatured(featured);
        applyPublish(n, published);
        newsRepo.save(n);
    }

    @Transactional
    public void delete(String id) {
        if (isBlank(id)) throw BizException.bad("参数错误");
        newsRepo.deleteById(id);
    }

    // ===================== 前台 =====================

    @Transactional(readOnly = true)
    public List<Map<String, Object>> publishedList() {
        // 列表不携带正文 content，减小响应体积（正文走详情接口）
        return newsRepo.findByPublishedTrueOrderByFeaturedDescCreatedAtDesc().stream()
                .map(n -> toMap(n, false))
                .toList();
    }

    @Transactional(readOnly = true)
    public Map<String, Object> publishedDetail(String id) {
        News n = newsRepo.findByIdAndPublishedTrue(id)
                .orElseThrow(() -> BizException.notFound("文章不存在或未发布"));
        return toMap(n, true);
    }

    // ===================== 内部 =====================

    private void applyPublish(News n, boolean published) {
        n.setPublished(published);
        if (published && n.getPublishedAt() == null) n.setPublishedAt(new Date());
    }

    private Map<String, Object> toMap(News n, boolean includeContent) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", n.getId());
        m.put("title", n.getTitle());
        m.put("category", n.getCategory());
        m.put("cover", n.getCover());
        m.put("excerpt", n.getExcerpt());
        if (includeContent) m.put("content", n.getContent());
        m.put("featured", n.getFeatured());
        m.put("published", n.getPublished());
        m.put("publishedAt", n.getPublishedAt());
        m.put("createdAt", n.getCreatedAt());
        return m;
    }

    private String requireTitle(String title) {
        if (isBlank(title)) throw BizException.bad("请填写文章标题");
        return title.trim();
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
    private String blankToNull(String s) { return isBlank(s) ? null : s; }
}
