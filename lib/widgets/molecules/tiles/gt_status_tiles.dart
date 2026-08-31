import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile that displays an illustration alongside a title and subtitle,
/// often used for onboarding or multi-step processes.
class GtIllustratedStepTile extends GtStatelessWidget {
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
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final textColors = context.palette.text;
    final iconSize = illustrationSize ?? context.dp(36.px);
    final style = context.textStyles;

    Widget child = Row(
      spacing: context.spacingMd,
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
            children: [
              GtText(title, style: titleStyle ?? style.subHeadM()),
              GtText(
                subtitle,
                style: subtitleStyle ?? style.subHeadXs(color: textColors.sub),
              ),
            ],
          ),
        ),
      ],
    );

    child = Row(
      spacing: context.spacingMd,
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
        padding: context.insets.symmetricDp(horizontal: 12.px, vertical: 16.px),
        child: child,
      );
    }

    return GtDisabledOverlay(isDone, child: child);
  }
}

/// A list tile that displays an item's status, optionally rendering a footer
/// status pill and a completion checkmark.
class GtStatusListTile extends GtStatelessWidget {
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
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      spacing: context.spacingBase,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtIcon(icon, size: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(title.upper, style: context.textStyles.h7()),
              GtText(subtitle),
              if (footer != null) ...[GtGap.yBase(), ?footer],
            ],
          ),
        ),
      ],
    );

    child = Row(
      spacing: context.spacingMd,
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
      child = GtCard(padding: context.insets.allDp(16.px), child: child);
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
