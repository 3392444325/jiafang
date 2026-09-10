package com.zhiyun.controller;

import com.zhiyun.dto.Ok;
import com.zhiyun.dto.SafeUser;
import com.zhiyun.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 认证 —— 移植自 app/api/auth 下各 route.ts
 * POST /api/auth/register  注册并下发会话 cookie
 * POST /api/auth/login     登录并合并游客购物车
 * POST /api/auth/logout    注销当前会话
 * GET  /api/auth/me        当前登录用户信息
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired private AuthService authService;

    @PostMapping("/register")
    public Map<String, Object> register(@RequestBody Map<String, Object> body) {
        SafeUser u = authService.register(
                (String) body.get("email"),
                (String) body.get("password"),
                (String) body.get("name"));
        return Map.of("ok", true, "user", Map.of("name", u.name(), "role", u.role()));
    }

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, Object> body) {
        SafeUser u = authService.login(
                (String) body.get("email"),
                (String) body.get("password"));
        return Map.of("ok", true, "user", Map.of("name", u.name(), "role", u.role()));
    }

    @PostMapping("/logout")
    public Ok logout() {
        authService.logoutUser();
        return Ok.yes();
    }

    @GetMapping("/me")
    public Map<String, Object> me() {
        SafeUser u = authService.getCurrentUser();
        if (u == null) return Map.of("user", Map.of());
        return Map.of("user", Map.of(
                "id", u.id(),
                "email", u.email(),
                "name", u.name(),
                "role", u.role()));
    }
}
