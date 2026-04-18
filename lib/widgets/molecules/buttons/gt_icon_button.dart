import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum GtIconButtonShape { square, round }

/// An icon-only button component for the Go Tech design system.
///
/// This button displays a single icon without text. It automatically
/// constrains its size to a square based on the specified [GtButtonSize] and
/// manages hover, pressed, and focused states. It extends [GtButtonBase] to
/// inherit standard sizing and interaction logic.
class GtIconButton extends GtButtonBase {
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

  final GtIconButtonShape shape;

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
    super.key,
  });

  @override
  Size minimumSize(BuildContext context) {
    return Size.square(0);
  }

  @override
  Size maximumSize(BuildContext context) {
    final height = buttonHeight(context) + 4;
    return Size.square(height);
  }

  @override
  EdgeInsetsGeometry padding(BuildContext context) {
    final i = context.insets;
    return i.zero;
  }

  Color _iconColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    return switch (variant) {
      .white => palette.staticColors.black,
      .secondary => palette.primary.base,
      .neutral => palette.text.strong,
      .stable => palette.icon.sub,
      .destructiveAlt => GtColors.red600.value,
      _ => palette.staticColors.white,
    };
  }

  Color _bgColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.alpha10,
      .neutral => palette.bg.soft,
      .destructive => palette.error.base,
      .destructiveAlt => GtColors.red100.value,
      .away => GtColors.yellow700.value,
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

  Color _focusColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.alpha16,
      .destructive => palette.error.dark,
      _ => palette.primary.darker,
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
      _ => 20.0,
    };

    Widget child = IconButton(
      icon: GtAnimatedFade(
        child1: GtIcon.withColor(
          icon,
          color: iconColor,
          size: iconSize,
          alignment: alignment,
          weight: 1,
        ),
        child2: GtSpinner(color: iconColor),
        showFirst: !isLoading,
      ),
      alignment: alignment,
      style: style.copyWith(
        shape: WidgetStateProperty.resolveWith((_) {
          return switch (shape) {
            GtIconButtonShape.square => RoundedRectangleBorder(
              borderRadius: context.borderRadiusXl,
            ),
            GtIconButtonShape.round => const CircleBorder(),
          };
        }),
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
