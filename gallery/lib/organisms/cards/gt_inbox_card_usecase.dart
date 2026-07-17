import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInboxCard', type: GtInboxCard)
Widget playgroundGtInboxCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Inbox');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Hi Alex, how can we help you?');
  final ureadCount = context.knobs.int.slider(label: 'Unread Count', min: 0, max: 20, initialValue: 2);
  final messageCount = context.knobs.int.slider(label: 'Message Count', min: 0, max: 20, initialValue: 5);

  return GtWidgetDocPage(
    title: 'GtInboxCard',
    description: 'Displays customer support inbox status, unread chat indicator badges, and description.',
    code: '''
GtInboxCard(
  title: "$title",
  subtitle: "$subtitle",
  ureadCount: $ureadCount,
  messageCount: $messageCount,
)''',
    child: GtInboxCard(
      title: title,
      subtitle: subtitle,
      ureadCount: ureadCount,
      messageCount: messageCount,
    ),
  );
}
