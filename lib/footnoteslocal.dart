import 'package:hive/hive.dart';
import 'package:ncb/verselocal.dart';

part 'footnoteslocal.g.dart';

@HiveType(typeId: 1)
class FootnotesLocal {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final List<Verselocal>? verses;

  FootnotesLocal({required this.id, required this.title, required this.verses});
}
