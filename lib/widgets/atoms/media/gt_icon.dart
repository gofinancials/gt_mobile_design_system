import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized icon widget for the Go Tech design system.
///
/// This widget wraps the standard Flutter [Icon] to provide consistent sizing,
/// semantic colors based on [GtIconVariant], and optional alignment handling.
class GtIcon extends GtStatelessWidget {
  /// The icon data to display (e.g., [Icons.home]).
  final IconData icon;

  /// The size of the icon in logical pixels.
  ///
  /// If null, defaults to 20dp scaled appropriately for the device screen density.
  final double? size;

  /// An optional list of shadows cast by the icon.
  final List<Shadow>? shadows;

  /// How to align the icon within its bounding box.
  ///
  /// If provided, the icon is wrapped in an [Align] widget.
  final AlignmentGeometry? alignment;

  /// A semantic label for the icon, used by screen readers and accessibility tools.
  final String? semanticsLabel;

  /// The internal variant defining the semantic color of the icon.
  final GtIconVariant _variant;

  /// The internal explicit color, used only if instantiated via [GtIcon.withColor].
  final Color? _color;

  /// Creates a [GtIcon] using a semantic color [variant].
  ///
  /// The [variant] defaults to [GtIconVariant.strong]. This is the preferred
  /// method for creating icons within the design system to ensure consistency.
  const GtIcon(
    this.icon, {
    super.key,
    this.size,
    this.shadows,
    this.alignment,
    GtIconVariant variant = GtIconVariant.strong,
    this.semanticsLabel,
  }) : _color = null,
       _variant = variant;

  /// Creates a [GtIcon] with an explicit custom [color].
  ///
  /// This overrides the standard semantic design system colors. It should be
  /// used sparingly when strict brand or custom colors are required.
  const GtIcon.withColor(
    this.icon, {
    super.key,
    this.size,
    this.shadows,
    this.alignment,
    Color? color,
    this.semanticsLabel,
  }) : _variant = GtIconVariant.strong,
       _color = color;

  @override
  Widget build(BuildContext context) {
    Color? iconColor = _color ?? _variant.getIconColor(context);
    final iconSize = context.dp(20.px);

    Widget child = Icon(
      icon,
      size: size ?? iconSize,
      color: iconColor,
      semanticLabel: semanticsLabel,
      shadows: shadows,
    );
    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }
    return child;
  }
}
