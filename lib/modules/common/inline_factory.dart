import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '';

class InlineWidget extends WidgetFactory {
  final Map<String, ValueGetter<Widget>> inlineElementBuilder;

  InlineWidget(this.inlineElementBuilder);

  @override
  void parse(BuildTree meta) {
    var tagName = meta.element.localName;
    if (inlineElementBuilder.containsKey(tagName)) {
      meta.register(
        BuildOp(
          onTree: (meta, tree) {
            tree.append(
              WidgetBit.inline(
                tree,
                inlineElementBuilder[tagName]!(),
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
              ),
            );
          },
        ),
      );
    }
//
    super.parse(meta);
  }
}
