import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtRichText', type: GtRichText)
Widget playgroundGtRichTextUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: "Text Content",
    initialValue:
        "Here is <b>bold</b>, <i>italic</i>, and <e>error</e> text. Also a <ht>#hashtag</ht>.",
  );

  final textAlign = context.knobs.objectOrNull.dropdown<TextAlign?>(
    label: "Text Alignment",
    initialOption: null,
    options: [
      null,
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
      TextAlign.justify,
    ],
    labelBuilder: (val) => val == null ? 'Default' : val.name,
  );

  return GtWidgetDocPage(
    title: 'GtRichText',
    description:
        'A versatile rich text widget that parses and renders HTML-like tags using the design system.',
    code:
        '''
GtRichText(
  '$text',
  textAlign: $textAlign,
  onTextTap: (text) {
    // Handle tap on interactive tags like hashtags or links
  },
)
''',
    child: GtRichText(
      text,
      textAlign: textAlign,
      onTextTap: (t) => context.showToast('Tapped: \$t'),
    ),
  );
}
