import 'package:flutter/material.dart';
import 'package:ncb/modules/common/models/commentary.dart';
import 'package:ncb/modules/common/pages/commentary_page.dart';
import 'package:ncb/modules/common/widgets/ncb_button_small.dart';

class CommentaryButton extends StatelessWidget {
  final Commentary commentary;

  const CommentaryButton({Key? key, required this.commentary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: NcbButtonSmall(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CommentaryPage(commentary: commentary);
            }),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
