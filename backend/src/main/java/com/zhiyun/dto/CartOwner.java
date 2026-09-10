package com.zhiyun.dto;

/** 购物车归属：登录用户→userId；游客→sessionId */
public record CartOwner(String userId, String sessionId) {
    public static CartOwner user(String userId) { return new CartOwner(userId, null); }
    public static CartOwner session(String sessionId) { return new CartOwner(null, sessionId); }
    public boolean isUser() { return userId != null; }
}
