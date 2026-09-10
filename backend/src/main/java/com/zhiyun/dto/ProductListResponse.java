package com.zhiyun.dto;

import java.util.List;

public record ProductListResponse(
        List<CardProduct> cards,
        List<CategoryBrief> categories,
        boolean grouped,
        String title,
        String eyebrow,
        String desc
) {}
