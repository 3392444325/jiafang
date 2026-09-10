package com.zhiyun.dto;

/** 商品卡片 DTO（对应前端 ProductCard） */
public record CardProduct(
        String slug, String name, String subtitle,
        Integer priceFen, Integer compareAtFen, String image, String tag
) {}
