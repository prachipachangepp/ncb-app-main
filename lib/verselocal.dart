import 'package:hive/hive.dart';

import 'modules/common/models/chapter.dart';
import 'modules/common/models/commentary.dart';
import 'modules/common/models/footnote.dart';

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

  // @HiveField(5)
  //final List<FootnotesLocal>? footnotes;
  // @HiveField(6)
  //final List<Commentary>? commentaries;
  // @HiveField(7)
  /// final Chapter? chapter;

  Verselocal(
      {required this.verseNo,
      required this.verse,
      required this.order,
      required this.id});
}
