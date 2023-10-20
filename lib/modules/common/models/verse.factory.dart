import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/commentary.factory.dart';
import 'package:ncb/modules/common/models/footnote.factory.dart';
import 'package:ncb/modules/common/models/verse.dart';

extension VerseFixture on Verse {
  static VerseFixtureFactory factory() => VerseFixtureFactory();
}

class VerseFixtureFactory extends FixtureFactory<Verse> {
  @override
  FixtureDefinition<Verse> definition() => define(
        (faker) => Verse(
          verseNo: faker.randomGenerator.integer(100),
          verse: faker.lorem.sentence(),
          order: faker.randomGenerator.integer(100),
          id: faker.randomGenerator.integer(100),
          chapterId: faker.randomGenerator.integer(100),
          commentaries: CommentaryFixture.factory()
              .makeMany(faker.randomGenerator.integer(5)),
          footnotes: FootnoteFixture.factory()
              .makeMany(faker.randomGenerator.integer(5)),
        ),
      );

// If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
// To redefine the default definition, you must use the `redefine` function.
// FixtureDefinition<Verse> empty(String name) => redefine((model) => model);
}
