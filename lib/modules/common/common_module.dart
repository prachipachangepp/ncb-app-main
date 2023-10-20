import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flrx/components/modules/module.dart';
import 'package:flrx/flrx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart' as logging;
import 'package:ncb/config/app_config.dart';
import 'package:ncb/firebase_options.dart';
import 'package:ncb/modules/common/pages/book_intro_page.dart';
import 'package:ncb/modules/common/pages/book_page.dart';
import 'package:ncb/modules/common/pages/chapter_page.dart';
import 'package:ncb/modules/common/pages/home_page.dart';
import 'package:ncb/modules/common/pages/search_page.dart';
import 'package:ncb/modules/common/repositories/chapter_repository.dart';
import 'package:ncb/modules/common/repositories/chapter_repository.impl.dart';
import 'package:ncb/modules/common/repositories/testament_repository.dart';
import 'package:ncb/modules/common/repositories/testament_repository.impl.dart';
import 'package:ncb/modules/common/repositories/verse_repository.dart';
import 'package:ncb/modules/common/repositories/verse_repository.impl.dart';
import 'package:ncb/modules/common/service/testament_service.dart';

class CommonModule extends Module {
  @override
  String get name => "common";

  @override
  bool get shouldNamespaceRoutes => false;

  @override
  Map<String, RouteWidgetBuilder> routes() {
    return {
      "/": (args) => const HomePage(),
      "/search": (args) => const SearchView(),
      "/book/:bookId": (args) => BookPage(
            bookId: int.parse(args['bookId']![0]),
          ),
      "/book/:bookId/intro": (args) => BookIntroPage(
            bookId: int.parse(args['bookId']![0]),
          ),
      "/book/:bookId/chapter/:chapterId": (args) => ChapterPage(
            bookId: int.parse(args['bookId']![0]),
            chapterId: int.parse(args['chapterId']![0]),
          ),
    };
  }

  @override
  Future<void> register() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    locator.registerSingleton<Logger>(Logger());
    var dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );
    locator.registerSingleton<Dio>(dio);
    locator
      ..registerSingleton<TestamentService>(TestamentService.newInstance(dio))
      ..registerSingleton<TestamentRepository>(TestamentRepositoryImpl())
      ..registerSingleton<ChapterRepository>(ChapterRepositoryImpl())
      ..registerSingleton<VerseRepository>(VerseRepositoryImpl());
    locator.registerSingleton<AudioPlayer>(AudioPlayer());
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  @override
  Future<void> boot() async {
    logging.Logger.level = logging.Level.nothing;
  }
}
