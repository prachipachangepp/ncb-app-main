import 'package:flrx/flrx.dart';
import 'package:flrx/pages/page.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive/hive.dart';
import 'package:ncb/modules/common/pages/viewmodels/book_page_vm.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:recase/recase.dart';

import '../../../book_local.dart';
import '../../../chapter_local.dart';
import '../../../verselocal.dart';

class BookIntroPage extends StatefulWidget {
  final int bookId;

  const BookIntroPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  BookIntroPageState createState() => BookIntroPageState();
}

class BookIntroPageState extends State<BookIntroPage>
    with Page<AppState, BookPageVM> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');
  Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');

  ChapterLocal? chapter;
  BookLocal? bookLocal;

  void fetchData() {
    bookLocal = booksBox.values
        .where((element) => element.id == widget.bookId)
        .toList()
        .first;
  }

  String? currentAudio;

  @override
  Widget buildContent(BuildContext context, BookPageVM viewModel) {
    fetchData();
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text(bookLocal!.name.sentenceCase)),
        body: buildOnSuccess(viewModel));
  }

  Widget buildOnSuccess(BookPageVM viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: HtmlWidget(
        "<div>${bookLocal!.introduction}</div>",
      ),
    );
  }

  @override
  BookPageVM initViewModel() => BookPageVM(widget.bookId);
}
