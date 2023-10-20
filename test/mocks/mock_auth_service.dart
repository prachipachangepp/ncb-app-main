import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:ncb/modules/common/models/banner.dart';
import 'package:ncb/modules/common/models/lexicon.dart';
import 'package:ncb/modules/common/models/response/generics/response.dart';
import 'package:ncb/modules/common/models/static_content.dart';
import 'package:ncb/modules/common/service/testament_service.dart';

import 'lexicon.dart';

class MockTestamentService extends TestamentService {
  @override
  Future<ObjectResponse<Banner>> getBanners() async {
    await Future.delayed(const Duration(microseconds: 1));

    return ObjectResponse(
      Banner(
        desktopBanner: faker.image.image(height: 240),
        mobileBanner: faker.image.image(),
      ),
    );
  }

  @override
  Future<ObjectResponse<StaticContent>> getContent(String url) async {
    await Future.delayed(const Duration(microseconds: 1));

    return ObjectResponse(
      StaticContent(content: faker.lorem.sentences(10).join('\n')),
    );
  }

  @override
  Future<CollectionResponse<Lexicon>> getLexicon() async {
    await Future.delayed(const Duration(microseconds: 1));

    return CollectionResponse(LexiconFixture().makeMany(5));
  }
}
