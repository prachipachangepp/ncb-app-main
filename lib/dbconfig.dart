import 'package:hive/hive.dart';

part 'dbconfig.g.dart';

@HiveType(typeId: 7)
class DBConfig {
  @HiveField(0)
  final bool created;

  DBConfig({
    required this.created,
  });
}
