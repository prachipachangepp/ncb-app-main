import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../static_content_local.dart';

class StaticPage extends StatelessWidget {
  final String url;

  StaticPage({Key? key, required this.url}) : super(key: key);
  Box<StaticContentLocal> staticContentBox =
      Hive.box<StaticContentLocal>('staticContentBox');
  late StaticContentLocal staticContentLocal;

  @override
  Widget build(BuildContext context) {
    print(staticContentBox.values);
    staticContentLocal = staticContentBox.get(url)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: HtmlWidget(staticContentLocal.content),
    );
  }

  // Future<StaticContent> getContent() async =>
  //     (await Application.get<TestamentService>().getContent(url)).data;
}
