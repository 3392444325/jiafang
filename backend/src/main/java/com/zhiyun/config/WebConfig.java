package com.zhiyun.config;

import jakarta.servlet.Filter;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("http://localhost:*", "http://127.0.0.1:*")
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }

    /** 上传图片的静态访问映射：/uploads/** → 工作目录 uploads/（实际访问路径 /api/uploads/**） */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String location = Paths.get("uploads").toAbsolutePath().toUri().toString();
        if (!location.endsWith("/")) location += "/";
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(location);
    }

    /** 上传文件的响应加固：禁用 MIME 嗅探，防止浏览器把响应按脚本/HTML 解释 */
    @Bean
    public FilterRegistrationBean<Filter> uploadsSecurityHeaderFilter() {
        FilterRegistrationBean<Filter> reg = new FilterRegistrationBean<>();
        // url pattern 相对 context（/api），即匹配 /api/uploads/*
        reg.setFilter((req, res, chain) -> {
            ((HttpServletResponse) res).setHeader("X-Content-Type-Options", "nosniff");
            chain.doFilter(req, res);
        });
        reg.addUrlPatterns("/uploads/*");
        return reg;
    }
}
