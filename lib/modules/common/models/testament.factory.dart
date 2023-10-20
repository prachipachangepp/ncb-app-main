import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/book.factory.dart';
import 'package:ncb/modules/common/models/testament.dart';

extension TestamentFixture on Testament {
  static TestamentFixtureFactory factory() => TestamentFixtureFactory();
}

class TestamentFixtureFactory extends FixtureFactory<Testament> {
  @override
  FixtureDefinition<Testament> definition() => define(
        (faker) => Testament(
          id: faker.randomGenerator.integer(100),
          name: faker.lorem.word(),
          displayPosition: 1,
          books: BookFixture.factory().makeMany(
            faker.randomGenerator.integer(100, min: 10),
          ),
        ),
      );

// If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
// To redefine the default definition, you must use the `redefine` function.
// FixtureDefinition<Testament> empty(String name) => redefine((model) => model);
}
