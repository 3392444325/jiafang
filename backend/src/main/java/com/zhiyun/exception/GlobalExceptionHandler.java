package com.zhiyun.exception;

import com.zhiyun.dto.ApiError;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BizException.class)
    public ResponseEntity<ApiError> handleBiz(BizException ex) {
        return ResponseEntity.status(ex.getStatus()).body(new ApiError(ex.getMessage()));
    }

    /** 请求体缺失/格式错误 → 400 */
    @ExceptionHandler({HttpMessageNotReadableException.class, MethodArgumentTypeMismatchException.class})
    public ResponseEntity<ApiError> handleBadRequest(Exception ex) {
        return ResponseEntity.badRequest().body(new ApiError("请求参数错误"));
    }

    /** 上传文件超过 multipart 上限 → 400（默认兜底会变成 500） */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ApiError> handleMaxUpload(MaxUploadSizeExceededException ex) {
        return ResponseEntity.badRequest().body(new ApiError("图片不能超过 5MB"));
    }

    /** 唯一约束/外键冲突 → 409 */
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiError> handleConflict(DataIntegrityViolationException ex) {
        log.warn("数据冲突: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(new ApiError("数据冲突，请稍后重试"));
    }

    /** 静态资源/路径不存在 → 404 */
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(NoResourceFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ApiError("资源不存在"));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleOther(Exception ex) {
        log.error("未处理异常", ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ApiError("服务器异常，请稍后再试"));
    }
}
