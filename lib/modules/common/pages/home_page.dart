import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Pageredux;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ncb/app.dart';
import 'package:ncb/dbconfig.dart';
import 'package:ncb/lexicon_local.dart';
import 'package:ncb/modules/common/pages/bookmark.dart';
import 'package:ncb/modules/common/pages/lexicon_page.dart';
import 'package:ncb/modules/common/pages/search_page.dart';
import 'package:ncb/modules/common/pages/static_page.dart';
import 'package:ncb/modules/common/pages/testament_page.dart';
import 'package:ncb/modules/common/pages/update_page.dart';
import 'package:ncb/modules/common/pages/viewmodels/bottom_nav_bar.dart';
import 'package:ncb/newdb.dart';
import 'package:ncb/static_content_local.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../book_local.dart';
import '../../../chapter_local.dart';
import '../../../testament_local.dart';
import '../../../verselocal.dart';
import '../service/messaging_services.dart';
import 'loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.page}) : super(key: key);
  final int page;
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  var page = 0;
  bool first = true;
  bool showSearchView = false;
  String query = "";
  bool loading = true;
  bool update = false;
  bool connection = false;
  bool requested = false;
  final _messagingServiced = MessagingService();
  Box<DBConfig> dbBox = Hive.box<DBConfig>('dbConfig');
  Box<NewDB> newdbBox = Hive.box<NewDB>('newDB');
  Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');
  Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');
  Box<ChapterLocal> chapterBox = Hive.box<ChapterLocal>('chaptersBox');
  Box<TestamentLocal> testamentBox = Hive.box<TestamentLocal>('testamentBox');
  List list = [];
  Box<StaticContentLocal> staticContentBox =
      Hive.box<StaticContentLocal>('staticContentBox');
  Box<LexiconLocal> lexiconBox = Hive.box<LexiconLocal>('lexiconBox');
  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');
  Box<NewDB> dbbBox = Hive.box<NewDB>('db');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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

  int index = 0;

  Future<bool?> getDarkTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? d = prefs.getBool("darkMode");
    return d;
  }

  Future<void> setDarkTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", value);
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
      title: Container(
          width: 200,
          child: Marquee(
            text: appBarTitle,
            style: textStyle,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 100,
            velocity: 20,
            pauseAfterRound: Duration(seconds: 2),
            showFadingOnlyWhenScrolling: false,
            fadingEdgeStartFraction: 0.1,
            fadingEdgeEndFraction: 0.1,
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          )),
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
                if (_ == vm.darkMode) return;
                print("Changed Value ${_}");
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

  Future<void> shareApp() async {
    if (kIsWeb) {
      return Share.share(Uri.base.toString());
    }

    if (Platform.isAndroid) {
      return Share.share(
        "https://play.google.com/store/apps/details?id=in.ncb&pcampaignid=web_share",
      );
    }

    if (Platform.isIOS) {
      return Share.share(
        "https://apps.apple.com/in/app/new-community-bible/id1439308209",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (page == 2) {
      index = 1;
      // print("on bookmark");
      //print(index);
    } else {
      index = 0;
    }
    return Scaffold(
      bottomNavigationBar: showSearchView
          ? null
          : CustomNavBar(
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
                if (dbbBox.values.length == 0) {
                  loading = true;
                  dbbBox.add(NewDB(created: true));
                  createRecord();
                } else {
                  fetchData();
                  loading = false;
                  // createRecord();
                }
                requested = true;
              }
            } else {
              /// print("offline mode");
              if (dbBox.values.length == 0) {
                loading = true;
              } else {
                //  print("d");
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
                          print("Loading value $loading");
                          setState(() {
                            loading = value;
                          });
                        },
                        connection: connection,
                      )
                    : update
                        ? UpdateScreen(
                            loadingScreenCallBack: (val) {
                              setState(() {
                                update = val;
                              });
                            },
                            connection: connection,
                            list: list)
                        : const SizedBox(),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<bool> fetchData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // String apiUrl = 'https://admin.newcommunitybible.in/api/get-updates?date=2024-02-12';
    String apiUrl =
        'https://admin.newcommunitybible.in/api/get-updates?date=$formattedDate';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print(formattedDate);
        print("successful");
        var data = jsonDecode(response.body);
        print(data);
        list = data['modules'];
        String date = data['last_updated_date'].toString();
        print(list);
        DateTime da = DateTime.parse(date);
        print(date);
        print(da.hour);
        if (list.length > 0) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String? t = await preferences.getString("utime");
          if (t != null) {
            DateTime dateTime = DateTime.parse(t);
            print(da);
            print(dateTime);
            if (da.isAfter(dateTime)) {
              print("After");
              setState(() {
                update = true;
              });
              preferences.setString("utime", da.toString());
            } else {
              print("Before");
              setState(() {
                update = false;
              });
              print("No updates found");
            }
          } else {
            setState(() {
              update = true;
            });
            preferences.setString("utime", da.toString());
          }
        }
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return false;
    }
  }
}
