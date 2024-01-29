import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/modules/common/models/loading_state.dart';
import 'package:ncb/modules/common/pages/chapter_content.dart';
import 'package:ncb/modules/common/pages/viewmodels/chapter_page_vm.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../../book_local.dart';
import '../../../verselocal.dart';

class ChapterPage extends StatefulWidget {
  final int bookId;
  final String chapterId;

  const ChapterPage({
    Key? key,
    required this.bookId,
    required this.chapterId,
  }) : super(key: key);

  @override
  ChapterPageState createState() => ChapterPageState();
}

class ChapterPageState extends State<ChapterPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');
  Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');

  String? currentAudio;

  ChapterLocal? chapter;
  BookLocal? bookLocal;

  Future<void> syncDataToOffline() async {}

  @override
  void onInit(Store<AppState> store) {
    // store.dispatch(FetchChaptersAction(widget.bookId));
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    //print(connectivityResult.name);

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return true;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return true;
    } else if (connectivityResult == ConnectivityResult.other) {
      return true;
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return false;
    }
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

  void fetchData() {
    bookLocal = booksBox.values
        .where((element) => element.id == widget.bookId)
        .toList()
        .first;
    if (bookLocal != null) {
      chapter = bookLocal!.chapters!
          .where((c) => c.name == widget.chapterId)
          .toList()
          .first;
      //print("comparing verse with " + chapter!.id.toString());
      List<Verselocal> verses =
          verseBox.values.where((el) => el.chapterId == chapter!.id).toList();
      // print(verses[0].verse);
      chapter = ChapterLocal(
          id: chapter!.id,
          audio: chapter!.audio,
          displayPosition: chapter!.displayPosition,
          bookId: chapter!.bookId,
          name: chapter!.name,
          verses: verses,
          book: bookLocal);
    }
  }

  @override
  ChapterPageVM initViewModel() => ChapterPageVM(widget.bookId);

  Widget buildOnSuccess(BuildContext context) {
    fetchData();
    if (chapter == null) {
      return const Center(
          child: Text(
              'Resource not downloaded please turn on the internet connection and go back to chapter '
              '/ testament page to get this chapter downloaded'));
    }

    /// verses should be loaded by child ideally
    // print(chapter!.displayPosition.toString());
    return ChapterContent(
      chapter: chapter!,
      book: bookLocal!,
      currentAudio: currentAudio,
      onAudioChanged: (value) => setState(() => currentAudio = value),
      bookmarckChangedCallBack: (Verselocal verselocal) {
        // print("Chnaged status for id ${verselocal.id} to ${verselocal.save}");
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: buildAppBar(context, viewModel),
      body: buildOnSuccess(context),
    );
  }
}
