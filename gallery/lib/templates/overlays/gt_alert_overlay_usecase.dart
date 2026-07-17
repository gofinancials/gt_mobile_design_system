import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAlertOverlay', type: GtAlertOverlay)
Widget playgroundGtAlertOverlayUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Alert Title',
    initialValue: 'Payment Successful',
  );
  final message = context.knobs.string(
    label: 'Alert Message',
    initialValue: 'Your transaction was completed successfully.',
  );
  final variant = context.knobs.object.dropdown<GtNotificationVariant>(
    label: 'Variant',
    options: GtNotificationVariant.values,
    initialOption: GtNotificationVariant.success,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtAlertOverlay',
    description:
        'An alert message overlay widget representing operation outcomes. Present it via the BuildContext extension method.',
    code:
        '''
// Display alert overlay via BuildContext extension
context.showAlert(
  "$title",
  message: "$message",
  type: GtNotificationVariant.${variant.name},
  duration: 3000, // Optional milliseconds
);
''',
    child: GtRaisedButton(
      text: 'Trigger Alert Overlay',
      onPressed: () {
        context.showAlert(title, message: message, type: variant);
      },
    ),
  );
}
