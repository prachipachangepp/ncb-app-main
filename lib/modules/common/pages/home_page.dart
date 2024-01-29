import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dio/dio.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive/hive.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ncb/app.dart';
import 'package:ncb/dbconfig.dart';
import 'package:ncb/lexicon_local.dart';
import 'package:ncb/modules/common/models/lexicon.dart';
import 'package:ncb/modules/common/pages/bookmark.dart';
import 'package:ncb/modules/common/pages/lexicon_page.dart';
import 'package:ncb/modules/common/pages/search_page.dart';
import 'package:ncb/modules/common/pages/static_page.dart';
import 'package:ncb/modules/common/pages/testament_page.dart';
import 'package:ncb/modules/common/pages/viewmodels/bottom_nav_bar.dart';
import 'package:ncb/newdb.dart';
import 'package:ncb/static_content_local.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:share_plus/share_plus.dart';

import '../../../book_local.dart';
import '../../../chapter_local.dart';
import '../../../commentary_local.dart';
import '../../../config/app_config.dart';
import '../../../footnoteslocal.dart';
import '../../../store/actions/actions.dart';
import '../../../testament_local.dart';
import '../../../verselocal.dart';
import '../models/chapter.dart';
import '../models/static_content.dart';
import '../models/testament.dart';
import '../models/verse.dart';
import '../service/messaging_services.dart';
import '../service/testament_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.page}) : super(key: key);
  final int page;
  @override
  HomePageState createState() => HomePageState();
}

class LoadingScreen extends StatefulWidget {
  LoadingScreen(
      {Key? key, required this.loadingScreenCallBack, required this.connection})
      : super(key: key);
  final LoadingScreenCallBack loadingScreenCallBack;
  final bool connection;
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

typedef LoadingScreenCallBack(bool value);

class _LoadingScreenState extends State<LoadingScreen> {
  double _progressValue = 0.0;
  double _opacityValue = 1.0;

  void _updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        // we "finish" downloading here
        if (_progressValue <= 1.0) {
          // _loading = false;
          _progressValue += 0.05;
          _opacityValue -= 0.005;
        } else {
          widget.loadingScreenCallBack(false);
          t.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.connection) {
      _updateProgress();
    }
  }

