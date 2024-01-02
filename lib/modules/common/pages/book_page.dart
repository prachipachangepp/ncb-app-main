import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flrx/pages/page.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:hive/hive.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/modules/common/pages/home_page.dart';
import 'package:ncb/modules/common/pages/viewmodels/book_page_vm.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:ncb/verselocal.dart';

import '../../../commentary_local.dart';
import '../../../footnoteslocal.dart';
import '../../../store/actions/actions.dart';
import '../models/verse.dart';

class BookPage extends StatelessWidget with Page<AppState, BookPageVM> {
  final int bookId;
  BookLocal? bookLocal;
  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');
  Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');
  Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');

  BookPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  void onInitialBuild(BookPageVM viewModel) {
    // viewModel.fetchChapters(bookId);
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    print(connectivityResult.name);

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

  Future<void> syncDataToOffline() async {
    bookLocal!.chapters!.forEach((element) async {
      List<Verse> v =
          await Future.delayed(Duration(milliseconds: 500)).then((value) {
        return FetchVersesAction(element.id).buildFuture();
      });
      for (var verse in v) {
        int l = bookmarkBox.values
            .where((ver) => ver.verse == verse.verse)
            .toList()
            .length;
        verseBox.put(
          verse.id,
          Verselocal(
            save: l > 0 ? true : false,
            verseNo: verse.verseNo,
            verse: verse.verse,
            order: verse.order,
            commentaries: verse.commentaries!
                .map((com) => CommentaryLocal(
                    id: com.id, title: com.title, content: com.content))
                .toList(),
            id: verse.id,
            chapter: ChapterLocal(
                id: element.id,
                audio: element.audio,
                displayPosition: element.displayPosition,
                bookId: bookId,
                name: element.name,
                verses: [],
                book: null),
            footnotes: verse.footnotes!
                .map(
                  (e) => FootnotesLocal(id: e.id, title: e.title, verses: []),
                )
                .toList(),
          ),
        );
      }
    });
  }

  @override
  Widget buildContent(BuildContext context, BookPageVM viewModel) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData) {
          try {
            bookLocal = booksBox.values
                .where((element) => element.id == bookId)
                .toList()
                .first;
          } catch (e) {
            bookLocal = null;
          }
          if (snap.data == true) {
            // syncDataToOffline();
          }
          if (bookLocal != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(bookLocal!.name ?? ""),
                actions: HomePageState.buildAppBarActions(),
              ),
              body: Center(
                child: buildOnSuccess(context, viewModel),
              ),
            );
          } else {
            return Scaffold();
          }
        } else {
          return Scaffold();
        }
      },
      future: checkConnectivity(),
    );
  }

  @override
  BookPageVM initViewModel() => BookPageVM(bookId);

  Widget buildOnSuccess(BuildContext context, BookPageVM vm) {
    syncDataToOffline();
    //var chapters = vm.chapters;
    if (bookLocal == null) {
      return const Text('Could not load chapters');
    }

    var crossAxisSpacing = 4;
    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = 3;
    var width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    var cellHeight = 60;
    var aspectRatio = width / cellHeight;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: crossAxisSpacing.toDouble(),
      mainAxisSpacing: crossAxisSpacing.toDouble(),
      children:
          bookLocal!.chapters!.map((e) => buildChapterCell(context, e)).toList()
            ..insert(
              0,
              buildCell(
                context,
                '/book/$bookId/intro',
                'Introduction',
              ),
            ),
    );
  }

  Widget buildChapterCell(BuildContext context, ChapterLocal e) {
    var routeName = '/book/$bookId/chapter/${e.name}';
    var cellName = e.name;

    //print(e.verses);

    return buildCell(context, routeName, cellName);
  }

  InkWell buildCell(
    BuildContext context,
    String routeName,
    String cellName,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        height: kToolbarHeight,
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        child: Text(
          cellName,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
