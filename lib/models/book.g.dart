// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      json['id'] as int,
      json['name'] as String,
      json['path'] as String? ?? '',
      $enumDecodeNullable(_$BookReadStatusEnumMap, json['readStatus']) ??
          BookReadStatus.unread,
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'readStatus': _$BookReadStatusEnumMap[instance.readStatus],
    };

const _$BookReadStatusEnumMap = {
  BookReadStatus.unread: 0,
  BookReadStatus.reading: 1,
  BookReadStatus.read: 2,
  BookReadStatus.readSuspend: 3,
};
