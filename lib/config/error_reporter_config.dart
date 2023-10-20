import 'package:catcher/catcher.dart';
import 'package:dio/dio.dart';
import 'package:flrx/components/error_manager/error_manager.dart';
import 'package:flrx/config/config.dart';
import 'package:ncb/config/crashlytics_handler.dart';

class NcbErrorReporterConfig extends ErrorReporterConfig with CatcherConfig {
  const NcbErrorReporterConfig();

  @override
  bool isLoggingEnabled() => true;

  @override
  Future<CatcherOptions> catcherReleaseOptions() async {
    return CatcherOptions(
      SilentReportMode(),
      [CrashlyticsHandler()],
      filterFunction: (Report report) => report.error is! DioError,
    );
  }

  @override
  Future<CatcherOptions> catcherDebugOptions() => catcherReleaseOptions();

  EmailManualHandler emailManualHandler() {
    return EmailManualHandler(
      [
        'support+ncb@faimtech.in',
      ],
      enableDeviceParameters: true,
      enableStackTrace: true,
      enableCustomParameters: true,
      enableApplicationParameters: true,
      sendHtml: true,
      emailTitle: "Problem in NCB App",
      emailHeader: "Hi,\nI am facing the following problem in NCB App\n\n\n\n",
    );
  }
}
