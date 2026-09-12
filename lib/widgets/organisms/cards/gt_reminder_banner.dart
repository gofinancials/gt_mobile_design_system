import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A banner for reminders that includes a call-to-action button.
class GtReminderBanner extends GtStatelessWidget {
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

  /// Overrides action spacing in logical pixels. Null preserves the current default.
  final double? actionSpacing;

  /// Overrides close button spacing in logical pixels. Null preserves the current default.
  final double? closeButtonSpacing;

  /// The main title of the reminder banner.
  final String title;

  /// The secondary text or subtitle of the reminder banner.
  final String subtitle;

  /// The icon to display in the banner.
  final Widget icon;

  /// If true, the banner will be hidden (faded out).
  final bool hidden;

  /// The text to display on the action button.
  ///
  /// Must be non-null when [onActionTap] is provided.
  final String? actionText;

  /// A callback function that is invoked when the action button is tapped.
  final OnPressed? onActionTap;

  /// The visual variant of the card, which determines its background color.
  final GtCardVariant variant;

  /// The visual variant of the button.
  final GtButtonVariant buttonVariant;

  /// A callback function that is invoked when the close button is tapped.
  final OnPressed onClose;

  /// Creates a [GtReminderBanner].
  const GtReminderBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .away,
    this.buttonVariant = .primary,
    required this.icon,
    required this.onClose,
    this.actionText,
    this.onActionTap,
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.actionSpacing,
    this.closeButtonSpacing,
  }) : assert(
         onActionTap == null || actionText != null,
         'actionText must be provided when onActionTap is provided.',
       );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bgColor = variant.getBorderColor(palette);

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtCard(
        padding: padding ?? context.insets.allDp(12.px),
        color: backgroundColor ?? bgColor,
        child: Row(
          crossAxisAlignment: .start,
          spacing: horizontalSpacing ?? context.spacingBase,
          children: [
            GtSquareConstrainedBox(48, child: icon),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  GtText(
                    title.upper,
                    style: GtTextStyleOverrides.resolve(
                      titleStyle,
                      context.textStyles.h7(),
                      titleColor,
                    ),
                  ),
                  (verticalSpacing == null
                      ? const GtGap.ySm()
                      : SizedBox(height: verticalSpacing)),
                  GtText(
                    subtitle,
                    style: GtTextStyleOverrides.resolve(
                      subtitleStyle,
                      context.textStyles.subHeadS(),
                      subtitleColor,
                    ),
                  ),
                  if (onActionTap != null) ...[
                    (actionSpacing == null
                        ? const GtGap.yBase()
                        : SizedBox(height: actionSpacing)),
                    GtRaisedButton(
                      onPressed: onActionTap!,
                      text: actionText,
                      variant: buttonVariant,
                      size: .small,
                    ),
                  ],
                ],
              ),
            ),
            (closeButtonSpacing == null
                ? const GtGap.hBase()
                : SizedBox(width: closeButtonSpacing)),
            GtCancelButton(onTap: onClose, size: .small, alignment: .topRight),
          ],
        ),
      ),
    );
  }
}
