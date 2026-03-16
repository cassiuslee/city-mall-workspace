package com.citymall.api.common.exception;

import com.citymall.api.common.api.ApiResult;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(BusinessException.class)
  public ApiResult<Void> handleBusinessException(BusinessException e) {
    return ApiResult.fail(e.getCode(), e.getMessage());
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ApiResult<Void> handleMethodArgumentNotValid(MethodArgumentNotValidException e) {
    String msg = e.getBindingResult().getFieldErrors().stream()
        .map(err -> err.getField() + ":" + err.getDefaultMessage())
        .collect(Collectors.joining("; "));
    return ApiResult.fail(msg);
  }

  @ExceptionHandler(BindException.class)
  public ApiResult<Void> handleBindException(BindException e) {
    String msg = e.getBindingResult().getFieldErrors().stream()
        .map(err -> err.getField() + ":" + err.getDefaultMessage())
        .collect(Collectors.joining("; "));
    return ApiResult.fail(msg);
  }

  @ExceptionHandler(ConstraintViolationException.class)
  public ApiResult<Void> handleConstraintViolation(ConstraintViolationException e) {
    return ApiResult.fail(e.getMessage());
  }

  @ExceptionHandler(HttpMessageNotReadableException.class)
  public ApiResult<Void> handleHttpMessageNotReadable(HttpMessageNotReadableException e) {
    return ApiResult.fail("请求体解析失败");
  }

  @ExceptionHandler(Exception.class)
  public ApiResult<Void> handleException(Exception e) {
    log.error("Unhandled exception", e);
    return ApiResult.fail("系统繁忙，请稍后重试");
  }
}