  Widget activeInternetLoadingScreen() {
    return Stack(
      children: [
        Opacity(
          opacity: _opacityValue,
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: const Color(0xff8e1c18),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(),
                  Column(
                    children: [
                      const Image(image: AssetImage("assets/images/logo.png")),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Please wait ,downloading resources",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.black,
                          value: _progressValue,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _progressValue * 100 >= 100
                          ? Text(
                              'Loading..',
                              style: const TextStyle(color: Colors.white),
                            )
                          : Text(
                              '${(_progressValue * 100).round()}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget inactiveInternetLoadingScreen() {
    return Stack(
      children: [
        Opacity(
          opacity: _opacityValue,
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: const Color(0xff8e1c18),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "No Network !",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Icon(
                        Icons
                            .signal_wifi_statusbar_connected_no_internet_4_outlined,
                        color: Colors.white,
                        size: 70,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Image(image: AssetImage("assets/images/logo.png")),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please turn on your internet connection for downloading resources",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "These are the bible files which allows you to have a seamless performance even if your devices have no active internet connection. for the very first time only you need to get connected with internet",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.connection
        ? activeInternetLoadingScreen()
        : inactiveInternetLoadingScreen();
  }
}

class HomePageState extends State<HomePage> with Page<AppState, AppVM> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  var page = 0;
  bool showSearchView = false;
  String query = "";
  Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');
  Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');
  Box<ChapterLocal> chapterBox = Hive.box<ChapterLocal>('chaptersBox');
  Box<TestamentLocal> testamentBox = Hive.box<TestamentLocal>('testamentBox');
  Box<StaticContentLocal> staticContentBox =
      Hive.box<StaticContentLocal>('staticContentBox');
  Box<LexiconLocal> lexiconBox = Hive.box<LexiconLocal>('lexiconBox');
  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');
  Box<DBConfig> dbBox = Hive.box<DBConfig>('dbConfig');
  Box<NewDB> newdbBox = Hive.box<NewDB>('newDB');
  bool loading = true;
  bool connection = false;
  bool requested = false;
  final _messagingServiced = MessagingService();

  Stream<bool> checkConnectivity() async* {
    while (!connection) {
      final connectivityResult =
          await Future.delayed(const Duration(seconds: 1))
              .then((value) => Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        yield true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        yield true;
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        yield true;
      } else if (connectivityResult == ConnectivityResult.vpn) {
        yield true;
      } else if (connectivityResult == ConnectivityResult.bluetooth) {
        yield true;
      } else if (connectivityResult == ConnectivityResult.other) {
        yield true;
        // I am connected to a network which is not in the above mentioned networks.
      } else if (connectivityResult == ConnectivityResult.none) {
        yield false;
      } else {
        yield false;
      }
    }
  }

  Future<List<Lexicon>> getContent() async =>
      (await Application.get<TestamentService>().getLexicon()).data;

  Future<void> syncTestamentsToOffline() async {
    Future.delayed(const Duration(seconds: 1));
    List<Testament> testaments = await FetchTestamentsAction().buildFuture();
    for (var element in testaments) {
      testamentBox.put(
        element.id.toString(),
        TestamentLocal(
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
        ),
      );
    }
  }

  Future<List<Chapter>> makeChapterRequest(int id) async {
    return await FetchChaptersAction(id).buildFuture();
  }

  Future<void> createLexicon() async {
    try {
      List<Lexicon> lexicons = await Future.delayed(
        const Duration(milliseconds: 100),
        () => getContent(),
      );
      for (var element in lexicons) {
        lexiconBox.put(
            element.title,
            LexiconLocal(
                title: element.title, description: element.description));
      }
    } catch (e) {
      print("failed to add lexicon");
    }
  }

  Future<StaticContent> getStaticContent(String url) async =>
      (await Application.get<TestamentService>().getContent(url)).data;

  Future<void> createContent() async {
    List<String> urls = [
      'preface',
      'presentation',
      'introduction',
      'collaborator',
      'contact-us',
      'copyright',
    ];

    for (var a in urls) {
      try {
        print("Content add for $a");
        StaticContent staticContent = await Future.delayed(
          const Duration(milliseconds: 500),
          () => getStaticContent(a),
        );
        staticContentBox.put(
          a,
          StaticContentLocal(content: staticContent.content),
        );
      } catch (e) {
        print("failed to add content $a");
      }
    }
  }

  Future<void> createVersesBox() async {
    try {
      var dio = Dio();
      var response = await dio.request(
        '${AppConfig.apiUrl}get-chapters',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        for (var chap in response.data['data']) {
          Chapter chapter = Chapter.fromJson(chap);
          ChapterLocal chapterLocal = ChapterLocal(
              id: chapter.id,
              audio: chapter.audio,
              displayPosition: chapter.displayPosition,
              bookId: chapter.bookId,
              name: chapter.name,
              verses: [],
              book: null);
          chapterBox.put(chapter.id.toString(), chapterLocal);
        }
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
    for (var element in testamentBox.values) {
      for (var book in element.books) {
        print("adding " + book.name);

        List<ChapterLocal> localChapters = [];
        localChapters = chapterBox.values
            .where((chapters) => chapters.bookId == book.id)
            .toList();
        String audio = '';
        booksBox.put(
          book.id.toString(),
          BookLocal(
              id: book.id,
              name: book.name,
              displayPosition: book.displayPosition,
              testamentId: book.testamentId,
              introduction: book.introduction,
              chapters: localChapters),
        );
        // localChapters.forEach((element) async {
        //   List<Verse> v =
        //       await Future.delayed(const Duration(milliseconds: 500))
        //           .then((value) {
        //     return FetchVersesAction(element.id).buildFuture();
        //   });
        //   for (var verse in v) {
        //     int l = bookmarkBox.values
        //         .where((ver) => ver.verse == verse.verse)
        //         .toList()
        //         .length;
        //     verseBox.put(
        //       verse.id,
        //       Verselocal(
        //         save: l > 0 ? true : false,
        //         verseNo: verse.verseNo,
        //         verse: verse.verse,
        //         order: verse.order,
        //         commentaries: verse.commentaries!
        //             .map((com) => CommentaryLocal(
        //                 id: com.id, title: com.title, content: com.content))
        //             .toList(),
        //         id: verse.id,
        //         footnotes: verse.footnotes!
        //             .map(
        //               (e) => FootnotesLocal(
        //                   id: e.id, title: e.title, verses: []),
        //             )
        //             .toList(),
        //         chapterId: verse.chapterId,
        //       ),
        //     );
        //   }
        // });
      }
    }
  }

  Future<void> syncDataToOffline() async {
    print("Syncing data");
    await syncTestamentsToOffline();
    await createVersesBox();
    await getVerses();
    await createLexicon();
    await createContent();
  }

  Future<void> createRecord() async {
    if (connection) {
      loading = true;
      connection = true;
    } else {
      loading = true;
      connection = false;
    }
  }

  @override
  void initState() {
    page = widget.page;
    _messagingServiced.init(context);
    // TODO: implement initState
    super.initState();
  }

  Future<void> getVerses() async {
    String? url = '${AppConfig.apiUrl}get-verses';
    var dio = Dio();
    int count = 0;
    while (url != null) {
      await Future.delayed(Duration(milliseconds: 300));
      var response = await dio.request(
        url,
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        url = response.data['data']['next_page_url'].toString();
        if (url == "null") {
          url = null;
        }
        for (var a in response.data['data']['data']) {
          // print(a);
          Verse verse = Verse.fromJson(a);
          verse.commentaries ?? [];
          int l = bookmarkBox.values
              .where((ver) => ver.verse == verse.verse)
              .toList()
              .length;
          // BookLocal bookLocal = booksBox.values.where((book) => book.chapters.w )
          verseBox.put(
            verse.id,
            Verselocal(
              save: l > 0 ? true : false,
              verseNo: verse.verseNo,
              verse: verse.verse,
              order: verse.order,
              commentaries: verse.commentaries != null
                  ? verse.commentaries!
                      .map((com) => CommentaryLocal(
                          id: com.id, title: com.title, content: com.content))
                      .toList()
                  : [],
              id: verse.id,
              footnotes: verse.footnotes!
                  .map(
                    (e) => FootnotesLocal(id: e.id, title: e.title, verses: []),
                  )
                  .toList(),
              chapterId: verse.chapterId,
            ),
          );
          // print(verse.chapter!.name);
          //print(verse.chapterId);
          count++;
        }
      } else {
        print(response.statusMessage);
      }

      print(count);
    }
  }

  int index = 0;
  @override
  Widget buildContent(BuildContext context, AppVM viewModel) {
    if (page == 2) {
      index = 1;
      print("on bookmark");
      print(index);
    } else {
      index = 0;
    }
    return Scaffold(
      bottomNavigationBar: CustomNavBar(
        index: index,
        bottomBarCallBack: (int id) {
          setState(() {
            page = id;
          });
        },
      ),
      key: scaffoldKey,
      drawer: buildDrawer(),
      body: StreamBuilder<bool>(
        stream: checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            connection = snapshot.data!;
            if (connection) {
              if (!requested) {
                if (dbBox.values.length > 0) {
                  if (newdbBox.values.length <= 0) {
                    loading = true;
                    syncDataToOffline();
                    createRecord();
                    //print("Ahhhh");
                    newdbBox.add(NewDB(created: true));
                  } else {
                    loading = false;
                    connection = true;
                    // print("New df");
                    print(newdbBox.length);
                    print(newdbBox.length);
                  }
                } else {
                  loading = true;
                  syncDataToOffline();
                  createRecord();
                }
                requested = true;
              }
            } else {
              print("offline mode");
              if (dbBox.values.length == 0) {
                loading = true;
              } else {
                print("d");
                loading = false;
              }
              loading = false;
              requested = false;
            }

            return Stack(
              children: [
                buildAppBar(),
                loading
                    ? LoadingScreen(
                        loadingScreenCallBack: (bool value) {
                          dbBox.add(DBConfig(created: true));
                          setState(() {
                            loading = value;
                          });
                        },
                        connection: connection,
                      )
                    : const SizedBox(),
              ],
            );
          }
          return Container();
        },
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
      liftOnScrollElevation: 0,
      hintStyle: textStyle,
      titleStyle: textStyle,
      title: Text(appBarTitle, style: textStyle),
      onQueryChanged: (q) => setState(() => query = q),
      onSubmitted: (q) => setState(() => query = q),
      debounceDelay: const Duration(milliseconds: 500),
      onFocusChanged: (hasFocus) => setState(() => showSearchView = hasFocus),
      actions: [
        FloatingSearchBarAction.searchToClear(
          color: theme.primaryIconTheme.color,
        ),
        if (!showSearchView) ...buildAppBarActions(),
      ],
      body: buildBody(),
    );
  }

  String get appBarTitle {
    return [
      'Preface',
      'Presentation',
      'Bookmark',
      'General Introduction',
      'List of Collaborators',
      'New Community Bible',
      'Lexicon',
      'Contact Us',
      'Copyright',
    ][page];
  }

  Widget buildBody() {
    return IndexedStack(
      index: showSearchView ? 0 : 1,
      children: [
        SearchView(
          key: Key(query.toString()),
          query: query,
        ),
        [
          StaticPage(url: 'preface'),
          StaticPage(url: 'presentation'),
          BookMarkPage(),
          StaticPage(url: 'introduction'),
          StaticPage(url: 'collaborator'),
          TestamentPage(),
          LexiconPage(),
          StaticPage(url: 'contact-us'),
          StaticPage(url: 'copyright'),
        ][page],
      ],
    );
  }

  static List<Widget> buildAppBarActions() {
    return [
      StoreConnector<AppState, AppVM>(
        converter: (store) => AppVM()..init(store),
        builder: (context, vm) => Row(
          children: [
            DayNightSwitcherIcon(
              isDarkModeEnabled: vm.darkMode,
              dayBackgroundColor: Theme.of(context).primaryColor,
              onStateChanged: (_) {
                if (_ == vm.darkMode) return;
                vm.toggleDarkMode();
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

  Drawer buildDrawer() {
    var tiles = drawerTiles();

    return Drawer(
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Image.asset(
              'assets/images/logo.webp',
              fit: BoxFit.cover,
              height: constraints.maxWidth * 0.8,
              width: constraints.maxWidth,
            );
          }),
          Expanded(
            child: ListTileTheme(
              style: ListTileStyle.drawer,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: tiles.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) => tiles[index],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ListTile> drawerTiles() {
    return [
      ListTile(
        title: const Text('Preface'),
        onTap: () => setPageAndPop(0),
      ),
      ListTile(
        title: const Text('Presentation'),
        onTap: () => setPageAndPop(1),
      ),
      ListTile(
        title: const Text('Bookmark'),
        onTap: () => setPageAndPop(2),
      ),
      ListTile(
        title: const Text('General Introduction'),
        onTap: () => setPageAndPop(3),
      ),
      ListTile(
        title: const Text('List of Collaborators'),
        onTap: () => setPageAndPop(4),
      ),
      ListTile(
        title: const Text('New Community Bible'),
        onTap: () => setPageAndPop(5),
      ),
      ListTile(
        title: const Text('Lexicon'),
        onTap: () => setPageAndPop(6),
      ),
      ListTile(
        title: const Text('Share App'),
        onTap: () {
          shareApp();
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Contact Us'),
        onTap: () => setPageAndPop(7),
      ),
      ListTile(
        title: const Text('Copyright'),
        onTap: () => setPageAndPop(8),
      ),
    ];
  }

  void setPageAndPop(int page) {
    setState(() => this.page = page);
    Navigator.pop(context);
  }

  @override
  AppVM initViewModel() => AppVM();

  Future<void> shareApp() async {
    if (kIsWeb) {
      return Share.share(Uri.base.toString());
    }

    if (Platform.isAndroid) {
      return Share.share(
        "https://play.google.com/store/apps/details?id=in.wi.ncb&hl=en_IN&gl=US",
      );
    }

    if (Platform.isIOS) {
      return Share.share(
        "https://apps.apple.com/in/app/new-community-bible/id1439308209",
      );
    }
  }
}
