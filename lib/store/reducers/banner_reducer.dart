import 'package:ncb/modules/common/models/banner.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/banner_state.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class BannerReducer {
  static BannerState reduce(BannerState prevState, dynamic action) {
    if (action is FuturePendingAction<FetchBannersAction>) {
      return const BannerState(
        loadingState: LoadingState.loading(),
        error: null,
        banner: null,
      );
    }

    if (action is FutureSucceededAction<FetchBannersAction, Banner>) {
      return BannerState(
        loadingState: const LoadingState.success(),
        error: null,
        banner: action.payload,
      );
    }

    if (action is FutureFailedAction<FetchBannersAction>) {
      return BannerState(
        loadingState: const LoadingState.success(),
        error: action.error.toString(),
        banner: null,
      );
    }

    return prevState;
  }
}
