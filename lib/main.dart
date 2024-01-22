import 'dart:io';

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
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyARXuOGJ8AzSobIeBk1C8JCnzh323CJQm8",
          appId: "1:609978247834:android:62eb29561f382c60840d23",
          messagingSenderId: "609978247834",
          projectId: "ncb-firebase-a9050")
  ) : Firebase.initializeApp();
 // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
