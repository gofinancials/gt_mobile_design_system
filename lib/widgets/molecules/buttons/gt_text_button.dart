import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text button component for the Go Tech design system.
///
/// Text buttons have no visible boundary or background by default, making them
/// ideal for less prominent actions, such as "Cancel" or secondary links.
/// It extends [GtButton] to inherit standard sizing and interaction states.
class GtTextButton extends GtButton {
  /// The text label displayed on the button.
  final String? text;

  /// The visual style variant of the button, determining its default color scheme.
  final GtButtonVariant variant;

  /// An optional icon to display before the button's [text].
  final IconData? leading;

  /// An optional icon to display after the button's [text].
  final IconData? trailing;

  /// An optional color for a border (Note: typically unused in a standard text button,
  /// but included for API consistency across button types).
  final Color? borderColor;

  /// Custom padding to apply inside the button, overriding the default size-based padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional text style to override the default button text style.
  final TextStyle? style;

  /// Optional text alignment to override the default button text alignment.
  final TextAlign textAlign;

  /// Defines the text capitalization behavior for the button text.
  final GtButtonTextCase textCase;

  /// Creates a [GtTextButton].
  const GtTextButton({
    this.text,
    required super.onPressed,
    super.minSize,
    this.variant = .primary,
    super.size = .large,
    super.textColor,
    this.borderColor,
    super.isDisabled = false,
    super.isLoading = false,
    super.enableScaleEffect = true,
    super.pressedScale,
    super.enableLabelAnimation = true,
    this.textAlign = .center,
    this.contentPadding,
    this.leading,
    this.trailing,
    super.alignment,
    super.semanticLabel,
    super.loadingSemanticLabel,
    this.textCase = .upper,
    this.style,
    super.focusColor,
    super.cornerRadius,
    super.key,
  });

  @override
  EdgeInsetsGeometry padding(BuildContext context) {
    if (contentPadding != null) return contentPadding!;
    return super.padding(context);
  }

  Color _textColor(GtPalette palette) {
    if (isDisabled) return palette.text.disabled;
    if (textColor != null) return textColor!;
    return switch (variant) {
      .white => palette.staticColors.white,
      .secondary => palette.primary.darker,
      .neutral => palette.text.sub,
      .neutralAlt => palette.text.darkerSub,
      .destructive || .destructiveAlt => palette.error.base,
      .away => palette.away.darker,
      .featured => palette.feature.dark,
      .featuredAlt => palette.feature.base,
      .info => palette.information.base,
      .success => palette.success.base,
      .warning => palette.warning.base,
      .highlighted => palette.highlighted.base,
      .stable => palette.stable.base,
      .verified => palette.verified.base,
      .black => palette.text.strong,
      _ => palette.text.strong,
    };
  }

  Color _focusColor(GtPalette palette) {
    if (isDisabled) return palette.bg.weak;
    if (focusColor != null) return focusColor!;
    final color = _textColor(palette);
    return color.setOpacity(.01);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textColor = _textColor(palette);
    final focusColor = _focusColor(palette);
    final textStyle = this.style;
    final style = baseStyle(context);

    Widget? leadingIcon;
    Widget? trailingIcon;

    final iconSize = context.dp(16.px);

    if (leading != null) {
      leadingIcon = ExcludeSemantics(
        child: GtIcon.withColor(leading!, color: textColor, size: iconSize),
      );
    }

    if (trailing != null) {
      trailingIcon = ExcludeSemantics(
        child: GtIcon.withColor(trailing!, color: textColor, size: iconSize),
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
          textCase: textCase,
          size: size,
          disabled: isDisabled,
          icon: leadingIcon,
          trailingIcon: trailingIcon,
          textColor: textColor,
          alignment: alignment,
          style: textStyle,
          textAlign: textAlign,
          animateChanges: enableLabelAnimation,
        ),
        child2: GtSpinner(color: textColor),
        showFirst: !isLoading,
      ),
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    if (computedSemanticLabel != null) {
      child = Semantics(
        label: computedSemanticLabel,
        button: true,
        excludeSemantics: true,
        child: child,
      );
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
