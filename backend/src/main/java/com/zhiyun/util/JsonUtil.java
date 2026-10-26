package com.zhiyun.util;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/** 解析存储为 TEXT 的 JSON 字段（images、specs、addressJson） */
public final class JsonUtil {
    private JsonUtil() {}
    private static final ObjectMapper MAPPER = new ObjectMapper();

    public static List<String> parseStringList(String json) {
        if (json == null || json.isBlank()) return Collections.emptyList();
        try {
            return MAPPER.readValue(json,
                    MAPPER.getTypeFactory().constructCollectionType(List.class, String.class));
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    /** 解析任意 JSON（对象/数组/标量）为 Java 对象，失败返回 null */
    public static Object parseValue(String json) {
        if (json == null || json.isBlank()) return null;
        try {
            return MAPPER.readValue(json, Object.class);
        } catch (Exception e) {
            return null;
        }
    }

    public static List<Map<String, String>> parseSpecList(String json) {
        if (json == null || json.isBlank()) return Collections.emptyList();
        try {
            return MAPPER.readValue(json,
                    MAPPER.getTypeFactory().constructCollectionType(List.class,
                            MAPPER.getTypeFactory().constructMapType(Map.class, String.class, String.class)));
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    public static String write(Object obj) {
        try {
            return MAPPER.writeValueAsString(obj);
        } catch (Exception e) {
            return "null";
        }
    }
}
