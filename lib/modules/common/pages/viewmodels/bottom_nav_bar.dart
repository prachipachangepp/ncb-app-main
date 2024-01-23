import 'package:flutter/material.dart';
import 'package:ncb/modules/common/pages/testament_page.dart';
import 'package:share_plus/share_plus.dart';

import '../bookmark.dart';

class CustomNavBar extends StatelessWidget {
  int currenTIndex = 0;

  List<Widget> screens = [
    // HomeScreen(),
    // BookmarkScreen(),
    // ShareScreen(),
    TestamentPage(),
    BookMarkPage(),
    // _shareContent('share your app');
    // shareApp,
  ];
  // CustomNavBar({required this.currenTIndex, required this.screens});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[500],
      currentIndex: currenTIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: InkWell(
            child: Icon(Icons.home),
            onTap: () {
              _onItemTapped(0);
            },
          ),
          label: 'NCB',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            child: Icon(Icons.bookmark),
            onTap: () {
              _onItemTapped(1);
            },
          ),
          label: 'Bookmark',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            child: Icon(Icons.share),
            onTap: () {
              _shareContent('share your app');
            },
          ),
          label: 'Share',
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    // setState(() {
    currenTIndex = index;
    // });
  }

  void _shareContent(String content) {
    Share.share(content, subject: 'Sharing');
  }
}

