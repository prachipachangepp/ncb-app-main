import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../lexicon_local.dart';

class LexiconPage extends StatelessWidget {
  LexiconPage({Key? key}) : super(key: key);
  Box<LexiconLocal> lexiconBox = Hive.box<LexiconLocal>('lexiconBox');

  List<LexiconLocal> local = [];

  @override
  Widget build(BuildContext context) {
    local = [];
    lexiconBox.values.forEach((element) {
      local.add(element);
    });
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: lexiconBox.values.toList().length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const Text('PERSONS IN THE BIBLE');
        }
        var lexicon = local[index - 1];

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
  }
}
