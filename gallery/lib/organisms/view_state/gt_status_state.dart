import 'package:flutter/material.dart';
import 'package:gallery/templates/modals/gt_sheet_modal.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Opens a rounded bottom sheet tall enough for [GtStatusState]’s [Expanded]
/// layout, matching the modal pattern from [playgroundGtStatusStateUseCase].

String _sheetPlatformLabel(GtSheetModalPlatform platform) {
  return switch (platform) {
    GtSheetModalPlatform.android => 'Android',
    GtSheetModalPlatform.ios => 'iOS',
  };
}

@widgetbook.UseCase(name: 'Status state', type: GtStatusState)
Widget playgroundGtStatusStateUseCase(BuildContext context) {
  final palette = context.palette;
  final platform = context.knobs.object.dropdown<GtSheetModalPlatform>(
    label: 'Sheet platform',
    options: GtSheetModalPlatform.values,
    initialOption: GtSheetModalPlatform.android,
    labelBuilder: _sheetPlatformLabel,
  );

  showStatusModal({required bool success, required String actionLabel}) {
    showGtSheetModal<void>(
      context: context,
      platform: platform,
      isScrollControlled: true,
      builder: (sheetContext) {
        final height = MediaQuery.sizeOf(sheetContext).height * 0.99;
        return Material(
          type: .transparency,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: 32.topBorderRadius,
              color: palette.bg.white,
            ),
            child: success
                ? GtStatusState.success(
                    messageTitle: "successful !",
                    subtitle:
                        "Your BVN was added successfully. You can now initiate transactions.",
                    actionLabel: actionLabel,
                    onActionPressed: () => Navigator.of(sheetContext).pop(),
                  )
                : GtStatusState.error(
                    messageTitle: "Verification failed",
                    subtitle:
                        "We could not verify your identity at this moment. Please try again in an hour.",
                    actionLabel: actionLabel,
                    onActionPressed: () => Navigator.of(sheetContext).pop(),
                  ),
          ),
        );
      },
    );
  }

  showOtherModal({
    required String stausIcon,
    required String actionLabel,
    required String messageTitle,
    required String subtitle,
  }) {
    showGtSheetModal<void>(
      context: context,
      platform: platform,
      isScrollControlled: true,
      builder: (sheetContext) {
        final height = MediaQuery.sizeOf(sheetContext).height * 0.99;
        return Material(
          type: .transparency,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: 32.topBorderRadius,
              color: palette.bg.white,
            ),
            child: GtStatusState.other(
              messageTitle: messageTitle,
              subtitle: subtitle,
              statusIcon: stausIcon,
              actionLabel: actionLabel,
              onActionPressed: () => Navigator.of(sheetContext).pop(),
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
            onPressed: () =>
                showStatusModal(success: true, actionLabel: 'Go Home'),
            text: 'Show success status',
          ),
          GtRaisedButton(
            onPressed: () =>
                showStatusModal(success: false, actionLabel: 'Try again'),
            text: 'Show error status',
            variant: .destructive,
          ),
          GtRaisedButton(
            onPressed: () => showOtherModal(
              stausIcon: GtVectorIllustrations.search,
              messageTitle: "not found !",
              subtitle: "The system couldn't find what you asked for.",
              actionLabel: 'Go Home',
            ),
            text: "Show other status - Not Found",
            variant: .away,
          ),
          GtRaisedButton(
            onPressed: () => showOtherModal(
              stausIcon: GtVectorIllustrations.unauthorizedDevice,
              messageTitle: "Unauthorized Device",
              subtitle: "The device used isn’t approved.",
              actionLabel: 'Contact Support',
            ),
            text: "Show other status - Unauthorized",
            variant: .black,
          ),
          GtRaisedButton(
            onPressed: () => showOtherModal(
              stausIcon: GtVectorIllustrations.disconnected,
              messageTitle: "Session Timeout",
              subtitle: "Your session expired; you need to log in again.",
              actionLabel: 'Login',
            ),
            text: "Show other status - Session",
            variant: .featured,
          ),
          GtRaisedButton(
            onPressed: () => showOtherModal(
              stausIcon: GtVectorIllustrations.maintenance,
              messageTitle: "Force update",
              subtitle:
                  "You are currently using an outdated version of OneBank with limited functionality, kindly download the latest version from Google Play Store or the App Store for a better experience.",
              actionLabel: 'Download App',
            ),
            text: "Show other status - Force update",
            variant: .verified,
          ),
        ],
      ),
    ),
  );
}
