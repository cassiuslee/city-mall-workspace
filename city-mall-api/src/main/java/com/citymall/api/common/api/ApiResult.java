package com.citymall.api.common.api;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class ApiResult<T> {

  private String code;
  private String msg;
  private T result;

  public static <T> ApiResult<T> success(T result) {
    return new ApiResult<>("1", "操作成功", result);
  }

  public static <T> ApiResult<T> success() {
    return new ApiResult<>("1", "操作成功", null);
  }

  public static <T> ApiResult<T> fail(String msg) {
    return new ApiResult<>("0", msg, null);
  }

  public static <T> ApiResult<T> fail(String code, String msg) {
    return new ApiResult<>(code, msg, null);
  }
}
