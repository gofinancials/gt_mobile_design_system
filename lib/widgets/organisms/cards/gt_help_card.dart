import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card that links to a help or support section, often with a message icon.
class GtHelpCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

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

  /// The main title text of the help card.
  final String title;

  /// Optional subtitle text displayed below the title.
  final String? subtitle;

  /// The visual variant of the card, which determines its background and icon colors.
  final GtCardVariant variant;

  /// An optional callback function that is invoked when the card is tapped.
  final OnPressed? onTap;

  /// Optional padding for the card. Default is [context.insets.allDp(12.px)]
  final EdgeInsetsGeometry? padding;

  /// The size of the icon. Default is 24
  final double? iconSize;

  /// The icon to display in the help card. Default is [GtIcons.messages]
  final IconData icon;

  /// Creates a [GtHelpCard].
  const GtHelpCard({
    super.key,
    required this.title,
    this.subtitle,
    this.variant = .normal,
    this.onTap,
    this.padding,
    this.iconSize,
    this.icon = GtIcons.messages,
    this.backgroundColor,
    this.iconColor,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.horizontalSpacing,
    this.verticalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = switch (variant) {
      .error => palette.text.strong,
      _ => variant.getIconColor(palette),
    };
    Widget? footer;

    if (subtitle.hasValue) {
      footer = GtText(
        subtitle,
        style: GtTextStyleOverrides.resolve(
          subtitleStyle,
          context.textStyles.bodyXs(color: palette.text.soft),
          subtitleColor,
        ),
      );
    }

    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadiusXl,
      onTap: onTap,
      child: GtCard(
        padding: padding ?? context.insets.allDp(12.px),
        borderRadius: context.borderRadiusXl,
        variant: variant,
        color: backgroundColor,
        child: GtBaseListTileTemplate(
          padding: context.insets.zero,
          spacing: horizontalSpacing ?? context.spacingLg,
          spacingToSubTitle: verticalSpacing ?? 0,
          subtitle: footer,
          crossAxisAlignment: .center,
          title: GtText(
            title,
            style: GtTextStyleOverrides.resolve(
              titleStyle,
              context.textStyles.bodyM(),
              titleColor,
            ),
          ),
          leading: GtIcon.withColor(
            icon,
            size: iconSize ?? context.dp(24.px),
            color: this.iconColor ?? iconColor,
          ),
        ),
      ),
    );
  }
}
