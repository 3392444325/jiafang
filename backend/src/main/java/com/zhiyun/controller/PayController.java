package com.zhiyun.controller;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.exception.BizException;
import com.zhiyun.service.AuthService;
import com.zhiyun.service.SiteContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 收款码支付 —— 个人收款码 + 人工确认收款模式
 * GET /api/pay/qrcodes：返回商家收款码配置（pay.* 前缀），需登录
 * 配置由管理员在页面设计后台（/designer/pay）维护，存 site_content
 */
@RestController
public class PayController {

    @Autowired private AuthService authService;
    @Autowired private SiteContentService siteContentService;

    @GetMapping("/pay/qrcodes")
    public Map<String, Object> qrcodes() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        return Map.of("config", siteContentService.getPayConfig());
    }
}
