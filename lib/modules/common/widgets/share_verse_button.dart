import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncb/modules/common/widgets/ncb_button_small.dart';
import 'package:ncb/verselocal.dart';
import 'package:recase/recase.dart';
import 'package:share_plus/share_plus.dart';

class ShareVerseButton extends StatelessWidget {
  final Verselocal verse;

  const ShareVerseButton({Key? key, required this.verse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: NcbButtonSmall(
        onTap: shareVerse,
        child: const Icon(
          Icons.share,
          size: 20,
        ),
      ),
    );
  }

  void shareVerse() {
    var verseText = Bidi.stripHtmlIfNeeded(verse.verse);
    var chapter = verse.chapter;
    var book = chapter!.book;
    var title = book != null && chapter != null
        ? "${book.name.titleCase}\n${chapter.name} : ${verse.verseNo}\n"
        : "";
    Share.share(title + verseText);
  }
}
