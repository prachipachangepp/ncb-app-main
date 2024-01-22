import 'dart:math';

import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/pages/home_page.dart';
import 'package:ncb/modules/common/widgets/commentary_button.dart';
import 'package:ncb/modules/common/widgets/footnote_button.dart';
import 'package:ncb/modules/common/widgets/ncb_button_small.dart';
import 'package:ncb/modules/common/widgets/share_chapter_button.dart';
import 'package:ncb/modules/common/widgets/share_verse_button.dart';
import 'package:recase/recase.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sorted/sorted.dart';

import '../../../verselocal.dart';

class ChapterContent extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  final String? currentAudio;
  final ValueSetter<String?> onAudioChanged;

  const ChapterContent({
    Key? key,
    required this.chapter,
    required this.book,
    this.currentAudio,
    required this.onAudioChanged,
  }) : super(key: key);

  @override
  State<ChapterContent> createState() => ChapterContentState();
}

class ChapterContentState extends State<ChapterContent> {
  AudioPlayer get player => Application.get<AudioPlayer>();
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    print(widget.chapter.verses!.length);
    var verses = widget.chapter.verses!
        .sorted([SortedComparable<Verse, int>((v) => v.verseNo)]);
    var hasAudio = widget.chapter.audio?.isNotEmpty == true;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.book.name.titleCase}: ${widget.chapter.name}"),
        actions: HomePageState.buildAppBarActions()
          ..insert(
            0,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ShareChapterButton(
                chapter: widget.chapter,
                bookName: widget.book.name.titleCase,
              ),
            ),
          ),
      ),
      bottomNavigationBar: hasAudio ? buildAudioPlayer() : null,
      body: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemCount: verses.length + 2,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildQuickJump(widget.chapter);
          }

          if (index == verses.length + 1) {
            return buildNavigateChapters();
          }

          if (index < verses.length + 1) {
            var chapter = widget.chapter.copyWith(book: widget.book);
            var verse = verses[index - 1].copyWith(chapter: chapter);

            return Container(
              color: index % 2 == 0
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[300]
                  : null,
              padding: const EdgeInsets.all(16),
              child: buildVerseRow(verse, context),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  static Row buildVerseRow(Verse verse, BuildContext context) {
    return Row(
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
          child: Wrap(
            children: [
              Text.rich(
                TextSpan(
                  text: Bidi.stripHtmlIfNeeded(
                    verse.verse,
                  ).trim(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(height: 1.8),
                  children: buttonsForVerse(verse, context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static List<InlineSpan> buttonsForVerse(Verse verse, BuildContext context) {
    return [
      WidgetSpan(child: ShareVerseButton(verse: verse)),
      if (verse.commentaries!.isNotEmpty)
        WidgetSpan(
          child: CommentaryButton(
            commentary: verse.commentaries![0],
          ),
        ),
      ...verse.footnotes?.map(
            (footnote) => WidgetSpan(
              child: FootnoteButton(
                footnote: footnote,
                verse: verse,
              ),
            ),
          ) ??
          List.empty(),
      WidgetSpan(
        child: Container(
          margin: const EdgeInsets.all(5),
          child: NcbButtonSmall(
            onTap: () async {
              Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');
              List<Verselocal> v = bookmarkBox.values
                  .where((element) => element.id == verse.id)
                  .toList();

              if (v.isNotEmpty) {
                //await bookmarkBox.delete(verse.id);
                print(bookmarkBox.length);
              } else {
                bookmarkBox.add(Verselocal(
                    verseNo: verse.verseNo,
                    verse: verse.verse,
                    order: verse.order,
                    id: verse.id));
                print(bookmarkBox.length);
                print("added");
              }
            },
            child: const Icon(
              Icons.bookmark_outline_rounded,
              size: 20,
            ),
          ),
        ),
      ),
    ];
  }

  Container buildNavigateChapters() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 128),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              var bookId = widget.book.id;
              var nextChapterId = widget.chapter.id - 1;

              var routeName = '/book/$bookId/chapter/$nextChapterId';

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
              var nextChapterId = widget.chapter.id + 1;

              var routeName = '/book/$bookId/chapter/$nextChapterId';

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
                title: const Text('Jump to verse '),
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
}
