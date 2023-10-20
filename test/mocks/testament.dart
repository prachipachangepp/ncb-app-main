import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/testament.dart';

extension TestamentFixture on Testament {
  static TestamentFixtureFactory factory() => TestamentFixtureFactory();
}

class TestamentFixtureFactory extends FixtureFactory<Testament> {
  @override
  FixtureDefinition<Testament> definition() => define(
        (faker) => Testament(
          id: faker.randomGenerator.integer(100),
          displayPosition: faker.randomGenerator.integer(50),
          name: faker.randomGenerator.string(10),
          books: [],
        ),
      );

  // If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
  // To redefine the default definition, you must use the `redefine` function.
  FixtureDefinition<Testament> withName(String name) => redefine(
        (testament) => testament.copyWith(name: name),
      );
}
