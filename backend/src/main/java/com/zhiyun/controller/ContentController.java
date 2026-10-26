package com.zhiyun.controller;

import com.zhiyun.service.NewsService;
import com.zhiyun.service.SiteContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 品牌官网公开内容接口（无需登录）
 * GET /api/content    —— site_content 全量配置 + 已发布新闻列表（品牌页/新闻页数据源）
 * GET /api/news/{id}  —— 已发布文章详情（未发布返回 404）
 */
@RestController
public class ContentController {

    @Autowired private SiteContentService siteContentService;
    @Autowired private NewsService newsService;

    @GetMapping("/content")
    public Map<String, Object> content() {
        return Map.of(
                "content", siteContentService.getAllPublic(),
                "news", newsService.publishedList());
    }

    @GetMapping("/news/{id}")
    public Map<String, Object> newsDetail(@PathVariable String id) {
        return newsService.publishedDetail(id);
    }
}
