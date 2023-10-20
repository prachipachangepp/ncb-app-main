import 'package:ncb/store/actions/dispatches_future_action.dart';

abstract class UseCase<A, P> with DispatchesFutureAction<A, P> {
  Future<P> call();

  @override
  Future<P> buildFuture() => call();
}
