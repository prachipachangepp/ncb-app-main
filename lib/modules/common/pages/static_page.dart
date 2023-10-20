import 'package:flrx/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ncb/modules/common/models/static_content.dart';
import 'package:ncb/modules/common/service/testament_service.dart';

class StaticPage extends StatelessWidget {
  final String url;

  const StaticPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StaticContent>(
      future: getContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: HtmlWidget(snapshot.requireData.content),
        );
      },
    );
  }

  Future<StaticContent> getContent() async =>
      (await Application.get<TestamentService>().getContent(url)).data;
}
