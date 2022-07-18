import 'package:frontend/components/constants/book_status.dart';
import 'package:frontend/services/db.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';
import 'package:more/more.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  /// 唯一标识
  int id;

  /// 书籍名称
  String name;

  /// 下载地址
  @JsonKey(defaultValue: '')
  String path;

  /// 是否已经下载
  @JsonKey(ignore: true)
  var hasDownload = false.obs;

  /// 统计信息
  @JsonKey(ignore: true)
  var wordCount = 0;

  /// 阅读进度
  @JsonKey(ignore: true)
  var progress = 0.0;

  /// 阅读状态
  @JsonKey(defaultValue: BookReadStatus.unread)
  BookReadStatus readStatus;

  Book(this.id, this.name, this.path, this.readStatus);

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);

  @override
  String toString() => '书: $name readStatus: $readStatus hasDownload: $hasDownload';

  String get wordTableName => 'book_$id';

  Future changeReadStatus(BookReadStatus readStatus) async {
    await DB.shared.updateBookStatus(this, readStatus);
    this.readStatus = readStatus;
  }

  /// 书名的展示逻辑
  Tuple2<String, String> get nameComponents {
    final exp = RegExp(r'^(\d*)(.*)$');
    final result = exp.firstMatch(name)!;
    var first = result.group(1)!;
    var second = result.group(2)!;
    if (first.isEmpty) {
      first = name.substring(0, 1);
      second = name.substring(1);
    }
    return Tuple2(first, second);
  }
}
