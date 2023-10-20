import 'package:flrx/flrx.dart';
import 'package:flutter/widgets.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/commentary.dart';
import 'package:ncb/modules/common/models/footnote.dart';
import 'package:ncb/modules/common/models/lexicon.dart';
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/modules/common/models/verse.dart';

mixin TypeToPathMapper<T extends DataModel> on NetworkRepository<T> {
  static const Map<Type, String> map = {
    Banner: "banners",
    Book: "books",
    Chapter: "chapters",
    Commentary: "commentaries",
    Footnote: "footnotes",
    Lexicon: "lexicons",
    Testament: "testaments",
    Verse: "verses",
  };

  @override
  String entityUrlPathForType(Type type) {
    return map[type]!;
  }
}
