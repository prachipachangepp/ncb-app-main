import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ncb/modules/common/models/footnote.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/repositories/verse_repository.dart';
import 'package:recase/recase.dart';

class FootnotePage extends StatelessWidget {
  final Footnote footnote;

  final Verse verse;

  const FootnotePage({
    Key? key,
    required this.footnote,
    required this.verse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross References'),
      ),
      body: FutureBuilder<List<Verse>>(
        future: VerseRepository.instance
            .getAllForRelationById<Footnote>(footnote.id),
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

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${verse.chapter!.book!.name.titleCase} ${verse.chapter!.displayPosition}:${verse.verseNo}",
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
