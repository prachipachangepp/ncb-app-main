import 'package:flutter/material.dart';
import 'package:laravel_orion/laravel_orion.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/pages/chapter_content.dart';
import 'package:ncb/modules/common/repositories/verse_repository.dart';
import 'package:recase/recase.dart';

class SearchView extends StatefulWidget {
  final String query;

  const SearchView({Key? key, this.query = ""}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  Future<List<Verse>>? results;

  _SearchViewState();

  @override
  void initState() {
    super.initState();

    if (widget.query.isNotEmpty) {
      results = search(OrionSearchQueryBuilder()..withKeyword(widget.query));
    }
  }

  static Future<List<Verse>> search(OrionSearchQueryBuilder builder) =>
      VerseRepository.instance.search(builder.build());

  @override
  Widget build(BuildContext context) {
    if (widget.query.isEmpty) {
      return const Center(child: Text('Start typing to search...'));
    }

    return FutureBuilder<List<Verse>>(
      future: results,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Verse>> snapshot,
      ) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.requireData.isEmpty) {
          return const Center(child: Text('Nothing found'));
        }

        var verseList = snapshot.requireData;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: verseList.length + 1,
          itemBuilder: (context, position) {
            if (position == 0) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Search Results',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }

            var verse = verseList[position - 1];
            var chapter = verse.chapter;
            var book = chapter?.book;

            return InkWell(
              onTap: chapter == null
                  ? null
                  : () => Navigator.pushNamed(
                        context,
                        '/book/${book!.id}/chapter/${chapter.id}',
                      ),
              child: Container(
                color: position % 2 == 0
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[300]
                    : null,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (book != null && chapter != null)
                      Text(
                        "${book.name.titleCase} ${chapter.displayPosition}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ChapterContentState.buildVerseRow(verse, context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
