import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/chapter.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required String name,
    required int displayPosition,
    required int testamentId,
    required String introduction,
    List<Chapter>? chapters,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
