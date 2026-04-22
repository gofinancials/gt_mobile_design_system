import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An outline button component for the Go Tech design system.
///
/// Outline buttons (also known as stroked or bordered buttons) feature a transparent
/// background with a visible border. They are typically used for secondary actions
/// that are important but not the primary focus of the view.
/// It extends [GtButton] to inherit standard sizing, layout, and state management.
class GtOutlineButton extends GtButton {
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
      .destructiveAlt => GtColors.red600.value,
      .secondary => palette.primary.darker,
      _ => color,
    };
  }

  Color _borderColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .black => palette.text.strong,
      .secondary => palette.primary.alpha10,
      .neutral => palette.text.sub,
      .neutralAlt => palette.text.darkerSub,
      .destructive => palette.error.base,
      .destructiveAlt => GtColors.red100.value,
      .away => palette.away.darker,
      .featured => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.base,
      .warning => palette.warning.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.verified.base,
      _ => palette.primary.base,
    };
  }

  Color _bgColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    final color = _borderColor(palette);
    return color.setOpacity(.01);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = _textColor(palette);
    final borderColor = _borderColor(palette);
    final bgColor = _bgColor(palette);
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
          if (isActive(states)) {
            return bgColor;
          }
          return GtColors.transparent.value;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(color: borderColor, width: 2);
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
          size: size,
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
