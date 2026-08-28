import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAccountSwitchButton', type: GtAccountSwitchButton)
Widget playgroundGtAccountSwitchButtonUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Account Text',
    initialValue: 'Savings Account',
  );
  final customBg = context.knobs.boolean(
    label: 'Custom Background Color',
    initialValue: false,
  );
  final customText = context.knobs.boolean(
    label: 'Custom Text Color',
    initialValue: false,
  );

  final bgColor = customBg ? context.palette.bg.strong : null;
  final textColor = customText ? context.palette.primary.base : null;

  final codeSnippet =
      '''
GtAccountSwitchButton(
  alignment: .centerLeft,
  text: '$text',
  ${customBg ? "backgroundColor: context.palette.bg.strong,\n  " : ""}${customText ? "textColor: context.palette.primary.base,\n  " : ""}onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtAccountSwitchButton',
    description: '''
<b>GtAccountSwitchButton</b> is a compact pill button for switching accounts, profiles, or categories.
It displays uppercase text alongside a dropdown chevron icon and provides tap feedback via <b>GtInkWell</b>.''',
    code: codeSnippet,
    child: GtAccountSwitchButton(
      alignment: .centerLeft,
      text: text,
      backgroundColor: bgColor,
      textColor: textColor,
      onPressed: () {},
    ),
  );
}
