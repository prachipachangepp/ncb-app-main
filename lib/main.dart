import 'package:firebase_core/firebase_core.dart';
import 'package:flrx/components/error_manager/error_manager.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ncb/app.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/commentary_local.dart';
import 'package:ncb/config/app_config.dart';
import 'package:ncb/config/error_reporter_config.dart';
import 'package:ncb/dbconfig.dart';
import 'package:ncb/firebase_options.dart';
import 'package:ncb/footnoteslocal.dart';
import 'package:ncb/lexicon_local.dart';
import 'package:ncb/static_content_local.dart';
import 'package:ncb/store/states/app_state.dart';
import 'package:ncb/store/store_retriever.dart';
import 'package:ncb/testament_local.dart';
import 'package:ncb/verselocal.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(VerselocalAdapter());
  Hive.registerAdapter(ChapterLocalAdapter());
  Hive.registerAdapter(TestamentLocalAdapter());
  Hive.registerAdapter(BookLocalAdapter());
  Hive.registerAdapter(FootnotesLocalAdapter());
  Hive.registerAdapter(CommentaryLocalAdapter());
  Hive.registerAdapter(DBConfigAdapter());
  Hive.registerAdapter(LexiconLocalAdapter());
  Hive.registerAdapter(StaticContentLocalAdapter());
  await Hive.openBox<Verselocal>('bookmarks');
  await Hive.openBox<Verselocal>('verseBox');
  await Hive.openBox<TestamentLocal>('testamentBox');
  await Hive.openBox<ChapterLocal>('chaptersBox');
  await Hive.openBox<BookLocal>('booksBox');
  await Hive.openBox<DBConfig>('dbConfig');
  await Hive.openBox<LexiconLocal>('lexiconBox');
  await Hive.openBox<StaticContentLocal>('staticContentBox');

  AppRouter.setNotFoundWidget((p) => StatefulBuilder(builder: (c, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(c, '/', ModalRoute.withName('/'));
        });

        return const SizedBox();
      }));

  var appConfig = AppConfig();
  var application = Application(initApp, appConfig: appConfig);

  Application.serviceLocator.registerSingleton<ErrorManager>(
    CatcherErrorManager(
      catcherConfig: appConfig.errorReporterConfig as NcbErrorReporterConfig,
      navigatorKey: appConfig.navigatorKey,
    ),
  );

  application.init();
}

Future<void> initApp() async {
  Store<AppState> store = await AppStoreRetriever().retrieveStore();
  runApp(
    MaterialApp(
      home: StoreProvider<AppState>(
        store: store,
        child: const App(),
      ),
    ),
  );
}
