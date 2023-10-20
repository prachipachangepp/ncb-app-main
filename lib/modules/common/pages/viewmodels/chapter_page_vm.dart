import 'package:flrx/flrx.dart';
import 'package:flrx/pages/viewmodel.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:redux/redux.dart';

class ChapterPageVM extends ViewModel<AppState> {
  late Book book;

  late void Function(dynamic) dispatch;

  late LoadingState loadingState;
  late LoadingState verseLoadingState;

  String? error;
  String? verseError;

  List<Chapter>? chapters;

  final int bookId;

  ChapterPageVM(this.bookId);

  @override
  void init(Store<AppState> store) {
    dispatch = store.dispatch;

    book = store.state.testamentState.testaments!
        .expand((testament) => testament.books)
        .firstWhere((book) => book.id == bookId);

    chapters = store.state.chapterState.chapters;
    loadingState = store.state.chapterState.loadingState;
    verseLoadingState = store.state.chapterState.verseLoadingState;
    error = store.state.chapterState.error;
    verseError = store.state.chapterState.verseError;
  }

  void fetchVersesForChapter(int chapterId) {
    dispatch(FetchVersesAction(chapterId));
  }
}
