import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/testament_state.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class TestamentReducer {
  static TestamentState reduce(TestamentState prevState, dynamic action) {
    if (action is FuturePendingAction<FetchTestamentsAction>) {
      return const TestamentState(
        loadingState: LoadingState.loading(),
        error: null,
        testaments: null,
      );
    }

    if (action
        is FutureSucceededAction<FetchTestamentsAction, List<Testament>>) {
      return TestamentState(
        loadingState: const LoadingState.success(),
        error: null,
        testaments: action.payload,
      );
    }

    if (action is FutureFailedAction<FetchTestamentsAction>) {
      return TestamentState(
        loadingState: const LoadingState.success(),
        error: action.error.toString(),
        testaments: null,
      );
    }

    return prevState;
  }
}
