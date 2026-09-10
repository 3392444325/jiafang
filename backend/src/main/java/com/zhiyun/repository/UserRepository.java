package com.zhiyun.repository;

import com.zhiyun.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);

    @Query("select u from User u order by u.createdAt desc")
    List<User> findAllByOrderByCreatedAtDesc();
}
