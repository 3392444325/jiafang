package com.zhiyun.repository;

import com.zhiyun.entity.Address;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AddressRepository extends JpaRepository<Address, String> {
    List<Address> findByUserIdOrderByIsDefaultDescCreatedAtAsc(String userId);
    long countByUserId(String userId);
    Optional<Address> findFirstByUserIdOrderByCreatedAtAsc(String userId);
}
