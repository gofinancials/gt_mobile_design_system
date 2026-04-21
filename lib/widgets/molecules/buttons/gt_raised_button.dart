import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A primary elevated button component for the Go Tech design system.
///
/// This button uses [ElevatedButton] under the hood and provides a prominent
/// visual style suitable for main actions in the application. It extends
/// [GtButton] to inherit standard sizing, layout, and state management.
class GtRaisedButton extends GtButton {
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

  /// Creates a [GtRaisedButton].
  const GtRaisedButton({
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
      .black => palette.text.white,
      .neutral => palette.text.strong,
      .neutralAlt => palette.text.darkerSub,
      .secondary => palette.primary.darker,
      .destructiveAlt => GtColors.red600.value,
      _ => palette.staticColors.white,
    };
  }

  Color _iconColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    return switch (variant) {
      .neutral => palette.text.disabled,
      _ => _textColor(palette),
    };
  }

  Color _bgColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .black => palette.text.strong,
      .neutral => palette.bg.soft,
      .neutralAlt => palette.bg.soft,
      .secondary => palette.primary.alpha10,
      .destructiveAlt => GtColors.red100.value,
      .destructive => palette.error.base,
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
    final textColor = _textColor(palette);
    final iconColor = _iconColor(palette);
    final bgColor = _bgColor(palette);
    final focusColor = _focusColor(palette);
    final style = baseStyle(context);

    Widget? leadingIcon;
    Widget? trailingIcon;

    final iconSize = context.dp(16.px);

    if (leading != null) {
      leadingIcon = GtIcon.withColor(
        leading!,
        color: iconColor,
        size: iconSize,
        alignment: alignment,
      );
    }

    if (trailing != null) {
      trailingIcon = GtIcon.withColor(
        trailing!,
        color: iconColor,
        size: iconSize,
        alignment: alignment,
      );
    }

    Widget child = ElevatedButton(
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (isActive(states)) {
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
          size: size,
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
