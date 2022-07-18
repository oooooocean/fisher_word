// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings()
  ..wordNumber = json['wordNumber'] as int? ?? 20
  ..mode = $enumDecode(_$WordModeEnumMap, json['mode'])
  ..showMean = json['showMean'] as bool
  ..autoPlay = json['showAutoPlay'] as bool;

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'wordNumber': instance.wordNumber,
      'mode': _$WordModeEnumMap[instance.mode],
      'showMean': instance.showMean,
      'showAutoPlay': instance.autoPlay,
    };

const _$WordModeEnumMap = {
  WordMode.easy: 'easy',
  WordMode.middle: 'middle',
  WordMode.hard: 'hard',
};
