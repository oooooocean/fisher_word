import 'package:frontend/models/word.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection {
  int id;
  Word word;

  Collection(this.id, this.word);

  factory Collection.fromJson(Map<String, dynamic> json) =>  _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  @override
  String toString() => '';
}