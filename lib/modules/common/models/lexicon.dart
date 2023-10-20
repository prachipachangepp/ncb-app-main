import 'package:freezed_annotation/freezed_annotation.dart';

part 'lexicon.freezed.dart';
part 'lexicon.g.dart';

@freezed
class Lexicon with _$Lexicon {
  const factory Lexicon({
    required String title,
    required String description,
  }) = _Lexicon;

  factory Lexicon.fromJson(Map<String, dynamic> json) =>
      _$LexiconFromJson(json);
}
