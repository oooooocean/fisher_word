import 'dart:convert';

import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.g.dart';

enum WordMode {
  easy,
  middle,
  hard;

  /// 每日单词熟练度上限
  int get wordDegreeEveryday => [20, 50, 100][index];

  /// 单词熟练度的限制值
  int get wordDegree => [50, 75, 100][index];

  @override
  String toString() => ['快速', '正常', '熟记'][index];
}

@JsonSerializable()
class Settings {
  static const key = 'settings';

  /// 每次背诵的单词数量
  @JsonKey(defaultValue: 20)
  int wordNumber = 20;

  /// 单词模式
  var mode = WordMode.middle;

  /// 是否默认展示解释
  bool showMean = true;

  /// 是否自动播放语音
  bool autoPlay = true;

  Settings();

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  save() async {
    final sp = await SharedPreferences.getInstance();
    return sp.setString(Settings.key, const JsonEncoder().convert(toJson()));
  }

  static Future<Settings> get cached async {
    final sp = await SharedPreferences.getInstance();
    final json = sp.getString(Settings.key);
    if (json == null) return Settings();
    return Settings.fromJson(const JsonDecoder().convert(json));
  }

  static initialize() async {
    final settings = await Settings.cached;
    Get.put(settings);
  }
}

mixin SettingProviderMixin {
  Settings get settings => Get.find<Settings>();
}
