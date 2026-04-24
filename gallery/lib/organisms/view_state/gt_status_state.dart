import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Opens a rounded bottom sheet tall enough for [GtStatusState]’s [Expanded]
/// layout, matching the modal pattern from [playgroundGtStatusStateUseCase].

@widgetbook.UseCase(
  name: 'Status state',
  type: GtStatusState,
  path: '[Organisms]/View state',
)
Widget playgroundGtStatusStateUseCase(BuildContext context) {
  /// Success state
  final successTitle = context.knobs.string(
    label: 'Success message title',
    initialValue: 'Payment Approved',
  );
  final successSubtitle = context.knobs.string(
    label: 'Success subtitle',
    initialValue:
        'You’ve approved the money request of ₦20,000 from Fola Lobalobs. The money has been sent.',
  );

  /// Error state
  final errorTitle = context.knobs.string(
    label: 'Error message title',
    initialValue: 'Verification failed',
  );
  final errorSubtitle = context.knobs.string(
    label: 'Error subtitle',
    initialValue:
        'We could not verify your identity at this moment. Please try again in an hour.',
  );

  showModal({
    required bool success,
    required String messageTitle,
    required String subtitle,
    required String actionLabel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final height = MediaQuery.sizeOf(context).height * 0.99;
        return Material(
          type: .transparency,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: 50.topBorderRadius,
              color: context.palette.bg.white,
            ),
            child: success
                ? GtStatusState.success(
                    messageTitle: messageTitle,
                    subtitle: subtitle,
                    actionLabel: actionLabel,
                    onActionPressed: () => Navigator.of(context).pop(),
                  )
                : GtStatusState.error(
                    messageTitle: messageTitle,
                    subtitle: subtitle,
                    actionLabel: actionLabel,
                    onActionPressed: () => Navigator.of(context).pop(),
                  ),
          ),
        );
      },
    );
  }

  return Scaffold(
    body: Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: context.spacingLg,
        children: [
          GalleryPageHeader(
            title: 'Status State',
            rider: 'Representation of the success and failure states',
          ),
          const GtGap.yXl(),
          GtRaisedButton(
            onPressed: () => showModal(
              success: true,
              messageTitle: successTitle,
              subtitle: successSubtitle,
              actionLabel: 'Done',
            ),
            text: 'Show success status',
          ),
          GtRaisedButton(
            onPressed: () => showModal(
              success: false,
              messageTitle: errorTitle,
              subtitle: errorSubtitle,
              actionLabel: 'Try again',
            ),
            text: 'Show error status',
            variant: GtButtonVariant.destructive,
          ),
        ],
      ),
    ),
  );
}
