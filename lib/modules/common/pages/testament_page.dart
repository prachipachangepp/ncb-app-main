import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart' hide Page, Banner;
import 'package:ncb/modules/common/models/testament.dart';
import 'package:ncb/modules/common/pages/viewmodels/post_page_vm.dart';
import 'package:ncb/modules/common/widgets/banner_widget.dart';
import 'package:ncb/modules/common/widgets/testament_grid.dart';
import 'package:ncb/store/states/app_state.dart';

class TestamentPage extends StatelessWidget
    with Page<AppState, TestamentPageVM> {
  const TestamentPage({Key? key}) : super(key: key);

  @override
  void onInitialBuild(TestamentPageVM viewModel) {
    viewModel
      ..fetchTestaments()
      ..fetchBanners();
  }

  @override
  Widget buildContent(BuildContext context, TestamentPageVM viewModel) {
    return Column(
      children: [
        buildBanner(viewModel),
        buildBody(viewModel, context),
      ],
    );
  }

  Widget buildBody(TestamentPageVM vm, BuildContext context) {
    return Expanded(
      child: vm.loadingState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        failed: () => Center(child: Text(vm.error!)),
        success: () => buildOnSuccess(context, vm),
      ),
    );
  }

  Widget buildBanner(TestamentPageVM vm) {
    return vm.bannerLoadingState.maybeWhen(
      success: () {
        return vm.banner == null
            ? const SizedBox()
            : BannerWidget(banner: vm.banner!);
      },
      orElse: () => const SizedBox(),
    );
  }

  @override
  TestamentPageVM initViewModel() => TestamentPageVM();

  Widget buildOnSuccess(BuildContext context, TestamentPageVM vm) {
    var testaments = vm.testaments!;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: testaments.length,
      itemBuilder: (BuildContext context, int index) => buildTestaments(
        context,
        testaments[index],
      ),
    );
  }

  Widget buildTestaments(BuildContext context, Testament testament) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTestamentHeading(testament, context),
        TestamentGrid(testament: testament),
      ],
    );
  }

  Container buildTestamentHeading(Testament testament, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color(0xff616161),
      height: kToolbarHeight,
      child: Text(
        testament.name,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
