import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/book.dart';

extension BookFixture on Book {
  static BookFixtureFactory factory() => BookFixtureFactory();
}

class BookFixtureFactory extends FixtureFactory<Book> {
  @override
  FixtureDefinition<Book> definition() => define(
        (faker) => Book(
          id: faker.randomGenerator.integer(100),
          name: faker.lorem.word(),
          testamentId: faker.randomGenerator.integer(100),
          introduction: faker.lorem.sentences(2).join('\n'),
          displayPosition: 1,
        ),
      );

// If you need to override a model field, simply define a function that returns a `FixtureDefinition`.
// To redefine the default definition, you must use the `redefine` function.
// FixtureDefinition<Book> empty(String name) => redefine((model) => model);
}
