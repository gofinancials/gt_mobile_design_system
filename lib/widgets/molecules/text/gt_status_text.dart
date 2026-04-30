import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Access levels surfaced as a compact **icon + label** row (e.g. permissions,
/// feature gates, shared-resource visibility).
///
/// Defaults map each [GtAccessStatus] to a [GtIcons] glyph and
/// [GtIconVariant] so color tracks the design-system semantic palette. Hosts
/// can override [label], [icon], or [iconVariant] for localization or one-off
/// product copy.
enum GtAccessStatus {
  /// Full permissions to the underlying resource or surface.
  fullAccess,

  /// No permissions; the resource is locked or unavailable to this actor.
  noAccess,

  /// Read-only or similarly limited access (e.g. view without edit).
  viewOnly,
}

extension _GtAccessStatusDefaults on GtAccessStatus {
  /// Product-default English label before [GtText] applies uppercase styling.
  String get _defaultLabel => switch (this) {
    .fullAccess => 'Full access',
    .noAccess => 'No access',
    .viewOnly => 'View only',
  };

  IconData get _defaultIcon => switch (this) {
    .fullAccess => GtIcons.shieldCheck,
    .noAccess => GtIcons.lock,
    .viewOnly => GtIcons.hide,
  };

  Color get _defaultColor => switch (this) {
    .fullAccess => GtColors.green500.value,
    .noAccess || .viewOnly => GtColors.neutral500.value,
  };

  GtIconVariant get _defaultIconVariant => switch (this) {
    .fullAccess => .success,
    .noAccess || .viewOnly => .sub,
  };
}

/// Single-line status row: leading status [icon] and uppercase status [label].
///
/// Prefer passing [status] alone for standard access cases; use [label] when
/// copy must differ from the default (e.g. translations). Layout and spacing
/// follow the same row conventions as [GtStatusListTile] (base spacing, 24px
/// icon target).
class GtStatusText extends GtStatelessWidget {
  /// Which access case to represent; drives default icon, color, and label.
  final GtAccessStatus status;

  /// Optional override for the visible status string.
  ///
  /// When `null`, a default English label for [status] is used.
  final String? label;

  /// Optional override for the leading glyph.
  ///
  /// When `null`, a default [GtIcons] value for [status] is used.
  final IconData? icon;

  /// Optional override for semantic icon coloring.
  ///
  /// When `null`, a default [GtIconVariant] for [status] is used.
  final GtIconVariant? iconVariant;

  /// Logical size of the leading icon; defaults to **18** when `null`.
  final double? iconSize;

  /// Creates a [GtStatusText] for the given [GtAccessStatus].
  const GtStatusText({
    super.key,
    required this.status,
    this.label,
    this.icon,
    this.iconVariant,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedLabel = label ?? status._defaultLabel;
    final resolvedIcon = icon ?? status._defaultIcon;
    final resolvedVariant = iconVariant ?? status._defaultIconVariant;
    final resolvedColor = status._defaultColor;

    return Row(
      mainAxisAlignment: .start,
      mainAxisSize: .max,
      spacing: context.spacingBase,
      children: [
        if (iconVariant == null)
          GtIcon.withColor(
            resolvedIcon,
            size: iconSize ?? 18,
            color: resolvedColor,
          )
        else
          GtIcon(resolvedIcon, size: iconSize ?? 18, variant: resolvedVariant),
        Expanded(
          child: GtText(
            resolvedLabel,
            style: context.textStyles.subHead2xs(color: resolvedColor),
          ),
        ),
      ],
    );
  }
}