// class CustomBottomNavigationBar extends StatefulWidget {
//   // final int currentIndex;
//   // final Function(int) onTap;
//
//   // CustomBottomNavigationBar({required this.currentIndex, required this.onTap});
//
//   @override
//   State<CustomBottomNavigationBar> createState() =>
//       _CustomBottomNavigationBarState();
// }
//
// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   // int _selectedIndex = 0;
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     // HomeScreen(),
//     // BookmarkScreen(),
//     // ShareScreen(),
//     TestamentPage(),
//     BookMarkPage(),
//     // shareApp,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return
//         //   Row(
//         //   children: [
//         //     Column(
//         //       children: [
//         //         Expanded(
//         //           child: _screens[_currentIndex],
//         //         ),
//         //         BottomNavigationBar(
//         //           currentIndex: _currentIndex,
//         //           onTap: _onItemTapped,
//         //           items: [
//         //             BottomNavigationBarItem(
//         //               icon: InkWell(
//         //                 child: Icon(Icons.home),
//         //                 onTap: () {
//         //                   _onItemTapped(0);
//         //                 },
//         //               ),
//         //               label: 'Home',
//         //             ),
//         //             BottomNavigationBarItem(
//         //               icon: InkWell(
//         //                 child: Icon(Icons.bookmark),
//         //                 onTap: () {
//         //                   _onItemTapped(1);
//         //                 },
//         //               ),
//         //               label: 'Bookmark',
//         //             ),
//         //             BottomNavigationBarItem(
//         //               icon: InkWell(
//         //                 child: Icon(Icons.share),
//         //                 onTap: () {
//         //                   _shareContent('Hello, this is the content to share!');
//         //                 },
//         //               ),
//         //               label: 'Share',
//         //             ),
//         //           ],
//         //         ),
//         //       ],
//         //     ),
//         //   ],
//         // );
//         BottomNavigationBar(
//       backgroundColor: Colors.grey[500],
//       currentIndex: _currentIndex,
//       onTap: _onItemTapped,
//       items: [
//         BottomNavigationBarItem(
//           icon: InkWell(
//             child: Icon(Icons.home),
//             onTap: () {
//               _onItemTapped(0);
//             },
//           ),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: InkWell(
//             child: Icon(Icons.bookmark),
//             onTap: () {
//               _onItemTapped(1);
//             },
//           ),
//           label: 'Bookmark',
//         ),
//         BottomNavigationBarItem(
//           icon: InkWell(
//             child: Icon(Icons.share),
//             onTap: () {
//               _shareContent('Hello, this is the content to share!');
//             },
//           ),
//           label: 'Share',
//         ),
//       ],
//     );
//     //   BottomNavigationBar(
//     //   backgroundColor: Colors.grey[500],
//     //   currentIndex: widget.currentIndex,
//     //   onTap: widget.onTap,
//     //   items: [
//     //     BottomNavigationBarItem(
//     //       icon: InkWell(
//     //         onTap: () {
//     //           Navigator.of(context).push(
//     //               MaterialPageRoute(builder: (context) => TestamentPage()));
//     //         },
//     //         child: Icon(Icons.book),
//     //       ),
//     //       label: 'NCB',
//     //     ),
//     //     BottomNavigationBarItem(
//     //       icon: InkWell(
//     //         onTap: () {
//     //           Navigator.of(context).push(
//     //               MaterialPageRoute(builder: (context) => BookMarkPage()));
//     //         },
//     //         child: Icon(Icons.bookmark),
//     //       ),
//     //       label: 'Bookmark',
//     //     ),
//     //     BottomNavigationBarItem(
//     //       icon: GestureDetector(
//     //           onTap: () {
//     //             shareApp();
//     //             Navigator.pop(context);
//     //           },
//     //           child: Icon(Icons.share)),
//     //       label: 'Share',
//     //     ),
//     //   ],
//     // );
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   void _shareContent(String content) {
//     Share.share(content, subject: 'Sharing Example');
//   }
// }
//
// Future<void> shareApp() async {
//   if (kIsWeb) {
//     return Share.share(Uri.base.toString());
//   }
//
//   if (Platform.isAndroid) {
//     return Share.share(
//       "https://play.google.com/store/apps/details?id=in.wi.ncb&hl=en_IN&gl=US",
//     );
//   }
//
//   if (Platform.isIOS) {
//     return Share.share(
//       "https://apps.apple.com/in/app/new-community-bible/id1439308209",
//     );
//   }
// }
///
//
//
// // int _selectedIndex = 0;
// int _currentIndex = 0;
//
// final List<Widget> _screens = [
//   // HomeScreen(),
//   // BookmarkScreen(),
//   // ShareScreen(),
//   TestamentPage(),
//   BookMarkPage(),
//   // shareApp,
// ];
// @override
// Widget build(BuildContext context) {
//   return
//     //   Row(
//     //   children: [
//     //     Column(
//     //       children: [
//     //         Expanded(
//     //           child: _screens[_currentIndex],
//     //         ),
//     //         BottomNavigationBar(
//     //           currentIndex: _currentIndex,
//     //           onTap: _onItemTapped,
//     //           items: [
//     //             BottomNavigationBarItem(
//     //               icon: InkWell(
//     //                 child: Icon(Icons.home),
//     //                 onTap: () {
//     //                   _onItemTapped(0);
//     //                 },
//     //               ),
//     //               label: 'Home',
//     //             ),
//     //             BottomNavigationBarItem(
//     //               icon: InkWell(
//     //                 child: Icon(Icons.bookmark),
//     //                 onTap: () {
//     //                   _onItemTapped(1);
//     //                 },
//     //               ),
//     //               label: 'Bookmark',
//     //             ),
//     //             BottomNavigationBarItem(
//     //               icon: InkWell(
//     //                 child: Icon(Icons.share),
//     //                 onTap: () {
//     //                   _shareContent('Hello, this is the content to share!');
//     //                 },
//     //               ),
//     //               label: 'Share',
//     //             ),
//     //           ],
//     //         ),
//     //       ],
//     //     ),
//     //   ],
//     // );
//     BottomNavigationBar(
//       backgroundColor: Colors.grey[500],
//       currentIndex: _currentIndex,
//       onTap: _onItemTapped,
//       items: [
//         BottomNavigationBarItem(
//           icon: InkWell(
//             child: Icon(Icons.home),
//             onTap: () {
//               _onItemTapped(0);
//             },
//           ),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: InkWell(
//             child: Icon(Icons.bookmark),
//             onTap: () {
//               _onItemTapped(1);
//             },
//           ),
//           label: 'Bookmark',
//         ),
//         BottomNavigationBarItem(
//           icon: InkWell(
//             child: Icon(Icons.share),
//             onTap: () {
//               _shareContent('Hello, this is the content to share!');
//             },
//           ),
//           label: 'Share',
//         ),
//       ],
//     );
///
//   //   BottomNavigationBar(
//   //   backgroundColor: Colors.grey[500],
//   //   currentIndex: widget.currentIndex,
//   //   onTap: widget.onTap,
//   //   items: [
//   //     BottomNavigationBarItem(
//   //       icon: InkWell(
//   //         onTap: () {
//   //           Navigator.of(context).push(
//   //               MaterialPageRoute(builder: (context) => TestamentPage()));
//   //         },
//   //         child: Icon(Icons.book),
//   //       ),
//   //       label: 'NCB',
//   //     ),
//   //     BottomNavigationBarItem(
//   //       icon: InkWell(
//   //         onTap: () {
//   //           Navigator.of(context).push(
//   //               MaterialPageRoute(builder: (context) => BookMarkPage()));
//   //         },
//   //         child: Icon(Icons.bookmark),
//   //       ),
//   //       label: 'Bookmark',
//   //     ),
//   //     BottomNavigationBarItem(
//   //       icon: GestureDetector(
//   //           onTap: () {
//   //             shareApp();
//   //             Navigator.pop(context);
//   //           },
//   //           child: Icon(Icons.share)),
//   //       label: 'Share',
//   //     ),
//   //   ],
//   // );
// }
//
// void _onItemTapped(int index) {
//   setState(() {
//     _currentIndex = index;
//   });
// }
//
// void _shareContent(String content) {
//   Share.share(content, subject: 'Sharing Example');
// }
// }
