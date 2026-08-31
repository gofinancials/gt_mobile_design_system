import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A general-purpose list tile that displays a primary text with optional
/// leading and trailing widgets.
///
/// Triggers the [onTap] callback with light haptic feedback when pressed.
class GtListTile extends GtStatelessWidget {
  /// The primary text to display in the tile.
  final String text;

  /// An optional widget to display at the start of the tile.
  final Widget? leading;

  /// An optional widget to display at the end of the tile.
  final Widget? trailing;

  /// The callback triggered when the tile is tapped.
  final OnPressed? onTap;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a [GtListTile].
  const GtListTile({
    super.key,
    required this.text,
    this.leading,
    this.trailing,
    this.onTap,
    this.horizontalSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadius2Xl,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingMd,
          children: [
            ?leading,
            Expanded(child: GtText(text, style: context.textStyles.subHeadS())),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// A list tile that emphasizes a leading icon alongside a title and subtitle.
class GtIconListTile extends GtStatelessWidget {
  /// The primary title text.
  final String title;

  /// The secondary text displayed below the title.
  final String? subtitle;

  /// The icon displayed at the start of the tile.
  final IconData icon;

  /// Optional custom color for the [icon].
  final Color? iconColor;

  /// Vertical alignment of the row's children. Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment? crossAxisAlignment;

  /// The callback triggered when the tile is tapped.
  final OnPressed? onTap;

  /// Optional horizontal spacing override.
  final double? verticalSpacing;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Creates a [GtIconListTile].
  const GtIconListTile(
    this.title, {
    super.key,
    this.subtitle,
    required this.icon,
    this.crossAxisAlignment,
    this.iconColor,
    this.onTap,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
    this.trailing,
  });

  /// Creates a [GtIconListTile].
  const factory GtIconListTile.alt(
    String title, {
    Key? key,
    String? subtitle,
    required IconData icon,
    CrossAxisAlignment? crossAxisAlignment,
    OnPressed? onTap,
    Widget? trailing,
    double? verticalSpacing,
    double? horizontalSpacing,
    EdgeInsetsGeometry? padding,
  }) = _GtIconListTileAlt;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadius2Xl,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingMd,
          crossAxisAlignment: crossAxisAlignment ?? .start,
          children: [
            GtIcon.withColor(icon, size: context.dp(24.px), color: iconColor),
            Expanded(
              child: Column(
                spacing: verticalSpacing ?? context.spacingSm,
                crossAxisAlignment: .start,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  if (subtitle.hasValue)
                    GtText(
                      subtitle,
                      style: context.textStyles.bodyXs(color: palette.text.sub),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// A list tile that emphasizes a leading icon alongside a title and subtitle.
class _GtIconListTileAlt extends GtIconListTile {
  /// Creates a [GtIconListTile].
  const _GtIconListTileAlt(
    super.title, {
    super.key,
    super.subtitle,
    required super.icon,
    super.crossAxisAlignment,
    super.onTap,
    super.trailing,
    super.verticalSpacing,
    super.horizontalSpacing,
    super.padding,
  }) : super(iconColor: null);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadius2Xl,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingMd,
          crossAxisAlignment: crossAxisAlignment ?? .center,
          children: [
            Container(
              alignment: .center,
              width: context.dp(36.px),
              height: context.dp(36.px),
              decoration: BoxDecoration(
                color: context.palette.bg.weak,
                borderRadius: context.borderRadiusXl,
              ),
              child: GtIcon(icon, size: context.dp(24.px)),
            ),
            Expanded(
              child: Column(
                spacing: verticalSpacing ?? 0,
                crossAxisAlignment: .start,
                children: [
                  GtText(title, style: context.textStyles.bodyM()),
                  if (subtitle.hasValue)
                    GtText(
                      subtitle,
                      style: context.textStyles.bodyXs(color: palette.text.sub),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// A straightforward list tile used for simple navigation actions, featuring
/// a title and a trailing chevron.
class GtSimpleActionListTile extends GtStatelessWidget {
  /// The primary title text.
  final String title;

  /// The icon to display at the end of the tile. Defaults to `GtIcons.chevronRight`.
  final IconData trailing;

  /// The callback triggered when the tile is tapped.
  final OnPressed? onTap;

  /// The padding to apply to the tile.
  final EdgeInsetsGeometry? padding;

  /// The size of the trailing icon.
  final double? trailingIconSize;

  /// The style of the title text.
  final TextStyle? titleStyle;

  /// The style of the trailing icon.
  final GtIconVariant? trailingIconVariant;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Creates a [GtSimpleActionListTile].
  const GtSimpleActionListTile(
    this.title, {
    super.key,
    this.trailing = GtIcons.chevronRight,
    this.onTap,
    this.padding,
    this.trailingIconSize,
    this.titleStyle,
    this.trailingIconVariant,
    this.horizontalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadius2Xl,
      onTap: onTap,
      child: Padding(
        padding: padding ?? context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: horizontalSpacing ?? context.spacingMd,
          children: [
            Expanded(
              child: GtText(
                title,
                style: titleStyle ?? context.textStyles.h6(),
              ),
            ),
            GtIcon(
              trailing,
              size: trailingIconSize ?? context.dp(20.px),
              variant: trailingIconVariant ?? .soft,
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }
}
