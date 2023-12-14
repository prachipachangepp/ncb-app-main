import 'package:flrx/pages/page.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/pages/home_page.dart';
import 'package:ncb/modules/common/pages/viewmodels/book_page_vm.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:recase/recase.dart';

class BookPage extends StatelessWidget with Page<AppState, BookPageVM> {
  final int bookId;

  const BookPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  void onInitialBuild(BookPageVM viewModel) {
    viewModel.fetchChapters(bookId);
  }

  @override
  Widget buildContent(BuildContext context, BookPageVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.book.name.titleCase),
        actions: HomePageState.buildAppBarActions(),
      ),
      body: Center(
        child: viewModel.loadingState.when(
          initial: () => const CircularProgressIndicator(),
          loading: () => const CircularProgressIndicator(),
          failed: () => Text(viewModel.error!),
          success: () => buildOnSuccess(context, viewModel),
        ),
      ),
    );
  }

  @override
  BookPageVM initViewModel() => BookPageVM(bookId);

  Widget buildOnSuccess(BuildContext context, BookPageVM vm) {
    var chapters = vm.chapters;
    if (chapters == null) {
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
      children: chapters.map((e) => buildChapterCell(context, e)).toList()
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

  Widget buildChapterCell(BuildContext context, Chapter e) {
    var routeName = '/book/$bookId/chapter/${e.id}';
    var cellName = e.name;

    print(e.verses);

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
