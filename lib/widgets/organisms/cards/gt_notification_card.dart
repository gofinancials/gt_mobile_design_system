import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

enum GtNotificationVariant {
  error,
  warning,
  success,
  info;

  GtCardVariant get cardVariant => switch (this) {
    error => .error,
    warning => .warning,
    success => .success,
    info => .info,
  };

  String get illustration => switch (this) {
    .success => GtVectorIllustrations.success,
    .error => GtVectorIllustrations.failed,
    .warning => GtVectorIllustrations.serviceStatus,
    .info => GtVectorIllustrations.exclamation,
  };
}

/// A card for displaying alerts, typically with an icon, title, and subtitle,
/// and a distinct border.
class GtNotificationCard extends GtStatelessWidget {
  /// The main title of the alert.
  final String title;

  /// The secondary text or subtitle of the alert.
  final String? subtitle;

  /// The visual variant of the notification, which determines its background, border, and icon colors.
  final GtNotificationVariant variant;

  final OnPressed onClose;

  /// Creates a [GtNotificationCard].
  const GtNotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.variant = .error,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bgColor = variant.cardVariant.getBorderColor(palette);

    return GtCard(
      padding: context.insets.allDp(12.px),
      color: bgColor,
      child: Row(
        crossAxisAlignment: .start,
        spacing: context.spacingBase,
        children: [
          GtSvg(
            variant.illustration,
            width: 40,
            height: 40,
            alignment: .topLeft,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: context.spacingSm,
              children: [
                GtText(title.upper, style: context.textStyles.buttonS()),
                GtText(subtitle, style: context.textStyles.subHead2xs()),
              ],
            ),
          ),
          const GtGap.hBase(),
          GtCancelButton(size: 20, alignment: .topRight, onTap: onClose),
        ],
      ),
    );
  }
}
