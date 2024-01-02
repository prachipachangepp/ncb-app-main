import 'package:hive/hive.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/commentary_local.dart';
import 'package:ncb/footnoteslocal.dart';

part 'verselocal.g.dart';

@HiveType(typeId: 0)
class Verselocal {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int verseNo;
  @HiveField(3)
  final String verse;
  @HiveField(4)
  final int order;
  @HiveField(5)
  bool save;
  @HiveField(6)
  List<FootnotesLocal>? footnotes;
  @HiveField(7)
  List<CommentaryLocal>? commentaries;
  @HiveField(8)
  ChapterLocal? chapter;
  // @HiveField(6)
  //final List<Commentary>? commentaries;
  // @HiveField(7)
  /// final Chapter? chapter;

  Verselocal(
      {this.footnotes,
      this.commentaries,
      this.chapter,
      required this.save,
      required this.verseNo,
      required this.verse,
      required this.order,
      required this.id});
}
