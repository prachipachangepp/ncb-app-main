import 'package:flrx/flrx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/verse.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
class Chapter with DataModel, _$Chapter {
  const factory Chapter({
    required int id,
    required String? audio,
    required int displayPosition,
    required int bookId,
    required String name,
    List<Verse>? verses,
    Book? book,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
