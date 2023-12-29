import 'package:hive_flutter/hive_flutter.dart';

part 'static_content_local.g.dart';

@HiveType(typeId: 9)
class StaticContentLocal {
  @HiveField(0)
  final String content;

  StaticContentLocal({required this.content});
}
