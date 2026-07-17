import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInboxCard', type: GtInboxCard)
Widget playgroundGtInboxCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtInboxCard',
    description: 'Documentation for GtInboxCard',
    code: '''
GtInboxCard(
  title: "Sterling Bank",
  subtitle: "Your transfer of N5,000 to John Doe was successful.",
  ureadCount: 2,
  messageCount: 5,
  onTap: () {},
)
''',
    child: GtInboxCard(
      title: "Sterling Bank",
      subtitle: "Your transfer of N5,000 to John Doe was successful.",
      ureadCount: 2,
      messageCount: 5,
      onTap: () {},
    ),
  );
}
