package com.zhiyun.repository;

import com.zhiyun.entity.Lead;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LeadRepository extends JpaRepository<Lead, String> {
    List<Lead> findAllByOrderByStatusAscCreatedAtDesc();
    long countByStatus(String status);
}
