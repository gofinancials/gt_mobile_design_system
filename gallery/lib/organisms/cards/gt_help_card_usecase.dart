import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHelpCard', type: GtHelpCard)
Widget playgroundGtHelpCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtHelpCard',
    description: 'Documentation for GtHelpCard',
    code: '''
GtHelpCard(
  title: "Need help?",
  subtitle: "Contact our support team",
  onTap: () {},
)
''',
    child: GtHelpCard(
      title: "Need help?",
      subtitle: "Contact our support team",
      onTap: () {},
    ),
  );
}
