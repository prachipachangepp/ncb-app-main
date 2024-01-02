import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ncb/commentary_local.dart';

class CommentaryPage extends StatelessWidget {
  final CommentaryLocal commentary;

  const CommentaryPage({Key? key, required this.commentary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(commentary.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: HtmlWidget(commentary.content),
      ),
    );
  }
}
