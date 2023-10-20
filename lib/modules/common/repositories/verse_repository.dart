import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/verse.dart';

abstract class VerseRepository extends Repository<Verse> {
  static VerseRepository get instance => Application.get<VerseRepository>();

  Future<List<Verse>> search(String params);
}
