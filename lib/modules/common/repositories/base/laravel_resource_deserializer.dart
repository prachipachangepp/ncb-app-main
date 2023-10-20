import 'package:ncb/modules/common/models/response/generics/response.dart';
import 'package:flrx/flrx.dart';

mixin LaravelResourceDeserializer<T extends DataModel> on NetworkRepository<T> {
  @override
  T deserializeSingleEntity(dynamic data) {
    final value = ObjectResponse<T>.fromJson(
      data,
      (json) => fromJson(Map.from(json)),
    );

    return value.data;
  }

  @override
  List<T> deserializeEntityList(dynamic data) {
    final value = CollectionResponse<T>.fromJson(
      data,
      (json) => fromJson(Map.from(json)),
    );

    return value.data;
  }
}
