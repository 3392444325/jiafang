package com.zhiyun.controller;

import com.zhiyun.service.LeadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 商机线索提交 —— 移植自 app/api/leads/route.ts
 * 招商 / 团购 / 合作表单共用此端点
 */
@RestController
@RequestMapping("/leads")
public class LeadController {

    @Autowired private LeadService leadService;

    @PostMapping
    public Map<String, Object> submit(@RequestBody Map<String, Object> body) {
        String id = leadService.submit(
                (String) body.get("type"), (String) body.get("name"),
                (String) body.get("phone"), (String) body.get("note"));
        return Map.of("ok", true, "id", id);
    }
}
