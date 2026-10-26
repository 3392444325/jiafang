package com.zhiyun.controller;

import com.zhiyun.dto.SafeUser;
import com.zhiyun.exception.BizException;
import com.zhiyun.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 图片上传 —— 供页面设计后台（/designer）使用
 * POST /api/designer/upload：multipart 字段 file，仅 ADMIN
 * 保存到后端工作目录 uploads/yyyyMMdd/ 下，返回 /api/uploads/... 访问地址
 */
@RestController
public class UploadController {

    private static final long MAX_SIZE = 5 * 1024 * 1024; // 5MB
    // 不允许 svg：文本格式可内嵌 <script>，同源打开时会形成存储型 XSS
    private static final Set<String> ALLOWED_EXT = Set.of("jpg", "jpeg", "png", "webp", "gif");

    @Autowired private AuthService authService;

    @PostMapping("/designer/upload")
    public Map<String, Object> upload(@RequestParam("file") MultipartFile file) {
        requireAdmin();
        if (file == null || file.isEmpty()) throw BizException.bad("请选择图片文件");
        if (file.getSize() > MAX_SIZE) throw BizException.bad("图片大小不能超过 5MB");

        String ext = extOf(file.getOriginalFilename());
        if (!ALLOWED_EXT.contains(ext)) throw BizException.bad("仅支持 jpg / png / webp / gif 图片");

        try {
            String dateDir = new SimpleDateFormat("yyyyMMdd").format(new Date());
            Path dir = Paths.get("uploads").toAbsolutePath().resolve(dateDir);
            Files.createDirectories(dir);
            String filename = UUID.randomUUID().toString().replace("-", "") + "." + ext;
            Path target = dir.resolve(filename);
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            return Map.of("ok", true, "url", "/api/uploads/" + dateDir + "/" + filename);
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            throw BizException.bad("图片保存失败，请稍后重试");
        }
    }

    private String extOf(String name) {
        if (name == null) return "";
        int i = name.lastIndexOf('.');
        return i < 0 ? "" : name.substring(i + 1).toLowerCase();
    }

    private void requireAdmin() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) throw BizException.unauthorized("请先登录");
        if (!"ADMIN".equals(u.role())) throw BizException.forbidden("无权限操作");
    }
}
