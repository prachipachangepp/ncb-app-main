import 'package:flrx/flrx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/book.dart';

part 'testament.freezed.dart';
part 'testament.g.dart';

@freezed
class Testament with DataModel, _$Testament {
  const factory Testament({
    required int id,
    required int displayPosition,
    required String name,
    required List<Book> books,
  }) = _Testament;

  factory Testament.fromJson(Map<String, dynamic> json) =>
      _$TestamentFromJson(json);
}
