import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/widgets/commentary_button.dart';
import 'package:ncb/modules/common/widgets/ncb_button_small.dart';
import 'package:ncb/modules/common/widgets/share_verse_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../verselocal.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BookMarkPage> createState() => BookMarkPageState();
}

class BookMarkPageState extends State<BookMarkPage> {
  AudioPlayer get player => Application.get<AudioPlayer>();
  final ItemScrollController itemScrollController = ItemScrollController();
  List<Verselocal> verses = [];
  Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');
  @override
  void initState() {
    verses = bookmarkBox.values.toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: verses.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Container(
              color: index % 2 == 0
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[300]
                  : null,
              padding: const EdgeInsets.all(16),
              child: BookmarkRow(
                verse: verses[index],
                id: index + 1,
                unbook: (bool val) {
                  setState(() {
                    bookmarkBox.deleteAt(index);
                    verses = bookmarkBox.values.toList();
                  });
                },
              ),
            );

            return const SizedBox();
          },
        ),
      ),
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
      WidgetSpan(
        child: Container(
          margin: const EdgeInsets.all(4),
          child: NcbButtonSmall(
            onTap: () async {
              Box<Verselocal> bookmarkBox = Hive.box<Verselocal>('bookmarks');
              List<Verselocal> v = bookmarkBox.values
                  .where((element) => element.id == verse.id)
                  .toList();

              if (v.isNotEmpty) {
                v.forEach((element) {
                  print(element.verse);
                });
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
            child: const Icon(Icons.bookmark_outline_rounded),
          ),
        ),
      ),
    ];
  }
}

typedef void Unbook(bool val);

class BookmarkRow extends StatefulWidget {
  BookmarkRow(
      {Key? key, required this.verse, required this.id, required this.unbook})
      : super(key: key);
  final Verselocal verse;
  final int id;
  final Unbook unbook;
  @override
  State<BookmarkRow> createState() => _BookmarkRowState();
}

class _BookmarkRowState extends State<BookmarkRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: 36,
              width: 36,
              child: Text("${widget.id}. "),
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text.rich(
                    TextSpan(
                      text: Bidi.stripHtmlIfNeeded(
                        widget.verse.verse,
                      ).trim(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(height: 1.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // IconButton(onPressed: () {}, icon: Icon(Icons.share)),
            IconButton(
                onPressed: () {
                  widget.unbook(true);
                },
                icon: Icon(Icons.bookmark_remove)),
          ],
        ),
      ],
    );
  }
}
