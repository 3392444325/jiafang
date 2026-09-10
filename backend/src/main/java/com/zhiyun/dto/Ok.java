package com.zhiyun.dto;

/** 统一成功响应：{"ok": true} 或 {"ok": true, "..."} */
public record Ok(boolean ok) {
    public static Ok yes() { return new Ok(true); }
}
