class BookmarkModel {
  final int id;
  final int order;
  final int? chapterId;
  final int verseNo;
  final String verse;
  BookmarkModel(this.verseNo, this.verse,
      {required this.id, required this.order, required this.chapterId});

  BookmarkModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        order = res['order'],
        chapterId = res['chapterId'],
        verseNo = res['verseNo'],
        verse = res['verse'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'order': order,
      'chapterId': chapterId,
      'verseNo': verseNo,
      'verse': verse
    };
  }
}
