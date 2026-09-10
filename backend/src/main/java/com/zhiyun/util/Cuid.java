package com.zhiyun.util;

import java.security.SecureRandom;
import java.time.Instant;

/**
 * 生成 cuid 风格的字符串主键，保持与原 Prisma(cuid) 一致的 24 位字符格式。
 */
public final class Cuid {
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final char[] ALPHABET =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();

    private Cuid() {}

    public static String next() {
        long timestamp = Instant.now().toEpochMilli();
        StringBuilder sb = new StringBuilder(24);
        sb.append('c');
        // 基于时间戳的 base36 编码
        sb.append(Long.toString(timestamp, 36));
        // 随机填充至 24 位
        while (sb.length() < 24) {
            sb.append(ALPHABET[RANDOM.nextInt(ALPHABET.length)]);
        }
        return sb.substring(0, 24);
    }
}
