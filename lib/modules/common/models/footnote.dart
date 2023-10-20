import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/verse.dart';

part 'footnote.freezed.dart';
part 'footnote.g.dart';

@freezed
class Footnote with _$Footnote {
  const factory Footnote({
    required int id,
    String? title,
    List<Verse>? verses,
  }) = _Footnote;

  factory Footnote.fromJson(Map<String, dynamic> json) =>
      _$FootnoteFromJson(json);
}
