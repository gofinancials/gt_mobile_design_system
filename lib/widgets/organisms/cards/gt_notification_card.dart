import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The kind of alert a [GtNotificationCard] carries, which sets its colors and
/// illustration.
enum GtNotificationVariant {
  /// Something went wrong.
  error,

  /// Something needs the customer's attention.
  warning,

  /// Something completed as expected.
  success,

  /// Neutral information.
  info;

  /// The card variant whose colors the notification takes.
  GtCardVariant get cardVariant => switch (this) {
    error => .error,
    warning => .warning,
    success => .success,
    info => .info,
  };

  /// The illustration shown for this kind of notification.
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
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides close button spacing in logical pixels. Null preserves the current default.
  final double? closeButtonSpacing;

  /// The main title of the alert.
  final String title;

  /// The secondary text or subtitle of the alert.
  final String? subtitle;

  /// The visual variant of the notification, which determines its background, border, and icon colors.
  final GtNotificationVariant variant;

  /// Called when the close button is pressed.
  final OnPressed onClose;

  /// Creates a [GtNotificationCard].
  const GtNotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.variant = .error,
    required this.onClose,
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.closeButtonSpacing,
  });

  /// Creates a skeleton of a notification card, standing in for one whose
  /// alert is still loading.
  ///
  /// The card is neutral by default, in the normal card background, so a
  /// loading notification does not read as an alert of any kind. Pass
  /// [variant] where the kind is already known and its color should show.
  const factory GtNotificationCard.skeleton({
    Key? key,
    GtNotificationVariant? variant,
  }) = _GtNotificationCardSkeleton;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final cardVariant = variant.cardVariant;
    final bgColor = switch (context.isInDarkMode) {
      true => cardVariant.getIconColor(palette),
      _ => cardVariant.getBorderColor(palette),
    };

    return GtCard(
      padding: padding ?? context.insets.allDp(12.px),
      color: backgroundColor ?? bgColor,
      shadows: context.shadows.lg(),
      child: Row(
        crossAxisAlignment: .start,
        spacing: horizontalSpacing ?? context.spacingBase,
        children: [
          GtSvg(
            variant.illustration,
            width: 40,
            height: 40,
            alignment: .topLeft,
            isDecorative: true,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: verticalSpacing ?? context.spacingSm,
              mainAxisSize: .min,
              children: [
                GtText(
                  title.upper,
                  style: GtTextStyleOverrides.resolve(
                    titleStyle,
                    context.textStyles.buttonS(),
                    titleColor,
                  ),
                ),
                GtText(
                  subtitle,
                  style: GtTextStyleOverrides.resolve(
                    subtitleStyle,
                    context.textStyles.subHead2xs(),
                    subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          (closeButtonSpacing == null
              ? const GtGap.hBase()
              : SizedBox(width: closeButtonSpacing)),
          GtCancelButton(size: .small, alignment: .topRight, onTap: onClose),
        ],
      ),
    );
  }
}

/// Ignores a dismissal, for a skeleton card that cannot be closed.
void _ignoreClose() {}

/// A private skeleton of [GtNotificationCard], laid out with placeholder data under its
/// own [GtSkeleton].
class _GtNotificationCardSkeleton extends GtNotificationCard {
  /// Whether no variant was asked for, so the card takes the neutral card
  /// background instead of the variant's tint.
  final bool _isNeutral;

  /// Creates a [_GtNotificationCardSkeleton].
  const _GtNotificationCardSkeleton({super.key, GtNotificationVariant? variant})
    : _isNeutral = variant == null,
      super(
        title: 'Notification title',
        subtitle: 'A line or two of detail about the notification',
        variant: variant ?? .info,
        onClose: _ignoreClose,
      );

  @override
  Widget build(BuildContext context) {
    return GtSkeleton(
      child: Builder(
        builder: (context) {
          if (!_isNeutral) return super.build(context);
          return GtNotificationCard(
            title: title,
            subtitle: subtitle,
            variant: variant,
            onClose: onClose,
            backgroundColor: context.palette.bg.weak,
          );
        },
      ),
    );
  }
}
