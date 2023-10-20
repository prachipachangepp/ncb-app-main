import 'package:ncb/store/actions/dispatches_future_action.dart';
import 'package:redux/redux.dart';

class UseCaseMiddleware extends MiddlewareClass {
  @override
  call(Store<dynamic> store, action, NextDispatcher next) {
    if (action is DispatchesFutureAction) {
      store.dispatch(action.buildAction());

      return;
    }

    next(action);
  }
}
