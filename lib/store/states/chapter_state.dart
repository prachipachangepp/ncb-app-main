import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/loading_state.dart';

part 'chapter_state.freezed.dart';
part 'chapter_state.g.dart';

@freezed
class ChapterState with _$ChapterState {
  const factory ChapterState({
    @Default(LoadingState.initial()) LoadingState loadingState,
    List<Chapter>? chapters,
    String? error,
    @Default(LoadingState.initial()) LoadingState verseLoadingState,
    String? verseError,
  }) = _ChapterState;

  factory ChapterState.fromJson(Map<String, dynamic> json) =>
      _$ChapterStateFromJson(json);
}
