import 'package:data_fixture_dart/factories/fixture_factory.dart';
import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/book.factory.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/chapter.factory.dart';
import 'package:ncb/modules/common/models/footnote.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/models/verse.factory.dart';

class FakeVerseRepository extends Repository<Verse> with FakeRepository<Verse> {
  @override
  FixtureFactory<Verse> get fixtureFactory => VerseFixtureFactory();

  @override
  Future<List<Verse>> getAllForRelationById<S>(int id) async {
    var list = await getAll();

    if (S == Chapter) {
      return list.map((element) => element.copyWith(chapterId: id)).toList();
    }

    if (S == Footnote) {
      return list
          .map(
            (element) => element.copyWith(
              chapter: ChapterFixtureFactory()
                  .makeSingle()
                  .copyWith(book: BookFixtureFactory().makeSingle()),
            ),
          )
          .toList();
    }

    return list;
  }
}
