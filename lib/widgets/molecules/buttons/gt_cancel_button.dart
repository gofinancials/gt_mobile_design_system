import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the standard sizes available for Go Tech cancel button.
enum GtCancelButtonSize {
  /// A medium cancel button with a baseline height of 16.
  xSmall(16),

  /// A medium cancel button with a baseline height of 20.
  small(20),

  /// A medium cancel button with a baseline height of 24.
  medium(24),

  /// A large cancel button with a baseline height of 32.
  large(32),

  /// A large cancel button with a baseline height of 32.
  xLarge(36);

  const GtCancelButtonSize(this.value);

  /// The baseline height value in logical pixels.
  final double value;
}

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
  final GtCancelButtonSize size;

  /// Whether the button should be wrapped in a [Hero] widget for transition animations.
  final bool asHero;

  /// An optional custom color to override the default color of the cancel icon.
  final Color? color;

  /// Creates a [GtCancelButton].
  const GtCancelButton({
    super.key,
    this.subAction,
    this.onTap,
    this.alignment = .centerRight,
    this.size = .large,
    this.asHero = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cubeSize = context.dp(size.value.px);
    final iconSize = switch (size) {
      .xSmall => context.dp(10.px),
      .small => context.dp(12.px),
      .medium => context.dp(14.px),
      .large => context.dp(16.px),
      _ => context.dp(20.px),
    };

    Widget child = GtInkWell(
      onTap: () {
        if (subAction != null) subAction!();
        if (onTap != null) return onTap!();
        if (!context.canPop) return;

        context.maybePop();
      },
      child: GtSquareConstrainedBox(
        cubeSize,
        child: GtIcon.withColor(GtIcons.cancel, size: iconSize, color: color),
      ),
    );

    if (asHero) {
      child = Material(
        type: MaterialType.transparency,
        child: Hero(tag: "app-cancel-button-hero", child: child),
      );
    }

    return Align(alignment: alignment, child: child);
  }
}
