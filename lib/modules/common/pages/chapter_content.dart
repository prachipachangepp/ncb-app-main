import 'dart:math';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/pages/home_page.dart';
import 'package:ncb/modules/common/pages/search_page.dart';
import 'package:ncb/modules/common/pages/viewmodels/bottom_nav_bar.dart';
import 'package:ncb/modules/common/widgets/footnote_button.dart';
import 'package:recase/recase.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sorted/sorted.dart';

import '../../../app.dart';
import '../../../store/states/app_state.dart';
import '../../../verselocal.dart';
import '../widgets/commentary_button.dart';
import '../widgets/ncb_button_small.dart';
import '../widgets/share_chapter_button.dart';
import '../widgets/share_verse_button.dart';

typedef void BookmarckChangedCallBack(Verselocal verselocal);

class ChapterContent extends StatefulWidget {
  final BookLocal book;
  final ChapterLocal chapter;
  final int versId;
  String query = "";
  final BookmarckChangedCallBack bookmarckChangedCallBack;
  final String? currentAudio;
  final ValueSetter<String?> onAudioChanged;

  ChapterContent({
    Key? key,
    required this.chapter,
    required this.book,
    this.currentAudio,
    required this.onAudioChanged,
    required this.bookmarckChangedCallBack,
    required this.versId,
  }) : super(key: key);

  @override
  State<ChapterContent> createState() => ChapterContentState();
}

class ChapterContentState extends State<ChapterContent> {
  bool showSearchView = false;
  String query = "";
  AudioPlayer get player => Application.get<AudioPlayer>();
  final ItemScrollController itemScrollController = ItemScrollController();
  Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');
  List<Verselocal> verses = [];

