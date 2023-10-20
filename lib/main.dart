import 'package:flrx/components/error_manager/error_manager.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ncb/app.dart';
import 'package:ncb/config/app_config.dart';
import 'package:ncb/config/error_reporter_config.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:ncb/store/store_retriever.dart';
import 'package:redux/redux.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppRouter.setNotFoundWidget((p) => StatefulBuilder(builder: (c, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(c, '/', ModalRoute.withName('/'));
        });

        return const SizedBox();
      }));

  var appConfig = AppConfig();
  var application = Application(initApp, appConfig: appConfig);

  Application.serviceLocator.registerSingleton<ErrorManager>(
    CatcherErrorManager(
      catcherConfig: appConfig.errorReporterConfig as NcbErrorReporterConfig,
      navigatorKey: appConfig.navigatorKey,
    ),
  );

  application.init();
}

Future<void> initApp() async {
  Store<AppState> store = await AppStoreRetriever().retrieveStore();
  runApp(
    MaterialApp(
      home: StoreProvider<AppState>(
        store: store,
        child: const App(),
      ),
    ),
  );
}
