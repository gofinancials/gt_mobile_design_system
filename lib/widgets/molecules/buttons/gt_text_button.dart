import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GtTextButton extends GtButtonBase {
  final String? text;
  final GtButtonVariant variant;
  final Widget? leading;
  final String? icon;
  final String? trailingIcon;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;

  const GtTextButton({
    this.text,
    required super.onPressed,
    super.minSize,
    this.variant = .primary,
    super.size = .large,
    this.icon,
    this.leading,
    this.textColor,
    this.borderColor,
    super.isDisabled = false,
    super.isLoading = false,
    this.contentPadding,
    this.trailingIcon,
    super.alignment,
    super.key,
  });

  Color _textColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    if (textColor != null) return textColor!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.base,
      .destructive => palette.error.base,
      _ => palette.text.strong,
    };
  }

  Color _focusColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (textColor != null) return textColor!.setOpacity(.16);
    return switch (variant) {
      .white => palette.staticColors.white.setOpacity(.16),
      .secondary => palette.primary.alpha16,
      .destructive => palette.error.lighter,
      _ => palette.bg.soft,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = _textColor(palette);
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

    Widget child = TextButton(
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.containsAll([
            WidgetState.hovered,
            WidgetState.pressed,
            WidgetState.focused,
          ])) {
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
          disabled: isDisabled,
          icon: leading,
          trailingIcon: trailing,
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
