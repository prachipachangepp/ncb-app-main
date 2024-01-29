import 'package:hive/hive.dart';

part 'newdb.g.dart';

@HiveType(typeId: 10)
class NewDB {
  @HiveField(0)
  final bool created;

  NewDB({
    required this.created,
  });
}
