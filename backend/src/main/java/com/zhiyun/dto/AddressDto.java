package com.zhiyun.dto;

import com.zhiyun.entity.Address;

public record AddressDto(
        String id, String userId, String name, String phone,
        String province, String city, String district, String detail,
        Boolean isDefault, Object createdAt
) {
    public static AddressDto from(Address a) {
        return new AddressDto(a.getId(), a.getUserId(), a.getName(), a.getPhone(),
                a.getProvince(), a.getCity(), a.getDistrict(), a.getDetail(),
                a.getIsDefault(), a.getCreatedAt());
    }
}
