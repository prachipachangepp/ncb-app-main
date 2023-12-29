import 'package:flrx/flrx.dart';
import 'package:flrx/pages/viewmodel.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:redux/redux.dart';

class BookPageVM extends ViewModel<AppState> {
  late Book book;

  late void Function(dynamic) dispatch;

  late LoadingState loadingState;

  String? error;

  List<Chapter>? chapters;

  final int bookId;

  BookPageVM(this.bookId);

  @override
  Future<void> init(Store<AppState> store) async {
    dispatch = store.dispatch;

    var state = store.state;

    // book = state.testamentState.testaments!
    //     .expand((testament) => testament.books)
    //     .firstWhere((book) => book.id == bookId);

    chapters = state.chapterState.chapters;
    loadingState = state.chapterState.loadingState;
    error = state.chapterState.error;
  }

  void fetchChapters(int bookId) => dispatch(FetchChaptersAction(bookId));
}
