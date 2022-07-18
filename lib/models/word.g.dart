// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      json['name'] as String,
      json['mean'] as String,
    )
      ..id = json['id'] as int
      ..readTime = json['readTime'] as int
      ..degree = json['degree'] as int
      ..todayDegree = json['todayDegree'] as int? ?? 0;

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mean': instance.mean,
      'readTime': instance.readTime,
      'degree': instance.degree,
      'todayDegree': instance.todayDegree,
    };
