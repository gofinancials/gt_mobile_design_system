import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBackButton', type: GtBackButton)
Widget playgroundGtBackButtonUseCase(BuildContext context) {
  final sensitive = context.knobs.boolean(
    label: 'Route Stack Sensitive',
    initialValue: false,
  );
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: GtBackButtonSize.values,
    initialOption: GtBackButtonSize.large,
    labelBuilder: (s) => s.name,
  );

  final codeSnippet =
      '''
GtBackButton(
  routeStackSensitive: $sensitive,
  size: GtBackButtonSize.${size.name},
  onPressed: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtBackButton',
    description: '''
<b>GtBackButton</b> is a standardized back button component.
It intelligently pop back the navigation route stack. If <b>routeStackSensitive</b> is true, it automatically hides itself when there is no history to navigate back to.''',
    code: codeSnippet,
    child: GtBackButton(
      routeStackSensitive: sensitive,
      size: size,
      action: () {},
    ),
  );
}
