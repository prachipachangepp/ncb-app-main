import 'package:data_fixture_dart/factories/fixture_factory.dart';
import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/chapter.factory.dart';
import 'package:ncb/modules/common/repositories/chapter_repository.dart';

class NewFakeChapterRepository extends ChapterRepository
    with FakeRepository<Chapter> {
  @override
  FixtureFactory<Chapter> get fixtureFactory => ChapterFixtureFactory();

  @override
  Future<List<Chapter>> getAllForRelationById<S>(int id) {
    if (S == Book) {
      return getAll().then((list) {
        int chapterId = 1;

        return list
            .map((e) => e.copyWith(bookId: id, id: chapterId++))
            .toList();
      });
    }

    return getAll();
  }
}
