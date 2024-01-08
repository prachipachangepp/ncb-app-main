import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart' hide Page, Banner;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/modules/common/pages/viewmodels/post_page_vm.dart';
import 'package:ncb/modules/common/widgets/banner_widget.dart';
import 'package:ncb/modules/common/widgets/testament_grid.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:ncb/testament_local.dart';

class TestamentPage extends StatelessWidget
    with Page<AppState, TestamentPageVM> {
  TestamentPage({Key? key}) : super(key: key);
  List<TestamentLocal> local = [];

  Box<TestamentLocal> testamentBox = Hive.box<TestamentLocal>('testamentBox');
  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');
  Box<ChapterLocal> chapterBox = Hive.box<ChapterLocal>('chaptersBox');
  @override
  void onInitialBuild(TestamentPageVM viewModel) {
    // viewModel
    //   ..fetchTestaments()
    //   ..fetchBanners();
  }

  @override
  Widget buildContent(BuildContext context, TestamentPageVM viewModel) {
    for (var element in testamentBox.values) {
      local.add(TestamentLocal(
        id: element.id,
        displayPosition: element.displayPosition,
        name: element.name,
        books: element.books
            .map((e) => BookLocal(
                id: e.id,
                name: e.name,
                displayPosition: e.displayPosition,
                testamentId: e.testamentId,
                introduction: e.introduction,
                chapters: []))
            .toList(),
      ));
    }

    return Column(
      children: [
        //   buildBanner(viewModel),
        buildBody(viewModel, context),
      ],
    );
  }

  Widget buildBody(TestamentPageVM vm, BuildContext context) {
    //syncDataToOffline(vm);
    // syncTestamentsToOffline(vm);
    return Expanded(child: buildOnSuccess(context, vm));
  }

  Widget buildBanner(TestamentPageVM vm) {
    return vm.bannerLoadingState.maybeWhen(
      success: () {
        return vm.banner == null
            ? const SizedBox()
            : BannerWidget(banner: vm.banner!);
      },
      orElse: () => const SizedBox(),
    );
  }

  //

  // Future<void> syncDataToOffline(TestamentPageVM vm) async {
  //   // List<Testament> testaments = await FetchTestamentsAction().buildFuture();
  //   for (var element in vm.testaments!) {
  //     for (var book in element.books) {
  //       await Future.delayed(Duration(seconds: 1));
  //       List<Chapter> c = await FetchChaptersAction(book.id).buildFuture();
  //       List<ChapterLocal> localChapters = [];
  //       c.forEach((e) {
  //         localChapters.add(ChapterLocal(
  //             id: e.id,
  //             audio: e.audio,
  //             displayPosition: e.displayPosition,
  //             bookId: e.bookId,
  //             name: e.name,
  //             verses: [],
  //             book: null));
  //       });
  //       // print("Chapter for book " +
  //       //     element.id.toString() +
  //       //     " e legth " +
  //       //     book.name);
  //       booksBox.put(
  //         book.id.toString(),
  //         BookLocal(
  //             id: book.id,
  //             name: book.name,
  //             displayPosition: book.displayPosition,
  //             testamentId: book.testamentId,
  //             introduction: book.introduction,
  //             chapters: localChapters),
  //       );
  //     }
  //   }
  // }

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

  @override
  TestamentPageVM initViewModel() => TestamentPageVM();

  Widget buildOnSuccess(BuildContext context, TestamentPageVM vm) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: local.length,
      itemBuilder: (BuildContext context, int index) => buildTestaments(
        context,
        local[index],
      ),
    );
  }

  Widget buildTestaments(BuildContext context, TestamentLocal testament) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTestamentHeading(testament, context),
        TestamentGrid(testament: testament),
      ],
    );
  }

  Container buildTestamentHeading(
      TestamentLocal testament, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xff616161),
      height: kToolbarHeight,
      child: Text(
        testament.name,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
