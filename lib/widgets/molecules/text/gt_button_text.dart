import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the text capitalization behavior for [GtButtonText].
enum GtButtonTextCase { upper, lower, sentence, title, none }

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

  /// Optional text style to override the default button text style.
  final TextStyle? style;

  /// Optional text alignment to override the default button text alignment.
  final TextAlign textAlign;

  /// Defines the text capitalization behavior for the button text.
  final GtButtonTextCase textCase;

  /// Creates a [GtButtonText] widget.
  const GtButtonText(
    this.text, {
    super.key,
    required this.disabled,
    required this.size,
    this.textAlign = .center,
    this.alignment = .center,
    this.icon,
    this.trailingIcon,
    this.decoration,
    this.textColor,
    this.disabledTextColor,
    this.textCase = .upper,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    TextStyle btnStyle = switch (size) {
      .pill => textStyles.buttonXxs(color: textColor),
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

    final casedText = switch (textCase) {
      .upper => text.upper,
      .lower => text.lower,
      .sentence => text.capitalise(true),
      .title => text.capitalise(),
      .none => text,
    };

    if (icon != null || trailingIcon != null) {
      return _ButtonTextWithIcon(
        text: casedText,
        alignment: alignment,
        style: style ?? btnStyle,
        leadingIcon: icon,
        trailingIcon: trailingIcon,
        size: size,
        textAlign: textAlign,
      );
    }
    return _ButtonText(
      text: casedText,
      style: style ?? btnStyle,
      textAlign: textAlign,
    );
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

  /// Optional text alignment to override the default button text alignment.
  final TextAlign textAlign;

  /// Creates a [_ButtonTextWithIcon].
  const _ButtonTextWithIcon({
    required this.text,
    this.alignment,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
    required this.size,
    this.textAlign = .center,
  });

  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (text.hasValue) {
      child = _ButtonText(text: text!, style: style, textAlign: textAlign);
    }

    child = Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      mainAxisSize: .min,
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

    return UnconstrainedBox(child: child);
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

  /// Optional text alignment to override the default button text alignment.
  final TextAlign textAlign;

  /// Creates a [_ButtonText].
  const _ButtonText({required this.text, this.style, this.textAlign = .center});

  @override
  Widget build(BuildContext context) {
    return GtText(text, textAlign: textAlign, style: style, maxLines: 1);
  }
}
