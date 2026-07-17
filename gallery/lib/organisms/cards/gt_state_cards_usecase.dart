import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtEmptyStateCard', type: GtEmptyStateCard)
Widget playgroundGtEmptyStateCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtEmptyStateCard',
    description: 'Documentation for GtEmptyStateCard',
    code: '''
GtEmptyStateCard(
  icon: GtIcons.document,
  description: "No data available at the moment.",
)
''',
    child: const GtEmptyStateCard(
      icon: GtIcons.document,
      description: "No data available at the moment.",
    ),
  );
}

@widgetbook.UseCase(name: 'GtActionableEmptyStateCard', type: GtActionableEmptyStateCard)
Widget playgroundGtActionableEmptyStateCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtActionableEmptyStateCard',
    description: 'Documentation for GtActionableEmptyStateCard',
    code: '''
GtActionableEmptyStateCard(
  icon: GtIcons.document,
  title: "No transactions",
  description: "You haven't made any transactions yet.",
  buttontext: "Make a Transfer",
  onPressed: () {},
)
''',
    child: GtActionableEmptyStateCard(
      icon: GtIcons.document,
      title: "No transactions",
      description: "You haven't made any transactions yet.",
      buttontext: "Make a Transfer",
      onPressed: () {},
    ),
  );
}
