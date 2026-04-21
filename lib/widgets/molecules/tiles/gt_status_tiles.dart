import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list tile that displays an illustration alongside a title and subtitle,
/// often used for onboarding or multi-step processes.
class GtIllustratedStepTile extends GtStatelessWidget {
  /// The path to the SVG illustration displayed at the start of the tile.
  final String illustrationPath;

  /// The primary title text of the step.
  final String title;

  /// The secondary text providing details about the step.
  final String subtitle;

  /// Whether this step has been completed. If true, displays a success checkmark and visually disables the tile.
  final bool isDone;
  final bool _asCard;

  /// Creates a standard [GtIllustratedStepTile].
  const GtIllustratedStepTile({
    super.key,
    required this.illustrationPath,
    required this.title,
    required this.subtitle,
    this.isDone = false,
  }) : _asCard = false;

  /// Creates a [GtIllustratedStepTile] wrapped in a stylized card.
  const GtIllustratedStepTile.card({
    super.key,
    required this.illustrationPath,
    required this.title,
    required this.subtitle,
    this.isDone = false,
  }) : _asCard = true;

  @override
  Widget build(BuildContext context) {
    final textColors = context.palette.text;

    Widget child = Row(
      spacing: context.spacingMd,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtSvg(illustrationPath, height: 36, width: 36, alignment: .topLeft),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GtText(title, style: context.textStyles.subHeadM()),
              GtText(
                subtitle,
                style: context.textStyles.subHeadXs(color: textColors.sub),
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
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        child: child,
      ),
    );
  }
}
