import 'package:flrx/application.dart';
import 'package:flrx/components/logger/base_logger.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/chapter_state.dart';
import 'package:redux_future_middleware/redux_future_middleware.dart';

class ChapterReducer {
  static ChapterState reduce(ChapterState prevState, dynamic action) {
    if (isFutureVerseAction(action)) {
      return reduceVerses(prevState, action);
    }

    if (action is FuturePendingAction<FetchChaptersAction>) {
      return const ChapterState(
        loadingState: LoadingState.loading(),
        error: null,
        chapters: null,
      );
    }

    if (action is FutureSucceededAction<FetchChaptersAction, List<Chapter>>) {
      return prevState.copyWith(
        loadingState: const LoadingState.success(),
        chapters: action.payload,
      );
    }

    if (action is FutureFailedAction<FetchChaptersAction>) {
      Application.get<Logger>().e('Could not load chapters', action.error);

      return ChapterState(
        loadingState: const LoadingState.failed(),
        error: action.error.toString(),
        chapters: null,
      );
    }

    return prevState;
  }

  static bool isFutureVerseAction(action) {
    return action is FuturePendingAction<FetchVersesAction> ||
        action is FutureSucceededAction<FetchVersesAction, List<Verse>> ||
        action is FutureFailedAction<FetchVersesAction>;
  }

  static List<Chapter>? updateChapterWithVerses(
    List<Chapter>? chapters,
    List<Verse> verses,
  ) {
    return chapters?.map(
      (element) {
        if (element.id == verses[0].chapterId) {
          return element.copyWith(verses: verses);
        }

        return element;
      },
    ).toList();
  }

  static ChapterState reduceVerses(ChapterState prevState, action) {
    if (action is FuturePendingAction<FetchVersesAction>) {
      return prevState.copyWith(
        verseLoadingState: const LoadingState.loading(),
      );
    }

    if (action is FutureSucceededAction<FetchVersesAction, List<Verse>>) {
      return prevState.copyWith(
        verseLoadingState: const LoadingState.success(),
        verseError: null,
        chapters: updateChapterWithVerses(prevState.chapters, action.payload),
      );
    }

    if (action is FutureFailedAction<FetchVersesAction>) {
      Application.get<Logger>().e('Could not load chapters', action.error);

      return prevState.copyWith(
        verseLoadingState: const LoadingState.failed(),
        verseError: action.error.toString(),
      );
    }

    throw Exception('Unknown action type');
  }
}
