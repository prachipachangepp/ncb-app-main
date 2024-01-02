import 'package:hive/hive.dart';

part 'commentary_local.g.dart';

@HiveType(typeId: 5)
class CommentaryLocal {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;

  CommentaryLocal({
    required this.id,
    required this.title,
    required this.content,
  });
}
