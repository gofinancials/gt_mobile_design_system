import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GtIconButton extends GtButtonBase {
  final String iconPath;
  final GtButtonVariant variant;
  final Widget? leading;
  final EdgeInsetsGeometry? contentPadding;

  const GtIconButton({
    required this.iconPath,
    required super.onPressed,
    super.minSize,
    this.variant = .primary,
    super.size = .large,
    this.leading,
    super.color,
    super.isDisabled = false,
    super.isLoading = false,
    this.contentPadding,
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
    if (isDisabled) return palette.icon.disabled;
    if (color != null) return color!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.base,
      .destructive => palette.error.base,
      _ => palette.icon.strong,
    };
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
    final iconColor = _iconColor(palette);
    final focusColor = _focusColor(palette);
    final style = baseStyle(context);

    Widget child = IconButton(
      icon: Center(
        child: GtSquareBox(
          size: 20,
          child: FittedBox(
            child: GtAnimatedFade(
              child1: GtSvg(iconPath, color: iconColor),
              child2: GtSpinner(color: iconColor),
              showFirst: !isLoading,
            ),
          ),
        ),
      ),
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.containsAll([
            WidgetState.hovered,
            WidgetState.pressed,
            WidgetState.focused,
          ])) {
            return iconColor.setOpacity(.16);
          }
          return GtColors.transparent.value;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          Color color = iconColor;
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
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    return child;
  }
}
