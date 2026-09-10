package com.zhiyun.util;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

/** 移植自 lib/format.ts — 金额、日期、订单号、姓名脱敏、状态映射 */
public final class FormatUtil {

    private FormatUtil() {}

    private static final DecimalFormat YUAN_FMT = new DecimalFormat("#,###");
    private static final DecimalFormat FEN_NUM_FMT = new DecimalFormat("#,##0.00");

    /** 分 → ¥1,299 */
    public static String yuan(long fen) {
        return "¥" + YUAN_FMT.format(fen / 100.0);
    }

    /** 分 → 1,299.00 */
    public static String fenToNum(long fen) {
        return FEN_NUM_FMT.format(fen / 100.0);
    }

    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("yyyy年M月d日");
    private static final SimpleDateFormat DATETIME_FMT = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    public static String formatDate(Date d) {
        return d == null ? "" : DATE_FMT.format(d);
    }

    public static String formatDateTime(Date d) {
        return d == null ? "" : DATETIME_FMT.format(d);
    }

    /** 订单号：ZY20260908-123456 */
    public static String genOrderNo() {
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        int rand = ThreadLocalRandom.current().nextInt(100000, 1000000);
        return "ZY" + sdf.format(now) + "-" + rand;
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
