import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An outline button component for the Go Tech design system.
///
/// Outline buttons (also known as stroked or bordered buttons) feature a transparent
/// background with a visible border. They are typically used for secondary actions
/// that are important but not the primary focus of the view.
/// It extends [GtButtonBase] to inherit standard sizing, layout, and state management.
class GtOutlineButton extends GtButtonBase {
  /// The text label displayed on the button.
  final String? text;

  /// The visual style variant of the button, determining its border and text color scheme.
  final GtButtonVariant variant;

  /// An optional icon to display before the button's [text].
  final IconData? leading;

  /// An optional icon to display after the button's [text].
  final IconData? trailing;

  /// Custom padding to apply inside the button, overriding the default size-based padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates a [GtOutlineButton].
  const GtOutlineButton({
    this.text,
    required super.onPressed,
    super.minSize,
    this.variant = .white,
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
    final color = _borderColor(palette);
    return switch (variant) {
      .secondary => palette.primary.base,
      _ => color,
    };
  }

  Color _borderColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.alpha10,
      .destructive => palette.error.base,
      _ => palette.primary.base,
    };
  }

  Color _bgColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    final color = _borderColor(palette);
    return color.setOpacity(0.2);
  }

  Color _focusColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.alpha16,
      .destructive => palette.error.dark,
      _ => palette.primary.dark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = _textColor(palette);
    final borderColor = _borderColor(palette);
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
      );
    }

    if (trailing != null) {
      trailingIcon = GtIcon.withColor(
        trailing!,
        color: textColor,
        size: iconSize,
      );
    }

    Widget child = OutlinedButton(
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.containsAll([
            WidgetState.hovered,
            WidgetState.pressed,
            WidgetState.focused,
          ])) {
            return bgColor;
          }
          return GtColors.transparent.value;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          Color color = borderColor;
          if (states.containsAll([
            WidgetState.hovered,
            WidgetState.pressed,
            WidgetState.focused,
          ])) {
            color = focusColor;
          }
          return BorderSide(color: color, width: 2);
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