  bool first = true;
  late ChapterLocal chapterLocal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<Verselocal> verse = widget.chapter.verses!;
    if (verse.isEmpty) {
      Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');
      verse = verseBox.values
          .where((element) => element.chapterId == widget.chapter.id)
          .toList();
      print(widget.versId);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => automatedScrolling(context));
    }
    chapterLocal = ChapterLocal(
        id: widget.chapter.id,
        audio: widget.chapter.audio,
        displayPosition: widget.chapter.displayPosition,
        bookId: widget.chapter.bookId,
        name: widget.chapter.name,
        verses: verse,
        book: widget.chapter.book);
    chapter = Chapter(
        id: widget.chapter.id,
        audio: widget.chapter.audio,
        displayPosition: widget.chapter.displayPosition,
        bookId: widget.chapter.bookId,
        name: widget.chapter.name,
        verses: verse
            .map((e) => Verse(
                id: e.id,
                verseNo: e.verseNo,
                verse: e.verse,
                order: e.order,
                chapterId: widget.chapter.id))
            .toList());
  }

  void automatedScrolling(BuildContext context) {
    Verselocal verse = chapterLocal.verses!
        .where((element) => element.verseNo == widget.versId)
        .first;
    itemScrollController.scrollTo(
      index: widget.versId,
      duration: Duration(
        milliseconds: max(100, verse.verseNo * 20),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      height: double.maxFinite,
      child: IndexedStack(
        index: showSearchView ? 0 : 1,
        children: [
          SearchView(
            key: Key(query.toString()),
            query: query,
          ),
        ],
      ),
    );
  }

  Chapter? chapter;
  @override
  Widget build(BuildContext context) {
    var verses = chapterLocal.verses!;
    if (first) {
      first = false;
    }
    var hasAudio = widget.chapter.audio?.isNotEmpty == true;

    return Scaffold(
      bottomNavigationBar: CustomNavBar(
        index: 0,
        bottomBarCallBack: (int id) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage(page: id)),
              (route) => false);
        },
      ),

      ///code changed
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: buildAppBar(),
      ),
      // AppBar(
      //   title: Text("${widget.book.name.titleCase}: ${widget.chapter.name}"),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () {
      //
      //
      //       },
      //     ),
      //   ]+  HomePageState.buildAppBarActions()
      //     ..insert(
      //       0,
      //       Container(
      //         margin: EdgeInsets.symmetric(horizontal: 10),
      //         child: ShareChapterButton(
      //           chapter: chapter!,
      //           bookName: widget.book.name.titleCase,
      //         ),
      //       ),
      //     ),
      // ),
      // bottomNavigationBar: hasAudio ? buildAudioPlayer() : null,
      body: showSearchView
          ? SearchView(
              key: Key(query.toString()),
              query: query,
            )
          : ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemCount: verses.length + 2,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return buildQuickJump(chapter!);
                }

                if (index == verses.length + 1) {
                  return buildNavigateChapters();
                }
                if (first) {
                  itemScrollController.scrollTo(
                    index: widget.versId,
                    duration: Duration(
                      milliseconds: max(100, widget.versId * 20),
                    ),
                  );
                }
                if (index < verses.length + 1) {
                  var vers = verses[index - 1];
                  // print(vers.order);
                  vers.chapter = ChapterLocal(
                      id: chapter!.id,
                      audio: chapter!.audio,
                      displayPosition: chapter!.displayPosition,
                      bookId: chapter!.bookId,
                      name: chapter!.name,
                      verses: [],
                      book: widget.book);
                  return Container(
                    color: index % 2 == 0
                        ? Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.grey[300]
                        : null,
                    padding: const EdgeInsets.all(16),
                    child: VerseRow(
                      verse: vers,
                      callBackBookmark: (bool value) async {
                        if (!vers.save) {
                          bookmarkBox.add(Verselocal(
                            verseNo: vers.verseNo,
                            verse: vers.verse,
                            order: vers.order,
                            id: vers.id,
                            save: vers.save,
                            footnotes: vers.footnotes,
                            commentaries: vers.commentaries,
                            chapter: widget.chapter,
                            chapterId: vers.chapterId,
                          ));
                          widget.bookmarckChangedCallBack(Verselocal(
                              save: true,
                              verseNo: vers.verseNo,
                              verse: vers.verse,
                              order: vers.order,
                              chapter: widget.chapter,
                              id: vers.id,
                              chapterId: vers.chapterId));
                          setState(() {
                            verses[index - 1].save = true;
                          });
                        } else {
                          int jkf = 0;
                          int k = 0;
                          for (var element in bookmarkBox.values) {
                            if (element.verseNo ==
                                widget.chapter.verses![index].verseNo) {
                              k = jkf;
                            }
                            jkf++;
                          }
                          bookmarkBox.deleteAt(k);
                          // print(bookmarkBox.length);
                          // print("removed");
                          widget.bookmarckChangedCallBack(Verselocal(
                              save: false,
                              verseNo: vers.verseNo,
                              verse: vers.verse,
                              chapter: widget.chapter,
                              order: vers.order,
                              id: vers.id,
                              chapterId: vers.chapterId));

                          setState(() {
                            verses[index - 1].save = false;
                          });
                        }
                      },
                      bookMark: verses[index - 1].save,
                      search: false,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
    );
  }

  Container buildNavigateChapters() {
    return Container(
    //  padding: const EdgeInsets.fromLTRB(10, 64, 10, 128),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              var bookId = widget.book.id;
              int index = 0;
              var nextChapterId = widget.chapter.name;
              for (var c in widget.book.chapters!) {
                print(c.name);
                if (c.name == widget.chapter.name) {
                  nextChapterId = widget.book.chapters![index - 1].name;
                }
                index++;
              }

              var routeName = '/book/$bookId/chapter/$nextChapterId';
              print(nextChapterId);

              Navigator.pushReplacementNamed(
                context,
                routeName,
              );
            },
            child: const Text('Previous Chapter'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              var bookId = widget.book.id;
              int index = 0;
              var nextChapterId = widget.chapter.name;
              for (var c in widget.book.chapters!) {
                print(c.name);
                if (c.name == widget.chapter.name) {
                  nextChapterId = widget.book.chapters![index + 1].name;
                }
                index++;
              }

              var routeName = '/book/$bookId/chapter/$nextChapterId';
              print(nextChapterId);

              Navigator.pushReplacementNamed(
                context,
                routeName,
              );
            },
            child: const Text('Next Chapter'),
          ),
        ],
      ),
    );
  }

  Widget buildQuickJump(Chapter chapter) {
    List<Verse> verses = chapter.verses!.sorted(
      [SortedComparable<Verse, int>((p0) => p0.verseNo)],
    );
    var textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Card(
              color: Theme.of(context).colorScheme.surface,
              child: ExpansionTile(
                title: const Text('Jump to verse'),
                textColor: textColor,
                iconColor: textColor,
                initiallyExpanded: true,
                maintainState: true,
                collapsedTextColor: textColor,
                collapsedIconColor: textColor,
                children: [
                  Wrap(children: verses.map(buildJumpToVerseButton).toList()),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextButton buildJumpToVerseButton(Verse verse) {
    return TextButton(
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () {
        itemScrollController.scrollTo(
          index: verse.verseNo,
          duration: Duration(
            milliseconds: max(100, verse.verseNo * 20),
          ),
        );
      },
      child: Text(verse.verseNo.toString()),
    );
  }

  Widget buildAudioPlayer() {
    return IntrinsicHeight(
      child: Material(
        elevation: 16,
        child: Row(
          children: [
            buildPlayPauseButton(),
            buildSeekbar(),
          ],
        ),
      ),
    );
  }

  Widget buildSeekbar() {
    // return FlutterLogo();
    return Expanded(
      child: StreamBuilder<Duration>(
        stream: player.positionStream,
        builder: (context, snapshot) {
          if (player.duration == null) {
            return Slider.adaptive(
              onChanged: (double value) {},
              value: 0,
            );
          }

          if (widget.currentAudio != widget.chapter.audio) {
            return Slider.adaptive(
              onChanged: (double value) {},
              value: 0,
            );
          }

          return Slider.adaptive(
            value: snapshot.requireData.inSeconds.toDouble(),
            max: player.duration!.inSeconds.toDouble(),
            onChanged: (position) {
              player.seek(Duration(seconds: position.toInt()));
            },
          );
        },
      ),
    );
  }

  StreamBuilder<PlayerState> buildPlayPauseButton() {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        if (!snapshot.requireData.playing ||
            widget.currentAudio != widget.chapter.audio) {
          return IconButton(
            onPressed: playAudio,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.play_arrow),
          );
        }

        return IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          onPressed: player.pause,
          icon: const Icon(Icons.pause),
        );
      },
    );
  }

  void playAudio() {
    if (widget.currentAudio != widget.chapter.audio) {
      player.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.chapter.audio!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: widget.chapter.id.toString(),
            // Metadata to display in the notification:
            album: widget.book.name,
            title: widget.chapter.name,
          ),
        ),
      );

      widget.onAudioChanged(widget.chapter.audio);
    }

    player.play();
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
      //title: Text("${bookLocal?.name}: ${widget.chapter.name}", style: textStyle),
      onQueryChanged: (q) => setState(() => query = q),
      onSubmitted: (q) => setState(() => query = q),
      debounceDelay: const Duration(milliseconds: 500),
      onFocusChanged: (hasFocus) => setState(() => showSearchView = hasFocus),
      title: Container(
        width: 200,
        child: Marquee(
          text: "${widget.book.name.titleCase}: ${widget.chapter.name}",
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
        ),
      ),

      actions: [
        FloatingSearchBarAction.searchToClear(
          color: theme.primaryIconTheme.color,
        ),
        ShareChapterButton(
          chapter: chapter!,
          bookName: widget.book.name.titleCase,
        ),
        if (!showSearchView) ...HomePageState().buildAppBarActions(),
      ],
      body: Container(),
    );
  }

  static List<Widget> buildAppBarActions() {
    return [
      StoreConnector<AppState, AppVM>(
        converter: (store) => AppVM()..init(store),
        builder: (context, vm) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
  // Widget buildBody() {
  //   return IndexedStack(
  //     index: showSearchView ? 0 : 1,
  //     children: [
  //       SearchView(
  //         key: Key(query.toString()),
  //         query: query,
  //       ),
  //       [
  //         StaticPage(url: 'preface'),
  //         StaticPage(url: 'presentation'),
  //         BookMarkPage(),
  //         StaticPage(url: 'introduction'),
  //         StaticPage(url: 'collaborator'),
  //         TestamentPage(),
  //         LexiconPage(),
  //         StaticPage(url: 'contact-us'),
  //         StaticPage(url: 'copyright'),
  //       ][page],
  //     ],
  //   );
  // }
}

typedef void CallBackBookmark(bool value);

class VerseRow extends StatelessWidget {
  final Verselocal verse;
  final bool search;
  final bool bookMark;
  final CallBackBookmark callBackBookmark;
  const VerseRow(
      {Key? key,
      required this.verse,
      required this.callBackBookmark,
      required this.bookMark,
      required this.search})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 36,
                width: 36,
                child: Text("${verse.verseNo}. "),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                      text: Bidi.stripHtmlIfNeeded(
                        verse.verse,
                      ).trim(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(height: 1.8),
                      children: []),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShareVerseButton(verse: verse),
              if (verse.commentaries!.isNotEmpty)
                CommentaryButton(
                  commentary: verse.commentaries![0],
                ),

              ///footnotebutton multiple
              // ...verse.footnotes?.map(
              //       (footnote) => WidgetSpan(
              //         child: FootnoteButton(
              //           footnote: footnote,
              //           verse: verse,
              //         ),
              //       ),
              //     ) ??
              //     List.empty(),
              /// footnotebutton single
              if (verse.footnotes!.isNotEmpty)
                FootnoteButton(
                  footnote: verse.footnotes!.last,
                  verse: verse,
                ),

              ///footnotebutton
              // ...?verse.footnotes!.isNotEmpty
              //     ? [
              //         WidgetSpan(
              //           child: FootnoteButton(
              //             footnote: verse.footnotes![0],
              //             verse: verse,
              //           ),
              //         ),
              //       ]
              //     : [],
              Container(
                margin: const EdgeInsets.all(2),
                child: NcbButtonSmall(
                  onTap: () async {
                    callBackBookmark(!bookMark);
                  },
                  child: bookMark
                      ? const Icon(
                          Icons.bookmark,
                          size: 22,
                        )
                      : const Icon(
                          Icons.bookmark_outline_rounded,
                          size: 22,
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
