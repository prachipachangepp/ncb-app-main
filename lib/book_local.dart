import 'package:hive/hive.dart';
import 'package:ncb/chapter_local.dart';

part 'book_local.g.dart';

@HiveType(typeId: 2)
class BookLocal {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int displayPosition;
  @HiveField(3)
  final int testamentId;
  @HiveField(4)
  final String introduction;
  @HiveField(5)
  final List<ChapterLocal>? chapters;

  BookLocal(
      {required this.id,
      required this.name,
      required this.displayPosition,
      required this.testamentId,
      required this.introduction,
      required this.chapters});
}
