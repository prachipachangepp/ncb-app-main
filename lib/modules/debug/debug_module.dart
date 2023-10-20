import 'package:dio/dio.dart';
import 'package:flrx/components/modules/module.dart';
import 'package:flrx/navigation/router.dart';
import 'package:logger/logger.dart' as logging;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DebugModule extends Module {
  @override
  String get name => 'debug';

  @override
  Map<String, RouteWidgetBuilder> routes() => {};

  @override
  Future<void> register() async {
    logging.Logger.level = logging.Level.verbose;
    // HttpOverrides.global = NetworkToolkitHttpOverrides();
    // DevToolkit.init(
    //   ipAddress: "127. 0.0.1"
    // );
  }

  @override
  Future<void> boot() async {
    logging.Logger.level = logging.Level.verbose;
    // addDioLogger();
  }

  void addDioLogger() {
    var dio = locator.get<Dio>();
    var prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );

    dio.interceptors.add(prettyDioLogger);
  }
}
