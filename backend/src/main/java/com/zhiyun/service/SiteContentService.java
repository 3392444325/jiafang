package com.zhiyun.service;

import com.zhiyun.entity.SiteContent;
import com.zhiyun.repository.SiteContentRepository;
import com.zhiyun.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

/** 页面设计内容服务：读取/保存 site_content 的 key-value 配置 */
@Service
public class SiteContentService {

    @Autowired private SiteContentRepository repo;

    /** 读取全部内容配置：key -> 解析后的 JSON（对象/数组） */
    @Transactional(readOnly = true)
    public Map<String, Object> getAll() {
        Map<String, Object> map = new LinkedHashMap<>();
        for (SiteContent c : repo.findAll()) {
            try {
                map.put(c.getContentKey(), JsonUtil.parseValue(c.getContentJson()));
            } catch (Exception ignored) {
                // 单条损坏不影响整体
            }
        }
        return map;
    }

    /** 公开内容配置：过滤 pay.* 前缀键，防止收款码配置经公开 /api/content 泄露 */
    @Transactional(readOnly = true)
    public Map<String, Object> getAllPublic() {
        Map<String, Object> map = new LinkedHashMap<>();
        for (SiteContent c : repo.findAll()) {
            String key = c.getContentKey();
            if (key == null || key.startsWith("pay.")) continue;
            try {
                map.put(key, JsonUtil.parseValue(c.getContentJson()));
            } catch (Exception ignored) {
                // 单条损坏不影响整体
            }
        }
        return map;
    }

    /** 收款码配置：读取 pay.* 前缀键，去掉前缀后返回（仅登录用户经 /pay/qrcodes 获取） */
    @Transactional(readOnly = true)
    public Map<String, Object> getPayConfig() {
        Map<String, Object> config = new LinkedHashMap<>();
        for (SiteContent c : repo.findAll()) {
            String key = c.getContentKey();
            if (key == null || !key.startsWith("pay.")) continue;
            try {
                config.put(key.substring("pay.".length()), JsonUtil.parseValue(c.getContentJson()));
            } catch (Exception ignored) {
                // 单条损坏不影响整体
            }
        }
        return config;
    }

    /** 批量保存（upsert）：body 的每个 entry 作为一条 key-value */
    @Transactional
    public void saveAll(Map<String, Object> body) {
        if (body == null) return;
        for (Map.Entry<String, Object> e : body.entrySet()) {
            String key = e.getKey();
            if (key == null || key.isBlank() || key.length() > 64) continue;
            SiteContent c = repo.findByContentKey(key).orElseGet(SiteContent::new);
            c.setContentKey(key);
            c.setContentJson(JsonUtil.write(e.getValue()));
            c.setUpdatedAt(new Date());
            repo.save(c);
        }
    }
}
