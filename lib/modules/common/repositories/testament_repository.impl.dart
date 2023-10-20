import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/modules/common/repositories/base/laravel_resource_deserializer.dart';
import 'package:ncb/modules/common/repositories/testament_repository.dart';
import 'package:ncb/modules/common/repositories/type_to_path_map.dart';

class TestamentRepositoryImpl extends TestamentRepository
    with
        NetworkRepository<Testament>,
        TypeToPathMapper,
        LaravelResourceDeserializer {
  @override
  Testament fromJson(Map<String, dynamic> json) => Testament.fromJson(json);
}
