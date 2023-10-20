import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/lexicon.dart';

class LexiconFixture extends FixtureFactory<Lexicon> {
  @override
  FixtureDefinition<Lexicon> definition() => define(
        (faker) => Lexicon(
          title: faker.lorem.sentence(),
          description: faker.lorem.sentences(10).join('\n'),
        ),
      );
}
