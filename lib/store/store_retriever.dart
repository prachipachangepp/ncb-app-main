import 'package:dev_toolkit/dev_toolkit.dart';
import 'package:flrx/application.dart';
import 'package:flrx/store/middlewares/redux_logging_middleware.dart';
import 'package:flrx/store/store_retriever.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/store/middleware/use_case_middleware.dart';
import 'package:ncb/store/reducers/app_state_reducer.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:ncb/store/states/banner_state.dart';
import 'package:ncb/store/states/chapter_state.dart';
import 'package:ncb/store/states/testament_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class AppStoreRetriever extends StoreRetriever<AppState> {
  @override
  List<Middleware<AppState>> getMiddlewares() {
    return <Middleware<AppState>>[
      UseCaseMiddleware(),
      futureMiddleware,
      if (Application.hasModuleWithName('debug')) DevToolKitMiddleware(),
      if (Application.hasModuleWithName('debug')) getReduxLoggingMiddleware(),
    ];
  }

  @override
  Future<AppState> getInitialState() async => AppState(
        const TestamentState(
          testaments: null,
          loadingState: LoadingState.initial(),
          error: null,
        ),
        const ChapterState(
          chapters: null,
          loadingState: LoadingState.initial(),
          error: null,
        ),
        const BannerState(
          banner: null,
          loadingState: LoadingState.initial(),
          error: null,
        ),
      );

  @override
  Reducer<AppState> getPrimaryReducer() => AppStateReducer.reduce;
}
