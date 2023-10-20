import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ncb/modules/common/models/banner.dart';
import 'package:ncb/modules/common/models/loading_state.dart';

part 'banner_state.freezed.dart';

part 'banner_state.g.dart';

@freezed
class BannerState with _$BannerState {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BannerState({
    required LoadingState loadingState,
    required String? error,
    required Banner? banner,
  }) = _BannerState;

  factory BannerState.fromJson(Map<String, dynamic> json) =>
      _$BannerStateFromJson(json);
}
