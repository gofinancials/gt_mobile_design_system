import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Defines the shape of a [GtIconButton].
enum GtIconButtonShape {
  /// A button with squared corners, respecting the theme's border radius.
  square,

  /// A perfectly circular button.
  round,
}

/// An icon-only button component for the Go Tech design system.
///
/// This button displays a single icon without text. It automatically
/// constrains its size to a square based on the specified [GtButtonSize] and
/// manages hover, pressed, and focused states. It extends [GtButton] to
/// inherit standard sizing and interaction logic.
class GtIconButton extends GtButton {
  /// The icon to display inside the button.
  final IconData icon;

  /// The visual style variant of the button, determining its color scheme.
  final GtButtonVariant variant;

  /// An optional custom widget.
  ///
  /// *Note: This property is declared but currently unused in the standard build method.*
  final Widget? leading;

  /// Custom padding to apply inside the button, overriding the default zero padding.
  final EdgeInsetsGeometry? contentPadding;

  /// The shape of the button, either square or round.
  /// Defaults to [GtIconButtonShape.round].
  final GtIconButtonShape shape;

  final Gradient? gradient;

  /// Creates a [GtIconButton].
  const GtIconButton({
    required this.icon,
    required super.onPressed,
    super.minSize,
    this.variant = .stable,
    super.size = .large,
    this.leading,
    super.color,
    super.isDisabled = false,
    super.isLoading = false,
    this.contentPadding,
    this.shape = .round,
    super.alignment,
    this.gradient,
    super.key,
  });

  @override
  /// Overrides the base implementation to set a minimum size of zero, as the
  /// size is constrained by [maximumSize] to create a square shape.
  Size minimumSize(BuildContext context) {
    return Size.square(0);
  }

  @override
  /// Overrides the base implementation to enforce a square shape based on the
  /// button's calculated height. A small adjustment is added for visual balance.
  Size maximumSize(BuildContext context) {
    final height = buttonHeight;
    return Size.square(height);
  }

  @override
  /// Overrides the base implementation to remove default horizontal padding,
  /// as this is an icon-only button where content is centered.
  EdgeInsetsGeometry padding(BuildContext context) {
    return context.insets.zero;
  }

  /// Determines the icon color based on the button's [variant] and [isDisabled]
  /// state.
  Color _iconColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    return switch (variant) {
      .white => palette.staticColors.black,
      .black => palette.text.white,
      .secondary => palette.primary.dark,
      .neutral => palette.text.strong,
      .neutralAlt => palette.text.darkerSub,
      .stable => palette.icon.sub,
      .away => palette.text.white,
      .destructiveAlt => GtColors.red600.value,
      _ => palette.staticColors.white,
    };
  }

  /// Determines the background color based on the button's [variant], [isDisabled]
  /// state, and whether a custom [color] is provided.
  Color _bgColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .black => palette.text.strong,
      .secondary => palette.primary.alpha10,
      .neutral => palette.bg.soft,
      .neutralAlt => palette.bg.soft,
      .destructive => palette.error.base,
      .destructiveAlt => GtColors.red100.value,
      .away => palette.away.darker,
      .featured => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.base,
      .warning => palette.warning.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.bg.weak,
      .verified => palette.verified.base,
      _ => palette.primary.base,
    };
  }

  /// Determines the background color for focus/hover/pressed states based on
  /// the button's [variant] and [isDisabled] state.
  Color _focusColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    final color = _bgColor(palette);
    return switch (variant) {
      .primary => palette.primary.dark,
      .neutral => palette.bg.sub,
      .neutralAlt => palette.bg.sub,
      .secondary => palette.primary.alpha16,
      .destructiveAlt => GtColors.red200.value,
      .destructive => palette.error.dark,
      .away => GtColors.yellow800.value,
      .featured => palette.feature.dark,
      .info => palette.information.dark,
      .success => palette.success.dark,
      .warning => palette.warning.dark,
      .highlighted => palette.highlighted.dark,
      .stable => palette.stable.dark,
      .verified => palette.verified.dark,
      _ => color,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = _iconColor(palette);
    final bgColor = _bgColor(palette);
    final focusColor = _focusColor(palette);
    final style = baseStyle(context);
    final iconSize = switch (size) {
      .pill => 12.0,
      .xsmall => 14.0,
      .small => 16.0,
      .medium => 22.0,
      _ => 24.0,
    };

    Widget child = IconButton(
      icon: GtAnimatedFade(
        child1: GtIcon.withColor(
          icon,
          color: iconColor,
          size: iconSize,
          alignment: .center,
        ),
        child2: GtSpinner(color: iconColor),
        showFirst: !isLoading,
      ),
      alignment: alignment,
      style: style.copyWith(
        shape: WidgetStateProperty.resolveWith((states) {
          return switch (shape) {
            GtIconButtonShape.square => style.shape?.resolve(states),
            GtIconButtonShape.round => const CircleBorder(),
          };
        }),
        backgroundBuilder: (context, states, child) {
          if (gradient == null) return child ?? const Offstage();
          final background = DecoratedBox(
            decoration: BoxDecoration(gradient: gradient),
            child: child,
          );
          return switch (shape) {
            .round => ClipOval(child: background),
            _ => ClipRRect(
              borderRadius: borderRadius(context),
              child: background,
            ),
          };
        },
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.containsAll([
            WidgetState.hovered,
            WidgetState.pressed,
            WidgetState.focused,
          ])) {
            return focusColor;
          }
          return bgColor;
        }),
        padding: WidgetStatePropertyAll(contentPadding ?? padding(context)),
      ),
      onPressed: isDisabled
          ? null
          : () {
              if (isLoading) return;
              HapticFeedback.mediumImpact();
              context.resetFocus();
              onPressed();
            },
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    return child;
  }
}
