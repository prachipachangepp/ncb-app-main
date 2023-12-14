import 'dart:io' as io;

import 'package:ncb/db_bookmark/bookmark_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, '');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE OurData('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'order INTEGER,'
        'chapterId INTEGER,'
        'verseNo INTEGER,'
        'verse Text'
        ')');
  }

  Future<BookmarkModel> insert(BookmarkModel bookmarkmodel) async {
    var dbClient = await db;
    await dbClient!.insert('OurData', bookmarkmodel.toMap());
    return bookmarkmodel;
  }
}

// import 'dart:io';
//
//
// import 'package:path/path.dart';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DBProvider {
//   static Database _database;
//   static final DBProvider db = DBProvider._();
//
//   DBProvider._();
//
//   Future<Database> get database async {
//     if (_database != null) _database = await initDB();
//
//     return _database;
//   }
//
//   initDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     final path = join(documentsDirectory.path, 'ProductData.db');
//
//     return await openDatabase(path, version: 1, onOpen: (db) {},
//         onCreate: (Database db, int version) async {
//           await db.execute('CREATE TABLE ProductData('
//               'id INTEGER PRIMARY KEY,' //id
//               'categoryName Text,' //headline
//               'publisherName Text,'  //description
//               'isAvailable Text,'      //content
//               'categoryImgUrl Text'  //image
//               ')');
//         });
//   }
//
//   createProductData(ProductData productData) async {
//     await deleteAllProductData();
//     final db = await database;
//     final res = await db.insert('ProductData', productData.toJson());
//
//     return res;
//   }
//
//   Future<int> deleteAllProductData() async {
//     final db = await database;
//     final res = await db.delete('DELETE FROM ProductData');
//
//     return res;
//   }
//
//   Future<List<ProductData>> getProductDataList() async {
//     final db = await database;
//     final res = await db.rawQuery("SELECT * FROM ProductData");
//
//     List<ProductData> list = res.isNotEmpty ? res.map((x) => ProductData.fromJson(x)).toList() : [];
//
//     return list;
//   }
// }
