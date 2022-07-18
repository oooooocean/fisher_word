import 'package:json_annotation/json_annotation.dart';

enum BookStatus {
  /// 未激活
  unactivated,

  /// 激活
  activate,
}

enum BookReadStatus {
  /// 未读
  @JsonValue(0)
  unread,

  /// 正在读
  @JsonValue(1)
  reading,

  /// 读完
  @JsonValue(2)
  read,

  /// 暂停阅读
  @JsonValue(3)
  readSuspend;

  @override
  String toString() => ['', '背诵中', '已背完', '暂停'][index];
}
