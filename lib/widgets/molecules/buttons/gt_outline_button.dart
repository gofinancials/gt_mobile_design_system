import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GtOutlineButton extends GtButtonBase {
  final String? text;
  final GtButtonVariant variant;
  final Widget? leading;
  final String? icon;
  final String? trailingIcon;
  final EdgeInsetsGeometry? contentPadding;

  const GtOutlineButton({
    this.text,
    required super.onPressed,
    super.minSize,
    this.variant = .primary,
    super.size = .large,
    this.icon,
    this.leading,
    super.color,
    super.isDisabled = false,
    super.isLoading = false,
    this.contentPadding,
    this.trailingIcon,
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

    Widget? leading = this.leading;
    Widget? trailing;

    final iconSize = context.dp(20.px);

    if (icon != null) {
      leading = GtSvg(
        icon!,
        color: textColor,
        height: iconSize,
        width: iconSize,
      );
    }

    if (trailingIcon != null) {
      trailing = GtSvg(
        trailingIcon!,
        color: textColor,
        height: iconSize,
        width: iconSize,
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
          icon: isLoading ? const GtSpinner() : leading,
          trailingIcon: trailing,
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
