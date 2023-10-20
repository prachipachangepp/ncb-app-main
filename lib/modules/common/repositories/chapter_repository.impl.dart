import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/repositories/base/laravel_resource_deserializer.dart';
import 'package:ncb/modules/common/repositories/chapter_repository.dart';
import 'package:ncb/modules/common/repositories/type_to_path_map.dart';

class ChapterRepositoryImpl extends ChapterRepository
    with
        NetworkRepository<Chapter>,
        TypeToPathMapper,
        LaravelResourceDeserializer<Chapter> {
  @override
  Chapter fromJson(Map<String, dynamic> json) => Chapter.fromJson(json);
}
