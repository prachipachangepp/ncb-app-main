import 'package:flrx/flrx.dart';
import 'package:flrx/pages/page.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ncb/modules/common/pages/viewmodels/book_page_vm.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:recase/recase.dart';

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

  String? currentAudio;

  @override
  Widget buildContent(BuildContext context, BookPageVM viewModel) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(viewModel.book.name.sentenceCase)),
      body: viewModel.loadingState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        failed: () => Center(child: Text(viewModel.error!)),
        success: () => buildOnSuccess(viewModel),
      ),
    );
  }

  Widget buildOnSuccess(BookPageVM viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: HtmlWidget(
        "<div>${viewModel.book.introduction}</div>",
      ),
    );
  }

  @override
  BookPageVM initViewModel() => BookPageVM(widget.bookId);
}
