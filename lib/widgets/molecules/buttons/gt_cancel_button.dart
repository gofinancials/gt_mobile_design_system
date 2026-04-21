import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized cancel button component for the Go Tech design system.
///
/// This widget displays a cancel (cross) icon and provides built-in navigation
/// pop functionality, haptic feedback, and optional Hero transition support.
class GtCancelButton extends GtStatelessWidget {
  /// An optional callback executed immediately when the button is tapped,
  /// before [onTap] or the default pop navigation.
  final OnPressed? subAction;

  /// An optional callback that overrides the default [Navigator.pop] behavior.
  final OnPressed? onTap;

  /// The alignment of the cancel icon within its bounding box. Defaults to [Alignment.centerRight].
  final AlignmentGeometry alignment;

  /// The size of the cancel icon in logical pixels. Defaults to 24.
  final double size;

  /// Whether the button should be wrapped in a [Hero] widget for transition animations.
  final bool asHero;

  /// Indicates whether the button should use primary thematic styling.
  ///
  /// *Note: This property is declared but currently unused in the standard build method.*
  final bool primary;

  /// An optional custom color to override the default color of the cancel icon.
  final Color? color;

  /// Creates a [GtCancelButton].
  const GtCancelButton({
    super.key,
    this.subAction,
    this.onTap,
    this.alignment = Alignment.centerRight,
    this.size = 24,
    this.asHero = false,
    this.primary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (subAction != null) {
          subAction!();
        }
        if (onTap != null) {
          return onTap!();
        }
        Navigator.of(context).pop();
      },
      child: GtIcon.withColor(
        GtIcons.cancel,
        size: context.dp(size.px),
        alignment: alignment,
        color: color,
      ),
    );

    if (asHero) {
      child = Material(
        type: MaterialType.transparency,
        child: Hero(tag: "app-cancel-button-hero", child: child),
      );
    }

    return child;
  }
}
