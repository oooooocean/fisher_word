import 'package:frontend/models/book.dart';
import 'package:frontend/services/alg.dart';
import 'package:frontend/services/db.dart';
import 'package:frontend/services/settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

@JsonSerializable()
class Word with SettingProviderMixin {
  int id = 0;

  /// 单词名称
  String name;

  /// 解释
  String mean;

  /// 学习次数
  int readTime = 0;

  /// 熟练度
  int degree = 0;

  /// 本次熟练度
  @JsonKey(defaultValue: 0)
  int todayDegree = 0;

  Word(this.name, this.mean);

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  Map<String, dynamic> toJson() => _$WordToJson(this);

  @override
  String toString() => '单词: $name, 熟练度: $degree, 今日熟练度: $todayDegree, 学习次数: $readTime';

  /// 读
  read({required Book book, required Alg alg}) async {
    degree += settings.mode.wordDegree ~/ alg.level;
    todayDegree += settings.mode.wordDegreeEveryday ~/ alg.level;
    readTime += 1;
    await DB.shared.saveWordHistory(book, this);
  }
}
