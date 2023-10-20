import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/banner.dart';
import 'package:ncb/modules/common/models/book.dart';
import 'package:ncb/modules/common/models/chapter.dart';
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/modules/common/models/verse.dart';
import 'package:ncb/modules/common/repositories/chapter_repository.dart';
import 'package:ncb/modules/common/repositories/testament_repository.dart';
import 'package:ncb/modules/common/repositories/verse_repository.dart';
import 'package:ncb/modules/common/service/testament_service.dart';
import 'package:ncb/store/actions/use_case.dart';

class FetchTestamentsAction
    extends UseCase<FetchTestamentsAction, List<Testament>> {
  @override
  Future<List<Testament>> call() => TestamentRepository.instance.getAll();
}

class FetchBannersAction extends UseCase<FetchBannersAction, Banner> {
  @override
  Future<Banner> call() async {
    var response = await Application.get<TestamentService>().getBanners();

    return response.data;
  }
}

class FetchChaptersAction extends UseCase<FetchChaptersAction, List<Chapter>> {
  final int bookId;

  FetchChaptersAction(this.bookId);

  @override
  Future<List<Chapter>> call() =>
      ChapterRepository.instance.getAllForRelationById<Book>(bookId);
}

class FetchVersesAction extends UseCase<FetchVersesAction, List<Verse>> {
  final int chapterId;

  FetchVersesAction(this.chapterId);

  @override
  Future<List<Verse>> call() =>
      VerseRepository.instance.getAllForRelationById<Chapter>(chapterId);
}

class ToggleDarkMode {}

class IncreaseTextSizeAction {}

class DecreaseTextSizeAction {}
