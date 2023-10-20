import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/repositories/base/laravel_resource_deserializer.dart';
import 'package:ncb/modules/common/repositories/type_to_path_map.dart';
import 'package:ncb/modules/common/repositories/verse_repository.dart';

class VerseRepositoryImpl extends VerseRepository
    with
        NetworkRepository<Verse>,
        TypeToPathMapper,
        LaravelResourceDeserializer {
  @override
  Verse fromJson(Map<String, dynamic> json) => Verse.fromJson(json);

  @override
  Future<List<Verse>> search(String params) async {
    final data = params;

    final result = await dio.post<Map<String, dynamic>>(
      'verses/search',
      data: data,
    );

    return deserializeEntityList(result.data);
  }
}
