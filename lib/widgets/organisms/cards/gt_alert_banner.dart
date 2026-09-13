import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A banner for alerts, with a title, subtitle, icon, and close button.
class GtAlertBanner extends GtStatelessWidget {
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

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// The main title of the alert banner.
  final String title;

  /// The secondary text or subtitle of the alert banner.
  final String subtitle;

  /// The icon to display in the banner.
  final Widget icon;

  /// If true, the banner will be hidden (faded out).
  final bool hidden;

  /// The visual variant of the card, which determines its background color.
  final GtCardVariant variant;

  /// A callback function that is invoked when the close button is tapped.
  final OnPressed onClose;

  /// A callback function that is invoked when the card is tapped
  final OnPressed? onTap;

  /// Creates a [GtAlertBanner].
  const GtAlertBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .away,
    required this.icon,
    required this.onClose,
    this.onTap,
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.verticalSpacing,
    this.horizontalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bgColor = variant.getIconColor(palette);

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtInkWell(
        role: .button,
        borderRadius: context.borderRadius2Xl,
        onTap: onTap,
        child: GtCard(
          padding: padding ?? context.insets.allDp(12.px),
          color: backgroundColor ?? bgColor,
          child: Column(
            spacing: verticalSpacing ?? context.spacingSm,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: horizontalSpacing ?? context.spacingBase,
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  GtSquareConstrainedBox(84, child: icon),
                  GtCancelButton(onTap: onClose, alignment: .topRight),
                ],
              ),
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
                  context.textStyles.subHeadS(),
                  subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
