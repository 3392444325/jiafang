package com.zhiyun.exception;

/** 业务异常：携带 HTTP 状态码与错误消息 */
public class BizException extends RuntimeException {
    private final int status;
    public BizException(int status, String message) {
        super(message);
        this.status = status;
    }
    public int getStatus() { return status; }

    public static BizException bad(String msg) { return new BizException(400, msg); }
    public static BizException unauthorized(String msg) { return new BizException(401, msg); }
    public static BizException forbidden(String msg) { return new BizException(403, msg); }
    public static BizException notFound(String msg) { return new BizException(404, msg); }
    public static BizException conflict(String msg) { return new BizException(409, msg); }
    public static BizException tooMany(String msg) { return new BizException(429, msg); }
}
