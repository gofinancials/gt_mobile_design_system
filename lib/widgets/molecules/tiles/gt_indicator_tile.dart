import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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
  final TextStyle? subTitleStyle;

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
    this.subTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textStyles = context.textStyles;

    final text = GtText(
      title,
      style: titleStyle ?? context.textStyles.subHeadS(),
      maxLines: 1,
      textAlign: TextAlign.start,
    );

    Widget leading = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 24),
      child: text,
    );

    if (subtitle != null) {
      leading = Column(
        spacing: context.spacingXs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          GtText(
            subtitle,
            style: subTitleStyle ?? textStyles.bodyXs(color: palette.text.soft),
          ),
          if (footer != null) ...[GtGap.ySm(), ?footer],
        ],
      );
    }

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Row(
        crossAxisAlignment: switch (footer == null) {
          false => CrossAxisAlignment.start,
          _ => CrossAxisAlignment.center,
        },
        spacing: context.spacingLg,
        children: [
          ?icon,
          Expanded(child: leading),
          ?trailing,
        ],
      ),
    );
  }
}