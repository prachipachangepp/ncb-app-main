import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/widgets/ncb_button_small.dart';
import 'package:share_plus/share_plus.dart';

class ShareChapterButton extends StatelessWidget {
  final Chapter chapter;
  final String bookName;

  const ShareChapterButton(
      {Key? key, required this.chapter, required this.bookName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: NcbButtonSmall(
        onTap: shareChapter,
        child: const Icon(Icons.share, size: 19),
      ),
    );
  }

  void shareChapter() {
    String versesText = "$bookName, ${chapter.name}\n";
    for (var a in chapter.verses!) {
      var verseText = Bidi.stripHtmlIfNeeded(a.verse);
      versesText =
          "$versesText\n${chapter.name} : ${a.verseNo}\n${verseText}\n\n";
    }
    Share.share(versesText);
  }
}
