// import 'package:flutter/material.dart';
//
// class BookmarkPage extends StatelessWidget {
//   const BookmarkPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getData(),
//         // future: getContent(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.active ||
//               snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return ListView.builder(
//             itemCount: 2,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                   leading: const Icon(Icons.bookmark),
//                   trailing: const Text(
//                     "Selected items",
//                     style: TextStyle(color: Colors.green, fontSize: 15),
//                   ),
//                   title: Text(" $index"));
//             },
//           );
//         });
//   }
// }
//
// Future<String> getData() {
//   return Future.delayed(Duration(seconds: 2), () {
//     return "Bookmark";
//     // throw Exception("Custom Error");
//   });
// }
