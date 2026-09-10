package com.zhiyun.service;

import com.zhiyun.entity.Address;
import com.zhiyun.exception.BizException;
import com.zhiyun.repository.AddressRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AddressService {

    @Autowired private AddressRepository addressRepo;

    @Transactional(readOnly = true)
    public List<Address> list(String userId) {
        return addressRepo.findByUserIdOrderByIsDefaultDescCreatedAtAsc(userId);
    }

    @Transactional
    public String create(String userId, String name, String phone, String province,
                         String city, String district, String detail, Boolean isDefault) {
        validate(name, phone, province, city, detail);
        if (Boolean.TRUE.equals(isDefault)) {
            addressRepo.findByUserIdOrderByIsDefaultDescCreatedAtAsc(userId)
                    .forEach(a -> { a.setIsDefault(false); addressRepo.save(a); });
        }
        long count = addressRepo.countByUserId(userId);
        Address a = new Address();
        a.setUserId(userId);
        a.setName(name);
        a.setPhone(phone);
        a.setProvince(province);
        a.setCity(city);
        a.setDistrict(district == null || district.isBlank() ? null : district);
        a.setDetail(detail);
        a.setIsDefault(Boolean.TRUE.equals(isDefault) || count == 0);
        return addressRepo.save(a).getId();
    }

    @Transactional
    public void update(String id, String userId, String name, String phone,
                       String province, String city, String district, String detail) {
        Address a = assertOwned(id, userId);
        validate(name, phone, province, city, detail);
        a.setName(name); a.setPhone(phone); a.setProvince(province); a.setCity(city);
        a.setDistrict(district == null || district.isBlank() ? null : district);
        a.setDetail(detail);
        addressRepo.save(a);
    }

    @Transactional
    public void setDefault(String id, String userId) {
        Address a = assertOwned(id, userId);
        addressRepo.findByUserIdOrderByIsDefaultDescCreatedAtAsc(userId)
                .forEach(x -> { x.setIsDefault(false); addressRepo.save(x); });
        a.setIsDefault(true);
        addressRepo.save(a);
    }

    @Transactional
    public void delete(String id, String userId) {
        Address a = assertOwned(id, userId);
        boolean wasDefault = Boolean.TRUE.equals(a.getIsDefault());
        addressRepo.delete(a);
        addressRepo.flush();
        if (wasDefault) {
            addressRepo.findFirstByUserIdOrderByCreatedAtAsc(userId).ifPresent(next -> {
                next.setIsDefault(true);
                addressRepo.save(next);
            });
        }
    }

    private Address assertOwned(String id, String userId) {
        Address a = addressRepo.findById(id).orElseThrow(() -> BizException.notFound("地址不存在"));
        if (!userId.equals(a.getUserId())) throw BizException.notFound("地址不存在");
        return a;
    }

    private void validate(String name, String phone, String province, String city, String detail) {
        if (isBlank(name) || isBlank(phone) || isBlank(province) || isBlank(city) || isBlank(detail)) {
            throw BizException.bad("请填写完整地址信息");
        }
    }

    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
