import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTitleAppBar', type: GtTitleAppBar)
Widget playgroundGtTitleAppBarUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Settings');
  final implyTrailing = context.knobs.boolean(
    label: 'Imply Trailing Cancel',
    initialValue: true,
  );
  final hasTrailing = context.knobs.boolean(
    label: 'Custom Trailing Actions',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtTitleAppBar',
    description:
        'An app bar displaying a prominent left-aligned title with optional trailing action/cancel buttons.',
    code:
        '''
GtTitleAppBar(
  title: "$title",
  implyTrailing: $implyTrailing,
  ${hasTrailing ? '''trailing: GtOptionalWidgetPair(
    head: GtIconButton(icon: GtIcons.spark, onPressed: () {}),
    tail: GtIconButton(icon: GtIcons.bell, onPressed: () {}),
  ),''' : ''}
)''',
    child: GtTitleAppBar(
      title: title,
      implyTrailing: implyTrailing,
      trailing: hasTrailing
          ? GtOptionalWidgetPair(
              head: GtIconButton(icon: GtIcons.spark, onPressed: () {}),
              tail: GtIconButton(icon: GtIcons.bell, onPressed: () {}),
            )
          : GtOptionalWidgetPair(tail: GtCancelButton()),
    ),
  );
}
