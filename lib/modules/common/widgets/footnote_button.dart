import 'package:flutter/material.dart';
import 'package:ncb/modules/common/models/footnote.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/pages/crossreference_page.dart';
import 'package:ncb/modules/common/widgets/ncb_button_small.dart';

class FootnoteButton extends StatelessWidget {
  final Footnote footnote;
  final Verse verse;

  const FootnoteButton({Key? key, required this.footnote, required this.verse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: NcbButtonSmall(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FootnotePage(footnote: footnote, verse: verse);
              },
            ),
          );
        },
        child: const Icon(Icons.compare_arrows),
      ),
    );
  }
}
