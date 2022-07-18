import 'package:json_annotation/json_annotation.dart';

part 'net_response.g.dart';

enum NetCode {
  @JsonValue(0)
  success,

  /// Authorization 缺失
  @JsonValue(1000)
  noAuth,

  /// 账户失效
  @JsonValue(1000)
  accountInvalid,

  /// 找不到指定资源
  @JsonValue(1000)
  resrouceNotfound,

  /// 登录过期
  @JsonValue(1003)
  loginOverdue,

  /// 客户端入参错误
  @JsonValue(1007)
  clientError,

  /// 服务端错误
  @JsonValue(1008)
  serverError
}

class NetError extends Error {
  String message = '';

  @override
  String toString() => message;
}

@JsonSerializable()
class NetResponse extends NetError {
  NetCode code;
  dynamic data;

  NetResponse(this.code, this.data);

  factory NetResponse.fromJson(Map<String, dynamic> json) => _$NetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NetResponseToJson(this);
}
