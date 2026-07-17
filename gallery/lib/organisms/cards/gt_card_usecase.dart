import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCard', type: GtCard)
Widget playgroundGtCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtCard',
    description: 'Documentation for GtCard',
    code: '''
GtCard(
  padding: context.insets.allDp(16.px),
  variant: .normal,
  child: GtText("This is a basic card.", style: context.textStyles.bodyM()),
)
''',
    child: GtCard(
      padding: context.insets.allDp(16.px),
      variant: .normal,
      child: GtText("This is a basic card.", style: context.textStyles.bodyM()),
    ),
  );
}
