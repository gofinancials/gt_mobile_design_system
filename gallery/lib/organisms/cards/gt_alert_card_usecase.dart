import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAlertCard', type: GtAlertCard)
Widget playgroundGtAlertCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtAlertCard',
    description: 'Documentation for GtAlertCard',
    code: '''
GtAlertCard(
  title: "Alert Title",
  subtitle: "This is a brief alert message.",
  icon: GtIcons.warningOutline,
  variant: .warning,
)
''',
    child: const GtAlertCard(
      title: "Alert Title",
      subtitle: "This is a brief alert message.",
      icon: GtIcons.triangleWarning,
      variant: .warning,
    ),
  );
}
