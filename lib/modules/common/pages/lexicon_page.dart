import 'package:flrx/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ncb/modules/common/models/lexicon.dart';
import 'package:ncb/modules/common/service/testament_service.dart';
import 'package:sorted/sorted.dart';

class LexiconPage extends StatelessWidget {
  const LexiconPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lexicon>>(
      future: getContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var lexiconList = snapshot.requireData.sorted(
          [SortedComparable<Lexicon, String>((lexicon) => lexicon.title)],
        );

        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: snapshot.requireData.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const Text('PERSONS IN THE BIBLE');
            }

            var lexicon = lexiconList[index - 1];

            return Card(
              child: ListTile(
                minVerticalPadding: 24,
                isThreeLine: true,
                title: Text("${lexicon.title}\n"),
                subtitle: HtmlWidget(lexicon.description),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
        );
      },
    );
  }

  Future<List<Lexicon>> getContent() async =>
      (await Application.get<TestamentService>().getLexicon()).data;
}
