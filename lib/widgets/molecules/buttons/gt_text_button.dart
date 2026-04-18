import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text button component for the Go Tech design system.
///
/// Text buttons have no visible boundary or background by default, making them
/// ideal for less prominent actions, such as "Cancel" or secondary links.
/// It extends [GtButtonBase] to inherit standard sizing and interaction states.
class GtTextButton extends GtButtonBase {
  /// The text label displayed on the button.
  final String? text;

  /// The visual style variant of the button, determining its default color scheme.
  final GtButtonVariant variant;

  /// An optional icon to display before the button's [text].
  final IconData? leading;

  /// An optional icon to display after the button's [text].
  final IconData? trailing;

  /// An optional color to explicitly override the default text and icon color.
  final Color? textColor;

  /// An optional color for a border (Note: typically unused in a standard text button,
  /// but included for API consistency across button types).
  final Color? borderColor;

  /// Custom padding to apply inside the button, overriding the default size-based padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates a [GtTextButton].
  const GtTextButton({
    this.text,
    required super.onPressed,
    super.minSize,
    this.variant = .primary,
    super.size = .large,
    this.textColor,
    this.borderColor,
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
    if (textColor != null) return textColor!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.base,
      .neutral => palette.text.sub,
      .destructive || .destructiveAlt => palette.error.base,
      .away => GtColors.yellow700.value,
      .featured => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.base,
      .warning => palette.warning.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.verified.base,
      _ => palette.text.strong,
    };
  }

  Color _focusColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    final color = _textColor(palette);
    return color.setOpacity(.01);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = _textColor(palette);
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

    Widget child = TextButton(
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (isActive(states)) {
            return focusColor;
          }
          return GtColors.transparent.value;
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
          text.value,
          size: size,
          disabled: isDisabled,
          icon: leadingIcon,
          trailingIcon: trailingIcon,
          textColor: textColor,
          alignment: alignment,
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
