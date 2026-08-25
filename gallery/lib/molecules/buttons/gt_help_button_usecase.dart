import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHelpButton', type: GtHelpButton)
Widget playgroundGtHelpButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.secondary,
    labelBuilder: (v) => v.name,
  );
  final customBg = context.knobs.boolean(
    label: 'Custom Background Color',
    initialValue: false,
  );
  final customText = context.knobs.boolean(
    label: 'Custom Text Color',
    initialValue: false,
  );

  final bgColor = customBg ? context.palette.primary.alpha16 : null;
  final textColor = customText ? context.palette.primary.dark : null;

  final codeSnippet = '''
GtHelpButton(
  variant: GtButtonVariant.${variant.name},
  ${customBg ? "backgroundColor: context.palette.primary.alpha16,\n  " : ""}${customText ? "textColor: context.palette.primary.dark,\n  " : ""}onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtHelpButton',
    description: '''
<b>GtHelpButton</b> is a standardized help action button used across app bars and screens.
It renders a compact <b>GtRaisedButton</b> configured with a spark icon and localized help text.''',
    code: codeSnippet,
    child: GtHelpButton(
      variant: variant,
      backgroundColor: bgColor,
      textColor: textColor,
      onPressed: () {},
    ),
  );
}
