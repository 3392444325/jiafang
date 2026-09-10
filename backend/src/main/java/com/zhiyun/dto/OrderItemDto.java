package com.zhiyun.dto;

public record OrderItemDto(
        String id, String productId, String nameSnap, String imageSnap,
        Integer priceFen, Integer qty
) {}
