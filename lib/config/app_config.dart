import 'package:flrx/components/modules/module.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/cupertino.dart';
import 'package:ncb/config/error_reporter_config.dart';
import 'package:ncb/modules/common/common_module.dart';
import 'package:ncb/modules/debug/debug_module.dart';

class AppConfig extends ApplicationConfig {
  // static const apiUrl = String.fromEnvironment(
  //   "API_URL",
  // );

  static const apiUrl = "https://admin.newcommunitybible.in/api/";
  //static const apiUrl = "https://ncb.xceedtech.in/api/";
  //static const apiUrl = "https://ncb.xceedtech.in/api/";
  static const List<String> _supportedLocales = <String>[
    "en",
    "fr",
    "it",
    "de",
  ];

  static List<Locale> get supportedLocales =>
      _supportedLocales.map((String code) => Locale(code)).toList();

  @override
  List<Module> get modules => [
        CommonModule(),
        if (Application.isInDebugMode) DebugModule(),
      ];

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  ErrorReporterConfig get errorReporterConfig => const NcbErrorReporterConfig();
}
