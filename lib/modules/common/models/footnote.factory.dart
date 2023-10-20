import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/footnote.dart';

extension FootnoteFixture on Footnote {
  static FootnoteFixtureFactory factory() => FootnoteFixtureFactory();
}

class FootnoteFixtureFactory extends FixtureFactory<Footnote> {
  @override
  FixtureDefinition<Footnote> definition() => define(
        (faker) => Footnote(
          id: faker.randomGenerator.integer(100),
        ),
      );

// If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
// To redefine the default definition, you must use the `redefine` function.
// FixtureDefinition<Footnote> empty(String name) => redefine((model) => model);
}
