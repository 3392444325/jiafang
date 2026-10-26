package com.zhiyun.repository;

import com.zhiyun.entity.SiteContent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SiteContentRepository extends JpaRepository<SiteContent, String> {
    Optional<SiteContent> findByContentKey(String contentKey);
}
