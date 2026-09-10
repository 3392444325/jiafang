package com.zhiyun.dto;

public record CartEntry(
        String id, String slug, String name, String image,
        Integer priceFen, Integer qty, Integer stock
) {}
