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
    } else {
      return darkMode;
    }
  }

  static double reduceTextSize(double textSizeSteps, action) {
    double minTextSize = 0.7;
    double maxTextSize = 1.0;
    if (action is IncreaseTextSizeAction) {
      return (textSizeSteps + 0.2).clamp(0.4, 1.4);
    }

    if (action is DecreaseTextSizeAction) {
      minTextSize -= 0.1;

      return (textSizeSteps - 0.1).clamp(minTextSize, maxTextSize);
    }

    return textSizeSteps;
  }
}
