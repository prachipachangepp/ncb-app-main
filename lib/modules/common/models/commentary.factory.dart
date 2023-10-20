import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/commentary.dart';

extension CommentaryFixture on Commentary {
  static CommentaryFixtureFactory factory() => CommentaryFixtureFactory();
}

class CommentaryFixtureFactory extends FixtureFactory<Commentary> {
  @override
  FixtureDefinition<Commentary> definition() => define(
        (faker) => Commentary(
          id: faker.randomGenerator.integer(100),
          content: faker.lorem.sentences(2).join('. '),
          title: faker.lorem.sentence(),
        ),
      );

// If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
// To redefine the default definition, you must use the `redefine` function.
// FixtureDefinition<Commentary> empty(String name) => redefine((model) => model);
}
