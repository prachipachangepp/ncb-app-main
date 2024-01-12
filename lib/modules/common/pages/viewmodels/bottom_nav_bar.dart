import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../bookmark.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[500],
      currentIndex: currentIndex,
      onTap: onTap,
      items:  [
        BottomNavigationBarItem(
          icon:
              Icon(Icons.book),
          label: 'NCB',
        ),
        BottomNavigationBarItem(
          icon:
          InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> BookMarkPage()));
                  },
                    child:Icon(Icons.bookmark),
     ),
          label: 'Bookmark',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                shareApp();
                Navigator.pop(context);
              },
              child: Icon(Icons.share)),
          label: 'Share',
        ),
      ],
    );
  }
}

Future<void> shareApp() async {
  if (kIsWeb) {
    return Share.share(Uri.base.toString());
  }

  if (Platform.isAndroid) {
    return Share.share(
      "https://play.google.com/store/apps/details?id=in.wi.ncb&hl=en_IN&gl=US",
    );
  }

  if (Platform.isIOS) {
    return Share.share(
      "https://apps.apple.com/in/app/new-community-bible/id1439308209",
    );
  }
}