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

  /// Custom size for the [leading] and [trailing] icons, in logical pixels,
  /// overriding the default size-based icon size.
  final double? iconSize;

  /// Custom gap between the [leading] and [trailing] icons and the [text], in
  /// logical pixels, overriding the default spacing.
  final double? iconSpacing;

  /// Optional text style to override the default button text style.
  final TextStyle? style;

  /// Defines the text capitalization behavior for the button text.
  final GtTextCase textCase;

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
    super.enableScaleEffect = true,
    super.pressedScale,
    super.enableLabelAnimation = true,
    this.contentPadding,
    this.iconSize,
    this.iconSpacing,
    this.leading,
    this.trailing,
    super.alignment,
    super.textColor,
    super.focusColor,
    super.cornerRadius,
    this.textCase = .upper,
    this.style,
    super.key,
  });

  /// Determines the label and icon color, which follows the border color
  /// except on a few variants, unless a custom [textColor] is provided.
  Color _textColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    if (textColor != null) return textColor!;
    final color = _borderColor(palette);
    return switch (variant) {
      .destructiveAlt => GtColors.red600.value,
      .secondary => palette.primary.darker,
      _ => color,
    };
  }

  /// Determines the border color based on the button's [variant] and
  /// [isDisabled] state, unless a custom [color] is provided.
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
      .featured || .featuredAlt => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.base,
      .warning => palette.warning.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.verified.base,
      _ => palette.primary.base,
    };
  }

  /// Determines the faint background tint shown in focus, hover and pressed
  /// states, derived from the border color.
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
    final btnStyle = baseStyle(context);

    Widget? leadingIcon;
    Widget? trailingIcon;

    final iconSize = this.iconSize ?? context.dp(16.px);

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
      style: btnStyle.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (isActive(states)) {
            return focusColor ?? bgColor;
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
          animateChanges: enableLabelAnimation,
          style: style,
          textCase: textCase,
          iconSize: this.iconSize,
          iconSpacing: iconSpacing,
        ),
        child2: GtSpinner(color: textColor),
        showFirst: !isLoading,
      ),
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    child = GtPressable(
      enabled: enableScaleEffect && !isDisabled && !isLoading,
      pressedScale: pressedScale,
      child: child,
    );

    if (needsMinimumTapTarget) {
      child = GtTapTarget(child: child);
    }

    return child;
  }
}
