import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/modules/common/models/testament.dart';

part 'testament_state.freezed.dart';

part 'testament_state.g.dart';

@freezed
class TestamentState with _$TestamentState {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TestamentState({
    required LoadingState loadingState,
    required String? error,
    required List<Testament>? testaments,
  }) = _TestamentState;

  factory TestamentState.fromJson(Map<String, dynamic> json) =>
      _$TestamentStateFromJson(json);
}
