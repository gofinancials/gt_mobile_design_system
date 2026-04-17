import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized text widget for use within Go Tech buttons.
///
/// This widget handles the layout of text with optional leading and trailing icons,
/// applies the standard button text style, and adjusts its appearance based on
/// the [disabled] state.
class GtButtonText extends GtStatelessWidget {
  /// An optional widget (typically an icon) to display before the text.
  final Widget? icon;

  /// An optional widget (typically an icon) to display after the text.
  final Widget? trailingIcon;

  /// The text string to display.
  final String text;

  /// An optional text decoration to apply.
  final TextDecoration? decoration;

  /// The alignment of the content within the button.
  final AlignmentGeometry? alignment;

  /// Whether the button text should appear in a disabled state.
  final bool disabled;

  /// An optional color to override the default text color.
  final Color? textColor;

  /// An optional color to override the default disabled text color.
  final Color? disabledTextColor;

  /// Creates a [GtButtonText] widget.
  const GtButtonText(
    this.text, {
    super.key,
    required this.disabled,
    this.alignment = Alignment.center,
    this.icon,
    this.trailingIcon,
    this.decoration,
    this.textColor,
    this.disabledTextColor,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle btnStyle = context.textStyles.buttonM(color: textColor, decorationColor: textColor);

    if (disabled) {
      final disabledColor = disabledTextColor ?? context.palette.text.disabled;
      btnStyle = btnStyle.copyWith(
        color: disabledColor,
        decoration: decoration,
        decorationColor: disabledColor,
      );
    }

    if (icon != null || trailingIcon != null) {
      return _ButtonTextWithIcon(
        text: text,
        alignment: alignment,
        style: btnStyle,
        leadingIcon: icon,
        trailingIcon: trailingIcon,
      );
    }
    return _ButtonText(text: text, style: btnStyle);
  }
}

/// A private widget that lays out button text with icons.
class _ButtonTextWithIcon extends GtStatelessWidget {
  /// The text to display.
  final String? text;

  /// The text style to apply.
  final TextStyle? style;

  /// The icon to display before the text.
  final Widget? leadingIcon;

  /// The icon to display after the text.
  final Widget? trailingIcon;

  /// The alignment for the row of content.
  final AlignmentGeometry? alignment;

  /// Creates a [_ButtonTextWithIcon].
  const _ButtonTextWithIcon({
    required this.text,
    this.alignment,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (text.hasValue) {
      child = _ButtonText(text: text!, style: style);
    }

    child = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          _ButtonIconContainer(leadingIcon),
          if (child != null || trailingIcon != null) const GtGap.hMd(),
        ],
        ?child,
        if (trailingIcon != null) ...[
          if (child != null || leadingIcon != null) const GtGap.hMd(),
          _ButtonIconContainer(trailingIcon),
        ],
      ],
    );

    if (alignment != null) {
      child = Align(alignment: alignment!, child: child);
    }

    return child;
  }
}

/// A private widget that wraps a button icon, constraining it to a square size.
class _ButtonIconContainer extends GtStatelessWidget {
  /// The icon widget to display.
  final Widget? icon;

  /// Creates a [_ButtonIconContainer].
  const _ButtonIconContainer(this.icon);

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const Offstage();
    return GtSquareBox(size: 20, child: FittedBox(child: icon));
  }
}

/// A private widget that displays the core button text, applying scaling and styling.
class _ButtonText extends GtStatelessWidget {
  /// The text string.
  final String text;

  /// The style to apply to the text.
  final TextStyle? style;

  /// Creates a [_ButtonText].
  const _ButtonText({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GtText(
        text.upper,
        textAlign: TextAlign.center,
        style: style,
        maxLines: 1,
      ),
    );
  }
}
