import 'package:flrx/flrx.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:ncb/modules/common/models/banner.dart';
import 'package:platform_info/platform_info.dart';

class BannerWidget extends StatelessWidget {
  final Banner banner;

  const BannerWidget({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = platform.when(
      mobile: () => banner.mobileBanner,
      desktop: () => banner.desktopBanner,
    );

    if (url == null) {
      return const SizedBox();
    }

    if (url.isEmpty) {
      return const SizedBox();
    }

    return Image.network(
      url,
      errorBuilder: (c, e, s) {
        Application.get<Logger>().e('Could not load banner', e, s);

        return const SizedBox();
      },
    );
  }
}
