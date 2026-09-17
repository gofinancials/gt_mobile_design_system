import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A general-purpose list tile that displays a primary text with optional
/// leading and trailing widgets.
///
/// Triggers the [onTap] callback with light haptic feedback when pressed.
class GtListTile extends GtStatelessWidget {
  /// Overrides style. Null preserves the current default.
  final TextStyle? style;

  /// Overrides text color. Null preserves the current default.
  final Color? textColor;

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
    this.style,
    this.textColor,
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
            Expanded(
              child: GtText(
                text,
                style: GtTextStyleOverrides.resolve(
                  style,
                  context.textStyles.subHeadS(),
                  textColor,
                ),
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
class GtIconListTile extends GtStatelessWidget {
  /// The primary title text.
  final String title;

  /// The secondary text displayed below the title.
  final String? subtitle;

  /// The icon displayed at the start of the tile.
  ///
  /// Ignored when [leading] is provided. One of [icon] or [leading] is
  /// required.
  final IconData? icon;

  /// Optional custom color for the [icon].
  final Color? iconColor;

  /// A widget rendered at the start of the tile in place of [icon].
  ///
  /// Use this when the icon needs to carry its own [GtIconVariant] or other
  /// styling that [icon] and [iconColor] cannot express, e.g.
  /// `GtIcon(myIcon, variant: .soft)`.
  final Widget? leading;

  /// Vertical alignment of the row's children. Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment? crossAxisAlignment;

  /// The callback triggered when the tile is tapped.
  ///
  /// Null renders a static row with no [GtInkWell] and no semantic role, so
  /// an informational tile is not announced as a button. Matches
  /// [GtBaseListTileTemplate].
  final OnPressed? onTap;

  /// Optional vertical spacing override.
  final double? verticalSpacing;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Creates a [GtIconListTile].
  const GtIconListTile(
    this.title, {
    super.key,
    this.subtitle,
    this.icon,
    this.leading,
    this.crossAxisAlignment,
    this.iconColor,
    this.onTap,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
    this.trailing,
    this.titleStyle,
    this.subtitleStyle,
  }) : assert(
         icon != null || leading != null,
         'Either icon or leading must be provided.',
       );

  /// Creates a [GtIconListTile].
  const factory GtIconListTile.alt(
    String title, {
    Key? key,
    String? subtitle,
    IconData? icon,
    Widget? leading,
    CrossAxisAlignment? crossAxisAlignment,
    OnPressed? onTap,
    Widget? trailing,
    double? verticalSpacing,
    double? horizontalSpacing,
    EdgeInsetsGeometry? padding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  }) = _GtIconListTileAlt;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    Widget? lead = leading;

    if (icon case IconData data) {
      lead ??= GtIcon.withColor(
        data,
        size: context.dp(24.px),
        color: iconColor,
      );
    }

    final child = Padding(
      padding: padding ?? context.insets.symmetricDp(vertical: 12.px),
      child: Row(
        spacing: horizontalSpacing ?? context.spacingMd,
        crossAxisAlignment: crossAxisAlignment ?? .start,
        children: [
          ?lead,
          Expanded(
            child: Column(
              spacing: verticalSpacing ?? context.spacingSm,
              crossAxisAlignment: .start,
              children: [
                GtText(
                  title,
                  style: titleStyle ?? context.textStyles.subHeadS(),
                ),
                if (subtitle.hasValue)
                  GtText(
                    subtitle,
                    style:
                        subtitleStyle ??
                        context.textStyles.bodyXs(color: palette.text.sub),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );

    if (onTap != null) {
      return GtInkWell(
        role: .button,
        borderRadius: context.borderRadius2Xl,
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}

/// A list tile that emphasizes a leading icon alongside a title and subtitle.
class _GtIconListTileAlt extends GtIconListTile {
  /// Creates a [_GtIconListTileAlt].
  const _GtIconListTileAlt(
    super.title, {
    super.key,
    super.subtitle,
    super.icon,
    super.leading,
    super.crossAxisAlignment,
    super.onTap,
    super.trailing,
    super.verticalSpacing,
    super.horizontalSpacing,
    super.padding,
    super.titleStyle,
    super.subtitleStyle,
  }) : super(iconColor: null);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final child = Padding(
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
            child: leading ?? GtIcon(icon!, size: context.dp(24.px)),
          ),
          Expanded(
            child: Column(
              spacing: verticalSpacing ?? 0,
              crossAxisAlignment: .start,
              children: [
                GtText(
                  title,
                  style: titleStyle ?? context.textStyles.bodyM(),
                ),
                if (subtitle.hasValue)
                  GtText(
                    subtitle,
                    style:
                        subtitleStyle ??
                        context.textStyles.bodyXs(color: palette.text.sub),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );

    if (onTap != null) {
      return GtInkWell(
        role: .button,
        borderRadius: context.borderRadius2Xl,
        onTap: onTap,
        child: child,
      );
    }

    return child;
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
