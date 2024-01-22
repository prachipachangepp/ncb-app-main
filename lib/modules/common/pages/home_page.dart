import 'dart:io';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ncb/app.dart';
import 'package:ncb/modules/common/pages/lexicon_page.dart';
import 'package:ncb/modules/common/pages/search_page.dart';
import 'package:ncb/modules/common/pages/static_page.dart';
import 'package:ncb/modules/common/pages/testament_page.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:share_plus/share_plus.dart';

import '../service/messaging_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with Page<AppState, AppVM> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  var page = 4;
  bool showSearchView = false;
  String query = "";
  final _messagingServiced = MessagingService();


  @override
  Widget buildContent(BuildContext context, AppVM viewModel) {
    return Scaffold(
      key: scaffoldKey,
      drawer: buildDrawer(),
      body: buildAppBar(),
    );
  }

  @override
  void initState() {
    super.initState();
    _messagingServiced.init(context);
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
          const StaticPage(url: 'preface'),
          const StaticPage(url: 'presentation'),
          const StaticPage(url: 'introduction'),
          const StaticPage(url: 'collaborator'),
          const TestamentPage(),
          const LexiconPage(),
          const StaticPage(url: 'contact-us'),
          const StaticPage(url: 'copyright'),
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
        title: const Text('General Introduction'),
        onTap: () => setPageAndPop(2),
      ),
      ListTile(
        title: const Text('List of Collaborators'),
        onTap: () => setPageAndPop(3),
      ),
      ListTile(
        title: const Text('New Community Bible'),
        onTap: () => setPageAndPop(4),
      ),
      ListTile(
        title: const Text('Lexicon'),
        onTap: () => setPageAndPop(5),
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
        onTap: () => setPageAndPop(6),
      ),
      ListTile(
        title: const Text('Copyright'),
        onTap: () => setPageAndPop(7),
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
