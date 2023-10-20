import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/store/states/banner_state.dart';
import 'package:ncb/store/states/chapter_state.dart';
import 'package:ncb/store/states/testament_state.dart';

part 'app_state.freezed.dart';

part 'app_state.g.dart';

@freezed
class AppState with _$AppState {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  factory AppState(
    TestamentState testamentState,
    ChapterState chapterState,
    BannerState bannerState, {
    @Default(false) bool darkMode,
    @Default(1) double textSizeSteps,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
