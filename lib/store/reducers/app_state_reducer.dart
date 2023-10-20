import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/reducers/banner_reducer.dart';
import 'package:ncb/store/reducers/chapter_reducer.dart';
import 'package:ncb/store/reducers/testament_reducer.dart';
import 'package:ncb/store/states/app_state.dart';

class AppStateReducer {
  static AppState reduce(AppState prevState, dynamic action) {
    var testamentState = TestamentReducer.reduce(
      prevState.testamentState,
      action,
    );

    var chapterState = ChapterReducer.reduce(
      prevState.chapterState,
      action,
    );

    var bannerState = BannerReducer.reduce(prevState.bannerState, action);

    return AppState(
      testamentState,
      chapterState,
      bannerState,
      darkMode: reduceDarkMode(prevState.darkMode, action),
      textSizeSteps: reduceTextSize(prevState.textSizeSteps, action),
    );
  }

  static reduceDarkMode(bool darkMode, action) {
    if (action is ToggleDarkMode) {
      return !darkMode;
    }

    return darkMode;
  }

  static double reduceTextSize(double textSizeSteps, action) {
    if (action is IncreaseTextSizeAction) {
      return textSizeSteps + 0.15;
    }

    if (action is DecreaseTextSizeAction) {
      return textSizeSteps - 0.15;
    }

    return textSizeSteps;
  }
}
