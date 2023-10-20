import 'package:redux_future_middleware/redux_future_middleware.dart';

abstract class DispatchesFutureAction<A, P> {
  FutureAction<A, P> buildAction() {
    return FutureAction(future: buildFuture());
  }

  Future<P> buildFuture();
}
