import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtNotificationCard', type: GtNotificationCard)
Widget playgroundGtNotificationCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtNotificationCard',
    description: 'Documentation for GtNotificationCard',
    code: '''
GtNotificationCard(
  title: "Payment Successful",
  description: "Your payment of N5,000 has been processed.",
  variant: .success,
)
''',
    child: GtNotificationCard(
      title: "Payment Successful",
      subtitle: "Your payment of N5,000 has been processed.",
      variant: .success,
      onClose: () {},
    ),
  );
}
