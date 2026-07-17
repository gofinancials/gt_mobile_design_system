import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLineChartHeader', type: GtLineChartHeader)
Widget playgroundGtLineChartHeaderUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtLineChartHeader',
    description: 'Documentation for GtLineChartHeader',
    code: '''
GtLineChartHeader(
  title: "Total Balance",
  value: "\$12,450.00",
  range: "Jan - Dec",
  actionText: "Select Date",
  onTapAction: () {},
)
''',
    child: GtLineChartHeader(
      title: "Total Balance",
      value: "\$12,450.00",
      range: "Jan - Dec",
      actionText: "Select Date",
      onTapAction: () {},
    ),
  );
}
