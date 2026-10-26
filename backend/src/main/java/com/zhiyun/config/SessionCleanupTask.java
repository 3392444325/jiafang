package com.zhiyun.config;

import com.zhiyun.repository.CartItemRepository;
import com.zhiyun.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

/** 定时清理过期会话，防止 sessions 表无限膨胀 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SessionCleanupTask {

    private final SessionRepository sessionRepo;
    private final CartItemRepository cartRepo;

    /** 每小时清理一次过期会话及其遗留的孤儿购物车条目 */
    @Scheduled(fixedDelay = 3_600_000, initialDelay = 60_000)
    @Transactional
    public void cleanExpiredSessions() {
        Date now = new Date();
        // 先清理挂在过期会话上的游客购物车条目，避免外键约束阻塞会话删除
        long orphans = cartRepo.deleteBySession_ExpiresAtBefore(now);
        long removed = sessionRepo.deleteByExpiresAtBefore(now);
        if (removed > 0 || orphans > 0) {
            log.info("已清理 {} 条过期会话、{} 条孤儿购物车条目", removed, orphans);
        }
    }
}