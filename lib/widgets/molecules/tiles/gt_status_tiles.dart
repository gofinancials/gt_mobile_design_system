import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile that displays an illustration alongside a title and subtitle,
/// often used for onboarding or multi-step processes.
class GtIllustratedStepTile extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

  /// The illustration image data displayed at the start of the tile.
  final AppImageData illustration;

  /// The primary title text of the step.
  final String title;

  /// The secondary text providing details about the step.
  final String subtitle;

  /// Whether this step has been completed. If true, displays a success checkmark and visually disables the tile.
  final bool isDone;

  /// Whether the tile should be rendered inside a [GtCard].
  final bool _asCard;

  /// An optional custom width and height for the leading [illustration].
  final double? illustrationSize;

  /// An optional custom text style for the [title].
  final TextStyle? titleStyle;

  /// An optional custom text style for the [subtitle].
  final TextStyle? subtitleStyle;

  /// Optional vertical spacing override.
  final double? verticalSpacing;

  /// Optional horizontal spacing override.
  final double? horizontalSpacing;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a standard [GtIllustratedStepTile].
  const GtIllustratedStepTile({
    super.key,
    required this.illustration,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.illustrationSize,
    this.titleStyle,
    this.subtitleStyle,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  }) : _asCard = false;

  /// Creates a [GtIllustratedStepTile] wrapped in a stylized [GtCard].
  const GtIllustratedStepTile.card({
    super.key,
    required this.illustration,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.illustrationSize,
    this.titleStyle,
    this.subtitleStyle,
    this.verticalSpacing,
    this.horizontalSpacing,
    this.padding,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final textColors = context.palette.text;
    final iconSize = illustrationSize ?? context.dp(36.px);
    final style = context.textStyles;

    Widget child = Row(
      spacing: horizontalSpacing ?? context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtImage(
          image: illustration,
          width: iconSize,
          height: iconSize,
          alignment: .topLeft,
          isDecorative: true,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: verticalSpacing ?? 0,
            children: [
              GtText(
                title,
                style: GtTextStyleOverrides.resolve(
                  titleStyle,
                  style.subHeadM(),
                  titleColor,
                ),
              ),
              GtText(
                subtitle,
                style: GtTextStyleOverrides.resolve(
                  subtitleStyle,
                  style.subHeadXs(color: textColors.sub),
                  subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    child = Row(
      spacing: horizontalSpacing ?? context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
        Visibility(
          visible: isDone,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: GtCheckBox(
            value: true,
            onChanged: (_) {},
            isActive: true,
            shape: GtCheckBoxShape.circle,
            activeColor: context.palette.success.base,
          ),
        ),
      ],
    );

    if (_asCard) {
      child = GtCard(
        color: backgroundColor,
        padding:
            padding ??
            context.insets.symmetricDp(horizontal: 12.px, vertical: 16.px),
        child: child,
      );
    }

    return GtDisabledOverlay(isDone, child: child);
  }
}

/// A list tile that displays an item's status, optionally rendering a footer
/// status pill and a completion checkmark.
class GtStatusListTile extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

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

  /// Overrides trailing spacing in logical pixels. Null preserves the current default.
  final double? trailingSpacing;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides footer spacing in logical pixels. Null preserves the current default.
  final double? footerSpacing;

  /// The icon to display at the start of the tile.
  final IconData icon;

  /// The primary title text.
  final String title;

  /// The secondary descriptive text.
  final String subtitle;

  /// An optional [GtStatusPill] to display below the title and subtitle.
  final GtStatusPill? footer;

  /// Whether the item is completed. If true, displays a success checkmark instead of a chevron and visually disables the tile.
  final bool isDone;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed onPressed;

  /// Optional padding override. Used only when asCard is true
  final EdgeInsetsGeometry? padding;

  final bool _asCard;

  /// Creates a standard [GtStatusListTile].
  const GtStatusListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.footer,
    this.isDone = false,
    this.padding,
    this.backgroundColor,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.horizontalSpacing,
    this.trailingSpacing,
    this.verticalSpacing,
    this.footerSpacing,
  }) : _asCard = false;

  /// Creates a [GtStatusListTile] wrapped in a stylized card.
  const GtStatusListTile.card({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.footer,
    this.isDone = false,
    this.padding,
    this.backgroundColor,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.horizontalSpacing,
    this.trailingSpacing,
    this.verticalSpacing,
    this.footerSpacing,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      spacing: horizontalSpacing ?? context.spacingBase,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtIcon(icon, size: 24),
        Expanded(
          child: Column(
            spacing: verticalSpacing ?? 0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(
                title.upper,
                style: GtTextStyleOverrides.resolve(
                  titleStyle,
                  context.textStyles.h7(),
                  titleColor,
                ),
              ),
              GtText(
                subtitle,
                style: GtTextStyleOverrides.resolve(
                  subtitleStyle,
                  context.textStyles.bodyS(),
                  subtitleColor,
                ),
              ),
              if (footer != null) ...[
                (footerSpacing == null
                    ? const GtGap.yBase()
                    : SizedBox(height: footerSpacing)),
                ?footer,
              ],
            ],
          ),
        ),
      ],
    );

    child = Row(
      spacing: trailingSpacing ?? context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
        if (isDone)
          GtCheckBox(
            value: true,
            onChanged: (_) {},
            isActive: true,
            shape: GtCheckBoxShape.circle,
            activeColor: context.palette.success.base,
          )
        else
          GtIcon(
            GtIcons.chevronRight,
            size: 16,
            alignment: Alignment.centerRight,
            variant: .soft,
          ),
      ],
    );

    if (_asCard) {
      child = GtCard(
        color: backgroundColor,
        padding: padding ?? context.insets.allDp(16.px),
        child: child,
      );
    }

    return GtDisabledOverlay(
      isDone,
      child: GtInkWell(
        role: .button,
        borderRadius: _asCard ? context.borderRadius2Xl : .zero,
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
