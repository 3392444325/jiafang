package com.zhiyun.config;

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

    /** 每小时清理一次过期会话 */
    @Scheduled(fixedDelay = 3_600_000, initialDelay = 60_000)
    @Transactional
    public void cleanExpiredSessions() {
        long removed = sessionRepo.deleteByExpiresAtBefore(new Date());
        if (removed > 0) log.info("已清理 {} 条过期会话", removed);
    }
}