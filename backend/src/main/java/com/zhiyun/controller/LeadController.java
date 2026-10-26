package com.zhiyun.controller;

import com.zhiyun.exception.BizException;
import com.zhiyun.service.LeadService;
import com.zhiyun.util.RateLimit;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 商机线索提交 —— 移植自 app/api/leads/route.ts
 * 招商 / 团购 / 合作表单共用此端点
 * 同一 IP 每小时最多提交 5 次，超出返回 429
 */
@RestController
@RequestMapping("/leads")
public class LeadController {

    @Autowired private LeadService leadService;

    @PostMapping
    public Map<String, Object> submit(@RequestBody Map<String, Object> body, HttpServletRequest request) {
        if (!RateLimit.tryAcquire("lead:" + RateLimit.clientIp(request), 5, 60 * 60 * 1000L)) {
            throw new BizException(429, "提交过于频繁，请稍后再试");
        }
        String id = leadService.submit(
                (String) body.get("type"), (String) body.get("name"),
                (String) body.get("phone"), (String) body.get("note"));
        return Map.of("ok", true, "id", id);
    }
}
