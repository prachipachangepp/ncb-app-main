import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart' hide Pageredux;
import 'package:hive/hive.dart';
import 'package:ncb/dbconfig.dart';
import 'package:ncb/lexicon_local.dart';
import 'package:ncb/modules/common/models/lexicon.dart';
import 'package:ncb/newdb.dart';
import 'package:ncb/static_content_local.dart';

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
import '../service/testament_service.dart';

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

  Future<bool> getVerses() async {
    String? url = '${AppConfig.apiUrl}get-verses';
    // print(url);
    var dio = Dio();
    int count = 0;
    bool error = false;
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
          try {
            int l = bookmarkBox.values
                .where((ver) => ver.verse == verse.verse)
                .toList()
                .length;
            ChapterLocal chapterLocal = chapterBox.values
                .where((element) => element.id == verse.chapterId)
                .first;
            BookLocal bookLocal = booksBox.values
                .where((book) => book.id == chapterLocal.bookId)
                .first;
            chapterLocal = ChapterLocal(
                id: chapterLocal.id,
                audio: chapterLocal.audio,
                displayPosition: chapterLocal.displayPosition,
                bookId: chapterLocal.bookId,
                name: chapterLocal.name,
                verses: chapterLocal.verses,
                book: bookLocal);
            // BookLocal bookLocal = booksBox.values.where((book) => book.chapters.w )
            verseBox.put(
              verse.id,
              Verselocal(
                save: l > 0 ? true : false,
                verseNo: verse.verseNo,
                verse: verse.verse,
                order: verse.order,
                commentaries: a["commentary_content"] != null
                    ? [
                        CommentaryLocal(
                            title: a["commentary_title"].toString(),
                            content: a["commentary_content"].toString(),
                            id: 0)
                      ]
                    : [],
                id: verse.id,
                chapter: chapterLocal,
                footnotes: verse.footnotes!
                    .map(
                      (e) =>
                          FootnotesLocal(id: e.id, title: e.title, verses: []),
                    )
                    .toList(),
                chapterId: verse.chapterId,
              ),
            );
          } catch (e) {}
          // print(a["commentary_content"]);
          //print(verse.chapterId);
          count++;
        }
      } else {
        error = true;
        print(response.statusMessage);
      }

      print(count);
    }
    if (error) {
      return false;
    }
    return true;
  }

  Future<List<Lexicon>> getContent() async =>
      (await Application.get<TestamentService>().getLexicon()).data;

  Future<bool> syncTestamentsToOffline() async {
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
    if (testaments.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Chapter>> makeChapterRequest(int id) async {
    return await FetchChaptersAction(id).buildFuture();
  }

  Future<bool> createLexicon() async {
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
      if (lexicons.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      print("failed to add lexicon");
      return false;
    }
  }

  Future<StaticContent> getStaticContent(String url) async =>
      (await Application.get<TestamentService>().getContent(url)).data;

  Future<bool> createContent() async {
    List<String> urls = [
      'preface',
      'presentation',
      'introduction',
      'collaborator',
      'contact-us',
      'copyright',
    ];
    bool error = false;
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
        error = true;
      }
    }
    if (error) {
      return false;
    }
    return true;
  }

  Future<bool> createVersesBox() async {
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
        return false;
      }
    } catch (e) {
      return false;
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
    return true;
  }

  Future<bool> makeApiRequest(int value) async {
    if (value == 0) {
      print("Fetching Testaments");
      bool success = await syncTestamentsToOffline();
      return success;
    } else if (value == 1) {
      print("Fetching Chapters");
      bool success = await createVersesBox();
      return success;
    } else if (value == 2) {
      print("Fetching Verses");
      bool sucess = await getVerses();
      return sucess;
    } else if (value == 3) {
      print("Fetching Lexicon");
      bool sucess = await createLexicon();
      return sucess;
    } else if (value == 4) {
      print("Fetching Contents");
      bool sucess = await createContent();
      return sucess;
    } else {
      return true;
    }
  }

  bool error = false;
  Future<void> _updateProgress() async {
    int i = 0;
    bool l = false;
    int j = 0;
    while (i < 5) {
      if (j < 5) {
        bool outcome = await makeApiRequest(i);
        if (outcome) {
          error = false;
          setState(() {
            // we "finish" downloading here
            if (_progressValue <= 1.0) {
              // _loading = false;
              _progressValue += 0.2;
              _opacityValue -= 0.02;
            }
          });
          j = 0;
          i++;
        } else {
          l = true;
          j++;
        }
      } else {
        i = 5;
        l = true;
      }
    }
    if (l) {
      dbBox.flush();
      newdbBox.flush();
      setState(() {
        error = true;
      });
    }
    widget.loadingScreenCallBack(l);
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
                      Text(
                        error
                            ? "Something went wrong while fetching data please contact admin "
                            : "I waited patiently for the Lord; he inclined to me and heard my cry.” - Psalms 40:1",
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
                        child: error
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    error = false;
                                    _progressValue = 0.0;
                                    _opacityValue = 1.0;
                                    _updateProgress();
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      color: Theme.of(context).indicatorColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Retry",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .indicatorColor),
                                    ),
                                  ],
                                ))
                            : LinearProgressIndicator(
                                backgroundColor: Colors.black,
                                value: _progressValue,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      error
                          ? SizedBox()
                          : _progressValue * 100 >= 100
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
                        "I waited patiently for the Lord; he inclined to me and heard my cry.” - Psalms 40:1",
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
