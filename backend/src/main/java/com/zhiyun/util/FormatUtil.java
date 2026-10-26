package com.zhiyun.util;

import java.text.DecimalFormat;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;

/** 移植自 lib/format.ts — 金额、日期、订单号、姓名脱敏、状态映射 */
public final class FormatUtil {

    private FormatUtil() {}

    // DateTimeFormatter 线程安全，可静态共享
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy年M月d日");
    private static final DateTimeFormatter DATETIME_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final DateTimeFormatter ORDER_NO_FMT = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
    private static final ZoneId ZONE = ZoneId.systemDefault();

    public static String formatDate(Date d) {
        return d == null ? "" : DATE_FMT.format(d.toInstant().atZone(ZONE));
    }

    public static String formatDateTime(Date d) {
        return d == null ? "" : DATETIME_FMT.format(d.toInstant().atZone(ZONE));
    }

    private static final AtomicInteger SEQ = new AtomicInteger(0);

    /**
     * 订单号：ZY20260909142530123-4567
     * 时间戳精确到毫秒 + 进程内自增序列 + 随机后缀，极大降低 unique 冲突概率
     */
    public static String genOrderNo() {
        Date now = new Date();
        int seq = SEQ.incrementAndGet() % 1000;
        int rand = ThreadLocalRandom.current().nextInt(1000, 10000);
        return "ZY" + ORDER_NO_FMT.format(now.toInstant().atZone(ZONE))
                + String.format("-%03d-%04d", seq, rand);
    }

    /** 姓名脱敏：张三 → 张**， Leon → L*** */
    public static String maskName(String name) {
        String n = name == null ? "" : name.trim();
        if (n.isEmpty()) return "匿名用户";
        if (n.matches("^[\\u4e00-\\u9fa5]+$")) {
            if (n.length() <= 1) return n + "**";
            return n.charAt(0) + repeat("*", Math.min(n.length() - 1, 2));
        }
        return n.charAt(0) + repeat("*", Math.max(n.length() - 1, 2));
    }

    private static String repeat(String s, int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) sb.append(s);
        return sb.toString();
    }

    public static final Map<String, String> PAY_METHOD_LABEL = new HashMap<>();
    static {
        PAY_METHOD_LABEL.put("WECHAT", "微信支付");
        PAY_METHOD_LABEL.put("ALIPAY", "支付宝");
        PAY_METHOD_LABEL.put("CARD", "银行卡");
    }

    public static String payMethodLabel(String key) {
        if (key == null) return "";
        return PAY_METHOD_LABEL.getOrDefault(key, key);
    }
}
