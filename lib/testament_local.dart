import 'package:hive/hive.dart';
import 'package:ncb/book_local.dart';

part 'testament_local.g.dart';

@HiveType(typeId: 6)
class TestamentLocal {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int displayPosition;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final List<BookLocal> books;

  TestamentLocal(
      {required this.id,
      required this.displayPosition,
      required this.name,
      required this.books});
}
