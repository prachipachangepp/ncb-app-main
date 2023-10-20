import 'package:data_fixture_dart/factories/fixture_factory.dart';
import 'package:flrx/flrx.dart';
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/modules/common/models/testament.factory.dart';

class FakeTestamentRepository extends Repository<Testament>
    with FakeRepository<Testament> {
  @override
  FixtureFactory<Testament> get fixtureFactory => TestamentFixtureFactory();
}
