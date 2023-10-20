import 'package:dio/dio.dart';
import 'package:ncb/modules/common/models/banner.dart';
import 'package:ncb/modules/common/models/lexicon.dart';
import 'package:ncb/modules/common/models/response/generics/response.dart';
import 'package:ncb/modules/common/models/static_content.dart';
import 'package:retrofit/retrofit.dart';

part 'testament_service.g.dart';

@RestApi()
abstract class TestamentService {
  TestamentService();

  factory TestamentService.newInstance(Dio dio, {String baseUrl}) =
      _TestamentService;

  @GET('banner')
  Future<ObjectResponse<Banner>> getBanners();

  @GET('{url}')
  Future<ObjectResponse<StaticContent>> getContent(@Path('url') String url);

  @GET('lexicons')
  Future<CollectionResponse<Lexicon>> getLexicon();
}
