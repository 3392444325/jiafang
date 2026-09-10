package com.zhiyun.repository;

import com.zhiyun.entity.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.Optional;

public interface SessionRepository extends JpaRepository<Session, String> {
    @Query("select s from Session s left join fetch s.user where s.token = :token")
    Optional<Session> findByToken(String token);

    void deleteByToken(String token);

    /** 删除全部已过期会话，返回删除条数 */
    long deleteByExpiresAtBefore(Date time);
}
