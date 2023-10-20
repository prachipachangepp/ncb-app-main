import 'package:flrx/flrx.dart';
import 'package:flrx/pages/viewmodel.dart';
import 'package:ncb/modules/common/models/banner.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:redux/redux.dart';

class TestamentPageVM extends ViewModel<AppState> {
  late List<Testament>? testaments;

  /// TODO(ibrahim-mubarak): Dispatch should be a part of Base ViewModel
  late void Function(dynamic) dispatch;

  late LoadingState loadingState;
  late LoadingState bannerLoadingState;

  String? error;

  Banner? banner;

  @override
  void init(Store<AppState> store) {
    dispatch = store.dispatch;
    testaments = store.state.testamentState.testaments;
    loadingState = store.state.testamentState.loadingState;
    bannerLoadingState = store.state.bannerState.loadingState;
    banner = store.state.bannerState.banner;
    error = store.state.testamentState.error;
  }

  void fetchTestaments() => dispatch(FetchTestamentsAction());

  void fetchBanners() => dispatch(FetchBannersAction());
}
