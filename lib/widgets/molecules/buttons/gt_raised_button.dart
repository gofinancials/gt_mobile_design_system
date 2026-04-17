import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A primary elevated button component for the Go Tech design system.
///
/// This button uses [ElevatedButton] under the hood and provides a prominent
/// visual style suitable for main actions in the application. It extends
/// [GtButtonBase] to inherit standard sizing, layout, and state management.
class GtButton extends GtButtonBase {
  /// The text label displayed on the button.
  final String? text;

  /// The visual style variant of the button, determining its color scheme.
  final GtButtonVariant variant;

  /// An optional icon to display before the button's [text].
  final IconData? leading;

  /// An optional icon to display after the button's [text].
  final IconData? trailing;

  /// Custom padding to apply inside the button, overriding the default size-based padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates a [GtButton].
  const GtButton({
    this.text,
    required super.onPressed,
    super.minSize,
    this.variant = .primary,
    super.size = .large,
    super.color,
    super.isDisabled = false,
    super.isLoading = false,
    this.contentPadding,
    this.leading,
    this.trailing,
    super.alignment,
    super.key,
  });

  Color _textColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    return switch (variant) {
      .white => palette.staticColors.black,
      .secondary => palette.primary.base,
      _ => palette.staticColors.white,
    };
  }

  Color _bgColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.alpha10,
      .destructive => palette.error.base,
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
    final textColor = _textColor(palette);
    final bgColor = _bgColor(palette);
    final focusColor = _focusColor(palette);
    final style = baseStyle(context);

    Widget? leadingIcon;
    Widget? trailingIcon;

    final iconSize = context.dp(16.px);

    if (leading != null) {
      leadingIcon = GtIcon.withColor(
        leading!,
        color: textColor,
        size: iconSize,
        alignment: alignment,
      );
    }

    if (trailing != null) {
      trailingIcon = GtIcon.withColor(
        trailing!,
        color: textColor,
        size: iconSize,
        alignment: alignment,
      );
    }

    Widget child = ElevatedButton(
      style: style.copyWith(
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
        side: WidgetStateProperty.all(BorderSide.none),
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
      child: GtAnimatedFade(
        child1: GtButtonText(
          alignment: alignment,
          text.value,
          disabled: isDisabled,
          icon: leadingIcon,
          trailingIcon: trailingIcon,
          textColor: textColor,
        ),
        child2: GtSpinner(color: textColor),
        showFirst: !isLoading,
      ),
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    return child;
  }
}
