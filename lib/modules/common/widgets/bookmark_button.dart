import 'package:flutter/material.dart';

import 'ncb_button_small.dart';

class BookMarkButton extends StatefulWidget {
  const BookMarkButton({Key? key}) : super(key: key);

  @override
  State<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
  @override
  Widget build(BuildContext context) {
    return NcbButtonSmall(
      onTap: () {},
      child: const Icon(Icons.bookmark_outline_rounded),
    );
  }
}
