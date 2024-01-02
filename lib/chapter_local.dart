import 'package:hive/hive.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/verselocal.dart';

part 'chapter_local.g.dart';

@HiveType(typeId: 3)
class ChapterLocal {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? audio;
  @HiveField(2)
  final int displayPosition;
  @HiveField(3)
  final int bookId;
  @HiveField(4)
  final String name;
  @HiveField(5)
  final List<Verselocal>? verses;
  @HiveField(6)
  final BookLocal? book;

  ChapterLocal({
    required this.id,
    required this.audio,
    required this.displayPosition,
    required this.bookId,
    required this.name,
    required this.verses,
    required this.book,
  });
}
