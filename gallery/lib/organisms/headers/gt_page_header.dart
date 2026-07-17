import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPageHeader', type: GtPageHeader)
Widget playgroundGtPageHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Almost there!',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'See balances and recent activity in one place.',
  );

  return GtWidgetDocPage(
    title: 'GtPageHeader',
    description:
        'A standard header layout displaying a screen title and description subtitle.',
    code:
        '''
GtPageHeader(
  title: "$title",
  subtitle: "$subtitle",
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtPageHeader(
          title: title,
          subtitle: subtitle.isEmpty ? null : subtitle,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtPageHeader.rich', type: GtPageHeader)
Widget playgroundGtPageHeaderRichUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Terms & Conditions',
  );
  final richSubtitle = context.knobs.string(
    label: 'Rich Subtitle',
    initialValue:
        'Please read the terms. <a href="https://sterling.ng">T&C apply</a> <b>bold</b> <i>italic</i>',
  );

  return GtWidgetDocPage(
    title: 'GtPageHeader.rich',
    description:
        'A page header supporting rich/HTML-tagged markup inside the subtitle.',
    code:
        '''
GtPageHeader.rich(
  title: "$title",
  subtitle: '$richSubtitle',
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtPageHeader.rich(
          title: title,
          subtitle: richSubtitle.isEmpty ? null : richSubtitle,
        ),
      ),
    ),
  );
}
