import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtGuageChartCenter', type: GtGuageChartCenter)
Widget playgroundGtGuageChartCenterUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtGuageChartCenter',
    description: 'Documentation for GtGuageChartCenter',
    code: '''
GtGuageChartCenter(
  "75%",
  pillText: "+5%",
  footerText: "Overall Completion",
)
''',
    child: Center(
      child: GtGuageChartCenter(
        "75%",
        pillText: "+5%",
        footerText: "Overall Completion",
      ),
    ),
  );
}
