import 'package:flutter/material.dart';

import 'ncb_button_small.dart';

class BookMarkButton extends StatefulWidget {
  const BookMarkButton({Key? key}) : super(key: key);

  @override
  State<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
//  bool isBookmarked = false;
  late ValueNotifier<bool> isBookmarkedNotifier;

  @override
  void initState() {
    super.initState();
    isBookmarkedNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return NcbButtonSmall(
      onTap: () {
        isBookmarkedNotifier.value = !isBookmarkedNotifier.value;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isBookmarkedNotifier,
        builder: (context, isBookmarked, child) {
          return isBookmarked
              ? const Icon(
                  Icons.bookmark_outline_rounded,
                  color: Colors.red, // Filled with red color when bookmarked
                )
              : const Icon(
                  Icons.bookmark_rounded,
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    isBookmarkedNotifier.dispose();
    super.dispose();
  }
}
