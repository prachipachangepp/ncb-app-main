import 'package:flrx/flrx.dart';
import 'package:flrx/pages/page.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/modules/common/pages/chapter_content.dart';
import 'package:ncb/modules/common/pages/viewmodels/chapter_page_vm.dart';
import 'package:ncb/store/actions/actions.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:redux/redux.dart';

class ChapterPage extends StatefulWidget {
  final int bookId;
  final int chapterId;

  const ChapterPage({
    Key? key,
    required this.bookId,
    required this.chapterId,
  }) : super(key: key);

  @override
  ChapterPageState createState() => ChapterPageState();
}

class ChapterPageState extends State<ChapterPage>
    with Page<AppState, ChapterPageVM> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String? currentAudio;

  Chapter? chapter;

  @override
  void onInit(Store<AppState> store) {
    store.dispatch(FetchChaptersAction(widget.bookId));
  }

  @override
  void onWillChange(
    BuildContext context,
    ChapterPageVM? previousViewModel,
    ChapterPageVM newViewModel,
  ) {
    if (_didChaptersLoadSuccessfully(previousViewModel, newViewModel)) {
      copyChapter(newViewModel);
      newViewModel.fetchVersesForChapter(widget.chapterId);
    }
    if (newViewModel.verseLoadingState.isSuccess()) {
      copyChapter(newViewModel);
    }
  }

  void copyChapter(ChapterPageVM newViewModel) {
    chapter = newViewModel.chapters!.cast().firstWhere(
      (c) => c.id == widget.chapterId,
      orElse: () {
        Navigator.pop(context);

        return null;
      },
    );
  }

  bool _didChaptersLoadSuccessfully(
    ChapterPageVM? previousViewModel,
    ChapterPageVM newViewModel,
  ) {
    var previousLoadingState = previousViewModel?.loadingState;
    var newLoadingState = newViewModel.loadingState;

    var loadingStateSucceeded =
        previousLoadingState.isLoading() && newLoadingState.isSuccess();

    return loadingStateSucceeded;
  }

  @override
  Widget buildContent(BuildContext context, ChapterPageVM viewModel) {
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(context, viewModel),
      body: viewModel.loadingState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        failed: () => Center(child: Text(viewModel.error!)),
        success: () => buildOnSuccess(context, viewModel),
      ),
    );
  }

  @override
  ChapterPageVM initViewModel() => ChapterPageVM(widget.bookId);

  Widget buildOnSuccess(BuildContext context, ChapterPageVM vm) {
    if (chapter == null) {
      return const Center(child: Text('Chapter not found'));
    }

    /// verses should be loaded by child ideally
    return vm.verseLoadingState.maybeWhen(
      orElse: () => const Center(child: CircularProgressIndicator()),
      failed: () => Center(child: Text(vm.verseError!)),
      success: () => ChapterContent(
        chapter: chapter!,
        book: vm.book,
        currentAudio: currentAudio,
        onAudioChanged: (value) => setState(() => currentAudio = value),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(
    BuildContext context,
    ChapterPageVM viewModel,
  ) {
    return viewModel.loadingState.maybeWhen(
      orElse: () => AppBar(),
      success: () => viewModel.verseLoadingState.maybeWhen(
        orElse: () => AppBar(),
        success: () => null,
      ),
    );
  }
}
