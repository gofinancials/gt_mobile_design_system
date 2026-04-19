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

  /// The size category of the button, which determines the text style and icon scaling.
  final GtButtonSize size;

  /// Creates a [GtButtonText] widget.
  const GtButtonText(
    this.text, {
    super.key,
    required this.disabled,
    required this.size,
    this.alignment = Alignment.center,
    this.icon,
    this.trailingIcon,
    this.decoration,
    this.textColor,
    this.disabledTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    TextStyle btnStyle = switch (size) {
      .pill => textStyles.buttonXs(color: textColor),
      .xsmall || .small => textStyles.buttonS(color: textColor),
      _ => textStyles.button(color: textColor),
    };

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
        size: size,
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

  /// The size category used to scale the icons appropriately.
  final GtButtonSize size;

  /// Creates a [_ButtonTextWithIcon].
  const _ButtonTextWithIcon({
    required this.text,
    this.alignment,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
    required this.size,
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
      spacing: context.spacingBase,
      children: [
        if (leadingIcon != null) _ButtonIconContainer(leadingIcon, size),
        ?child,
        if (trailingIcon != null) _ButtonIconContainer(trailingIcon, size),
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

  /// The size category used to determine the exact pixel constraints for the icon.
  final GtButtonSize size;

  /// Creates a [_ButtonIconContainer].
  const _ButtonIconContainer(this.icon, this.size);

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const Offstage();
    final iconSize = switch (size) {
      .pill => 11.0,
      .xsmall => 14.0,
      .small => 18.0,
      _ => 20.0,
    };
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size.square(iconSize)),
      child: FittedBox(fit: BoxFit.cover, child: icon),
    );
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
