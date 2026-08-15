import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCancelButton', type: GtCancelButton)
Widget playgroundGtCancelButtonUseCase(BuildContext context) {
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: GtCancelButtonSize.values,
    initialOption: GtCancelButtonSize.large,
    labelBuilder: (s) => s.name,
  );
  final asHero = context.knobs.boolean(label: 'As Hero', initialValue: false);

  final codeSnippet =
      '''
GtCancelButton(
  size: GtCancelButtonSize.${size.name},
  asHero: $asHero,
  onTap: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtCancelButton',
    description: '''
<b>GtCancelButton</b> is a standardized cancel (cross) button designed for closing overlays or modals.
It automatically triggers context pop navigation with haptic feedback by default.''',
    code: codeSnippet,
    child: GtCancelButton(size: size, asHero: asHero, onTap: () {}),
  );
}
