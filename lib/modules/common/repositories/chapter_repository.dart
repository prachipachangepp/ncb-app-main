import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/chapter.dart';

abstract class ChapterRepository extends Repository<Chapter> {
  static ChapterRepository get instance => Application.get<ChapterRepository>();
}
