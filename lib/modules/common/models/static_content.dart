
import 'package:freezed_annotation/freezed_annotation.dart';

part 'static_content.freezed.dart';
part 'static_content.g.dart';

@freezed
class StaticContent with _$StaticContent {
  const factory StaticContent({
    required String content,
  }) = _StaticContent;

  factory StaticContent.fromJson(Map<String, dynamic> json) =>
      _$StaticContentFromJson(json);
}
