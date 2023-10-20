import 'package:freezed_annotation/freezed_annotation.dart';

part 'commentary.freezed.dart';
part 'commentary.g.dart';

@freezed
class Commentary with _$Commentary {
  const factory Commentary({
    required int id,
    required String title,
    required String content,
  }) = _Commentary;

  factory Commentary.fromJson(Map<String, dynamic> json) =>
      _$CommentaryFromJson(json);
}
