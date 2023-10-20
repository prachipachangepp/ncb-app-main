import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/testament.dart';

abstract class TestamentRepository extends Repository<Testament> {
  static TestamentRepository get instance =>
      Application.get<TestamentRepository>();
}
