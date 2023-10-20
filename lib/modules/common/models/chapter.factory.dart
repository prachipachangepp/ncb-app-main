import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/chapter.dart';

extension ChapterFixture on Chapter {
  static ChapterFixtureFactory factory() => ChapterFixtureFactory();
}

class ChapterFixtureFactory extends FixtureFactory<Chapter> {
  @override
  FixtureDefinition<Chapter> definition() => define(
        (faker) => Chapter(
          id: faker.randomGenerator.integer(100),
          bookId: faker.randomGenerator.integer(100),
          name: faker.lorem.word(),
          audio:
              'https://file-examples.com/storage/feb04797b46286b5ea5f061/2017/11/file_example_MP3_700KB.mp3',
          displayPosition: 1,
        ),
      );

// If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
// To redefine the default definition, you must use the `redefine` function.
// FixtureDefinition<Chapter> empty(String name) => redefine((model) => model);
}
