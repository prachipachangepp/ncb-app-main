import 'package:flrx/flrx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/commentary.dart';
import 'package:ncb/modules/common/models/footnote.dart';

part 'verse.freezed.dart';
part 'verse.g.dart';

@freezed
class Verse with DataModel, _$Verse {
  const factory Verse({
    required int id,
    required int verseNo,
    required String verse,
    required int order,
    required int chapterId,
    List<Footnote>? footnotes,
    List<Commentary>? commentaries,
    Chapter? chapter,
  }) = _Verse;

  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);
}
