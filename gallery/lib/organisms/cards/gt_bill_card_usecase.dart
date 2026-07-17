import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBillCard', type: GtBillCard)
Widget playgroundGtBillCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtBillCard',
    description: 'Documentation for GtBillCard',
    code: '''
GtBillCard(
  name: "Electricity",
  icon: GtIcon(GtIcons.lightbulb),
  onTap: () {},
)
''',
    child: GtBillCard(
      name: "Electricity",
      icon: const GtIcon(GtIcons.lightbulb),
      onTap: () {},
    ),
  );
}
