import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/modules/common/pages/home_page.dart';
import 'package:ncb/modules/common/pages/search_page.dart';
import 'package:ncb/modules/common/pages/viewmodels/bottom_nav_bar.dart';
import 'package:ncb/verselocal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';
import '../../../commentary_local.dart';
import '../../../footnoteslocal.dart';
import '../../../store/actions/actions.dart';
import '../../../store/states/app_state.dart';
import '../models/verse.dart';

class BookPage extends StatefulWidget {
  final int bookId;
  BookPage({Key? key, required this.bookId}) : super(key: key);
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  BookLocal? bookLocal;
  late Box<BookLocal> booksBox;
  late Box<Verselocal> verseBox;
  late Box<Verselocal> bookmarkBox;
  bool showSearchView = false;
  bool first = true;
  String query = "";
  @override
  void initState() {
    super.initState();
    booksBox = Hive.box<BookLocal>('booksBox');
    verseBox = Hive.box<Verselocal>('verseBox');
    bookmarkBox = Hive.box<Verselocal>('bookmarks');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      first = false;
    });
  }

  Widget buildBody() {
    return IndexedStack(
      index: showSearchView ? 0 : 1,
      children: [
        SearchView(
          key: Key(query.toString()),
          query: query,
        ),
        buildOnSuccess(context, widget.bookId),
      ],
    );
  }

  Future<bool> getDarkTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? d = prefs.getBool("darkMode");
    return d!;
  }

  Future<void> setDarkTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData) {
          try {
            bookLocal = booksBox.values
                .where((element) => element.id == widget.bookId)
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
              bottomNavigationBar: CustomNavBar(
                index: 0,
                bottomBarCallBack: (int id) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(page: id)),
                      (route) => false);
                },
              ),
              appBar: PreferredSize(
                preferredSize: Size(double.maxFinite, 50),
                child: buildAppBar(),
              ),
// appBar: AppBar(
//   title: Text(bookLocal!.name ?? ""),
//   actions: buildAppBarActions(),
// ),
              body: buildBody(),
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

  List<Widget> buildAppBarActions() {
    return [
      StoreConnector<AppState, AppVM>(
        converter: (store) => AppVM()..init(store),
        builder: (context, vm) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DayNightSwitcherIcon(
              isDarkModeEnabled: vm.darkMode,
              dayBackgroundColor: Theme.of(context).primaryColor,
              onStateChanged: (_) async {
// print("First is $first");
// if (first) {
//
// }
                if ((_) != vm.darkMode) {
                  first = true;
                }
                if (first) {
                  await vm.toggleDarkMode();
                }
              },
            ),
            PopupMenuButton(
              icon: const Icon(Icons.text_rotation_none),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 100,
                    child: buildChangeTextSize(vm, context),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    ];
  }

  static Row buildChangeTextSize(AppVM vm, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: vm.decreaseTextSize,
          icon: const Text('-'),
        ),
        const Text('A'),
        IconButton(
          onPressed: vm.increaseTextSize,
          icon: const Text('+'),
        ),
      ],
    );
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
                bookId: widget.bookId,
                name: element.name,
                verses: [],
                book: null),
            footnotes: verse.footnotes!
                .map(
                  (e) => FootnotesLocal(id: e.id, title: e.title, verses: []),
                )
                .toList(),
            chapterId: verse.chapterId,
          ),
        );
      }
    });
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
// print(connectivityResult.name);
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

  Widget buildOnSuccess(BuildContext context, int bookId) {
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
    bookLocal!.chapters!
        .sort(((a, b) => a.displayPosition.compareTo(b.displayPosition)));
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
    var routeName = '/book/${widget.bookId}/chapter/${e.name}';
    var cellName = e.name;
    return buildCell(context, routeName, cellName);
  }

  InkWell buildCell(BuildContext context, String routeName, String cellName) {
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

  FloatingSearchAppBar buildAppBar() {
    var theme = Theme.of(context);
    var appBarColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surface
        : theme.primaryColor;
    var textStyle = const TextStyle(color: Colors.white);
    return FloatingSearchAppBar(
      color: appBarColor,
      colorOnScroll: appBarColor,
      iconColor: theme.primaryIconTheme.color,
      elevation: 0,
      brightness: theme.brightness,
      liftOnScrollElevation: 0,
      hintStyle: textStyle,
      titleStyle: textStyle,
      title: Text("${bookLocal?.name}", style: textStyle),
//title: Text("${bookLocal?.name}: ${widget.chapter.name}", style: textStyle),
      onQueryChanged: (q) => setState(() => query = q),
      onSubmitted: (q) => setState(() => query = q),
      debounceDelay: const Duration(milliseconds: 500),
      onFocusChanged: (hasFocus) => setState(() => showSearchView = hasFocus),
      actions: [
        FloatingSearchBarAction.searchToClear(
          color: theme.primaryIconTheme.color,
        ),
        if (!showSearchView) ...HomePageState().buildAppBarActions(),
      ],
      body: Container(),
    );
  }
}
