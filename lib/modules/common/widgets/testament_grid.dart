import 'package:flutter/material.dart';
import 'package:ncb/book_local.dart';
import 'package:ncb/testament_local.dart';
import 'package:recase/recase.dart';

class TestamentGrid extends StatelessWidget {
  final TestamentLocal testament;

  const TestamentGrid({Key? key, required this.testament}) : super(key: key);
  static const _crossAxisSpacing = 4;
  static const _crossAxisCount = 3;
  static const cellHeight = 60;

  @override
  Widget build(BuildContext context) {
    double aspectRatio = calculateAspectRatioForGridTile(context);

    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: _crossAxisCount,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: _crossAxisSpacing.toDouble(),
      mainAxisSpacing: _crossAxisSpacing.toDouble(),
      children: testament.books.map((book) {
        return InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/book/${book.id}',
          ),
          child: buildBookTile(context, book),
        );
      }).toList(),
    );
  }

  Container buildBookTile(BuildContext context, BookLocal book) {
    return Container(
      height: kToolbarHeight,
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: Text(
        book.name.titleCase,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  double calculateAspectRatioForGridTile(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var aspectRatio = width / cellHeight;

    return aspectRatio;
  }
}
