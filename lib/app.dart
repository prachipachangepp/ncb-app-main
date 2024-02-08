import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:ncb/config/app_config.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:ncb/styles/app_theme.dart';
import 'package:redux/redux.dart';

class App extends StatelessWidget with Page<AppState, AppVM> {
  const App({Key? key}) : super(key: key);

  @override
  Widget buildContent(BuildContext context, AppVM viewModel) {
    var darkTheme =
        AppTheme.getDarkTheme(fontSizeMultiplier: viewModel.fontSizeFactor);
    var lightTheme =
        AppTheme.getTheme(fontSizeMultiplier: viewModel.fontSizeFactor);

    return MaterialApp(
      navigatorKey: Application.config.navigatorKey,
      supportedLocales: AppConfig.supportedLocales,
      darkTheme: darkTheme,
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      themeMode: viewModel.darkMode ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: AppRouter.router.generator,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }

  @override
  AppVM initViewModel() => AppVM();
}

class AppVM extends ViewModel<AppState> {
  late bool darkMode;
  late Function dispatch;

  late double fontSizeFactor;

  @override
  void init(Store<AppState> store) {
    darkMode = store.state.darkMode;
    fontSizeFactor = store.state.textSizeSteps;
    dispatch = store.dispatch;
  }

  Future<void> toggleDarkMode() async {
    await dispatch(ToggleDarkMode());
  }

  void increaseTextSize() {
    dispatch(IncreaseTextSizeAction());
  }

  void decreaseTextSize() {
    dispatch(DecreaseTextSizeAction());
  }
}
