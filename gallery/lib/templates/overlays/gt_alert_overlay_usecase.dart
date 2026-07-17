import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAlertOverlay', type: GtAlertOverlay)
Widget gtAlertOverlayUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Alert Overlay",
    description: "Displays an alert notification over the screen.",
    code: '''
GtAlertOverlay(
  'Payment Successful',
  message: 'Your transaction was completed successfully.',
  type: .success,
  onClose: () {},
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtAlertOverlay"),
        GtAlertOverlay(
          context.knobs.string(
            label: 'Alert Title',
            initialValue: 'Payment Successful',
          ),
          message: context.knobs.string(
            label: 'Alert Message',
            initialValue: 'Your transaction was completed successfully.',
          ),
          type: context.knobs.object.dropdown<GtNotificationVariant>(
            label: 'Variant',
            options: GtNotificationVariant.values,
            initialOption: .success,
          ),
          onClose: () {},
        ),
      ],
    ),
  );
}
