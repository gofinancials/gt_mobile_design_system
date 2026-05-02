import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Opens a rounded bottom sheet tall enough for [GtStatusState]’s [Expanded]
/// layout, matching the modal pattern from [playgroundGtStatusStateUseCase].

@widgetbook.UseCase(name: 'GtStatusState', type: GtStatusState)
Widget playgroundGtStatusStateUseCase(BuildContext context) {
  return GalleryStatusWidgetShowcase(
    key: PageStorageKey("gallery-state-showcase"),
  );
}

class GalleryStatusWidgetShowcase extends StatelessWidget
    with GtBottomSheetMixin {
  const GalleryStatusWidgetShowcase({super.key});

  void showStatusModal(
    BuildContext context, {
    required bool success,
    required String actionLabel,
  }) {
    showSheet<void>(
      context,
      isScrollable: true,
      child: Builder(
        builder: (context) {
          if (success) {
            return GtStatusState.success(
              messageTitle: "successful !",
              subtitle:
                  "Your BVN was added successfully. You can now initiate transactions.",
              actionLabel: actionLabel,
              onActionPressed: () => Navigator.of(context).pop(),
            );
          }
          return GtStatusState.error(
            messageTitle: "Verification failed",
            subtitle:
                "We could not verify your identity at this moment. Please try again in an hour.",
            actionLabel: actionLabel,
            onActionPressed: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }

  void showOtherModal(
    BuildContext context, {
    required String stausIcon,
    required String actionLabel,
    required String messageTitle,
    required String subtitle,
  }) {
    showSheet<void>(
      context,
      isScrollable: true,
      child: GtStatusState.other(
        messageTitle: messageTitle,
        subtitle: subtitle,
        statusIcon: stausIcon,
        actionLabel: actionLabel,
        onActionPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => showStatusModal(
                context,
                success: true,
                actionLabel: 'Go Home',
              ),
              text: 'Show success status',
            ),
            GtRaisedButton(
              onPressed: () => showStatusModal(
                context,
                success: false,
                actionLabel: 'Try again',
              ),
              text: 'Show error status',
              variant: .destructive,
            ),
            GtRaisedButton(
              onPressed: () => showOtherModal(
                context,
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
                context,
                stausIcon: GtVectorIllustrations.unauthorizedDevice,
                messageTitle: "Unauthorized Device",
                subtitle: "The device used isn’t approved.",
                actionLabel: 'Contact Support',
              ),
              text: "Show other status - Unauthorized",
              variant: .black,
            ),
            GtRaisedButton(
              onPressed: () {
                showOtherModal(
                  context,
                  stausIcon: GtVectorIllustrations.disconnected,
                  messageTitle: "Session Timeout",
                  subtitle: "Your session expired; you need to log in again.",
                  actionLabel: 'Login',
                );
              },
              text: "Show other status - Session",
              variant: .featured,
            ),
            GtRaisedButton(
              onPressed: () => showOtherModal(
                context,
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
}
