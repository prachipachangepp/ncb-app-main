import 'package:hive_flutter/hive_flutter.dart';

part 'lexicon_local.g.dart';

@HiveType(typeId: 8)
class LexiconLocal {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  LexiconLocal({
    required this.title,
    required this.description,
  });
}
