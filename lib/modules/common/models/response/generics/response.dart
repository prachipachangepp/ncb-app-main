import 'package:ncb/modules/common/models/response/generics/links.dart';
import 'package:ncb/modules/common/models/response/generics/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectResponse<T> {
  final T data;

  ObjectResponse(this.data);

  factory ObjectResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$ObjectResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) =>
      _$ObjectResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class CollectionResponse<T> {
  final List<T> data;

  CollectionResponse(this.data);

  factory CollectionResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$CollectionResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) =>
      _$CollectionResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class PagedResponse<T> {
  final List<T> data;
  final Links links;
  final Meta meta;

  PagedResponse(
    this.data,
    this.links,
    this.meta,
  );

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$PagedResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) =>
      _$PagedResponseToJson(this, toJsonT);
}
