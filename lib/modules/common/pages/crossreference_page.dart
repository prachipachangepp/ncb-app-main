import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive/hive.dart';
import 'package:ncb/chapter_local.dart';
import 'package:ncb/footnoteslocal.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/verselocal.dart';

import '../../../book_local.dart';

class FootnotePage extends StatelessWidget {
  final FootnotesLocal footnote;
  Box<Verselocal> verseBox = Hive.box<Verselocal>('verseBox');
  Box<ChapterLocal> chapterBox = Hive.box<ChapterLocal>('chaptersBox');
  Box<BookLocal> booksBox = Hive.box<BookLocal>('booksBox');

  final Verselocal verse;

  FootnotePage({
    Key? key,
    required this.footnote,
    required this.verse,
  }) : super(key: key);

  Future<List<Verse>> getAllForRelationById(int id) async {
    List<Verse> local = [];
    await Future.delayed(Duration(seconds: 1));
    for (var a in verseBox.values) {
      for (var foot in a.footnotes!) {
        if (foot.id == id) {
          ChapterLocal c = chapterBox.values
              .where((chapter) => chapter.id == a.chapterId)
              .toList()
              .first;
          local.add(Verse(
              id: a.id,
              verseNo: a.verseNo,
              verse: a.verse,
              order: a.order,
              chapter: Chapter(
                  id: c.id,
                  audio: c.audio,
                  displayPosition: c.displayPosition,
                  bookId: c.bookId,
                  name: c.name),
              chapterId: a.chapterId!));
        }
      }
    }
    return local;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross References'),
      ),
      body: FutureBuilder<List<Verse>>(
        future: getAllForRelationById(footnote.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Verse> verses = sortVerses(snapshot);
          print("Verse");
          print(verses);
          return buildBody(verses);
        },
      ),
    );
  }

  List<Verse> sortVerses(AsyncSnapshot<List<Verse>> snapshot) {
    var verses = snapshot.requireData;
    verses.sort((va, vb) {
      if (va.id == verse.id) {
        return -1000;
      }

      if (vb.id == verse.id) {
        return 1000;
      }

      return 0;
    });

    return verses;
  }

  ListView buildBody(List<Verse> verses) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemBuilder: (BuildContext context, int index) {
        var verse = verses[index];
        String bookName = '';
        for (var a in booksBox.values) {
          if (a.id == verse.chapter!.bookId) {
            bookName = a.name;
          }
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${bookName} ${verse.chapter!.displayPosition}:${verse.verseNo}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                HtmlWidget(
                  verse.verse,
                  textStyle: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: verses.length,
    );
  }
}
