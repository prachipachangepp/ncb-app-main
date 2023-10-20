import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_state.freezed.dart';
part 'loading_state.g.dart';

@freezed
class LoadingState with _$LoadingState {
  const LoadingState._();

  const factory LoadingState.initial() = INITIAL;

  const factory LoadingState.loading() = LOADING;

  const factory LoadingState.failed() = FAILED;

  const factory LoadingState.success() = SUCCESS;

  factory LoadingState.fromJson(Map<String, dynamic> json) =>
      _$LoadingStateFromJson(json);
}

extension LoadingStateExtension on LoadingState? {
  bool isInitial() => this == const LoadingState.initial();

  bool isLoading() => this == const LoadingState.loading();

  bool isFailed() => this == const LoadingState.failed();

  bool isSuccess() => this == const LoadingState.success();
}
