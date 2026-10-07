import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Where an indicator tile places its indicator (checkbox, radio, switch)
/// relative to the title.
enum GtIndicatorPosition {
  /// Before the title, at the start of the row.
  leading,

  /// After the title, at the end of the row.
  trailing,
}

/// A foundational tile component often used alongside indicators (e.g.,
/// checkboxes, switches, radios). It provides a standardized layout for titles,
/// subtitles, and icons.
class GtIndicatorTile extends GtStatelessWidget {
  /// The primary text to display in the tile.
  final String title;

  /// Optional secondary text to display below the [title].
  final String? subtitle;

  /// An optional widget to display at the start of the tile, typically an icon.
  final Widget? icon;

  /// The callback triggered when the tile is tapped. Includes light haptic feedback.
  final OnPressed? onTap;

  /// An optional widget to display at the end of the tile, typically the indicator itself (e.g., switch, checkbox).
  final Widget? trailing;

  /// An optional widget to display below the main content of the tile.
  final Widget? footer;

  /// Custom text style to apply to the [title].
  final TextStyle? titleStyle;

  /// Custom text style to apply to the [subtitle].
  final TextStyle? subtitleStyle;

  /// Custom padding to apply to the tile.
  final EdgeInsetsGeometry? padding;

  /// Horizontal gap between [icon], the title and [trailing], in **design
  /// pixels**.
  ///
  /// When `null`, uses [BuildContext.spacingLg] (~16dp). Otherwise passed
  /// through [BuildContext.dp] via [num.px].
  final double? spacingPx;

  /// Creates a [GtIndicatorTile].
  const GtIndicatorTile(
    this.title, {
    this.trailing,
    super.key,
    this.subtitle,
    this.icon,
    this.footer,
    this.onTap,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.spacingPx,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textStyles = context.textStyles;
    final gapPx = spacingPx;
    final spacing = gapPx == null ? context.spacingLg : context.dp(gapPx.px);

    final text = GtText(
      title,
      style: titleStyle ?? context.textStyles.labelS(weight: .w600),
      maxLines: 1,
      textAlign: TextAlign.start,
    );

    Widget leading = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 24),
      child: text,
    );

    if (subtitle.hasValue) {
      leading = Column(
        spacing: context.spacingXs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          GtText(
            subtitle,
            style: subtitleStyle ?? textStyles.bodyXs(color: palette.text.soft),
          ),
          if (footer != null) ...[GtGap.ySm(), ?footer],
        ],
      );
    }

    return GtInkWell(
      role: .button,
      borderRadius: .zero,
      onTap: onTap,
      child: Padding(
        padding: padding ?? .zero,
        child: Row(
          crossAxisAlignment: switch (footer == null) {
            false => CrossAxisAlignment.start,
            _ => CrossAxisAlignment.center,
          },
          spacing: spacing,
          children: [
            ?icon,
            Expanded(child: leading),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
