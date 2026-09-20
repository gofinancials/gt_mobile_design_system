import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the text capitalization behavior for [GtButtonText].
enum GtTextCase {
  /// Renders every letter in uppercase.
  upper,

  /// Renders every letter in lowercase.
  lower,

  /// Capitalizes the first letter of the text only.
  sentence,

  /// Capitalizes the first letter of every word.
  title,

  /// Renders the text exactly as provided.
  none,
}

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
  final GtTextCase textCase;

  /// Whether changes to [text] use a short directional transition.
  final bool animateChanges;

  /// Duration of the label change transition.
  final Duration animationDuration;

  /// An optional square size for [icon] and [trailingIcon], in logical pixels.
  ///
  /// When null, the icons are fitted to a square derived from [size].
  final double? iconSize;

  /// An optional gap between the icons and [text], in logical pixels.
  ///
  /// When null, the gap is [BuildContext.spacingBase].
  final double? iconSpacing;

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
    this.animateChanges = true,
    this.animationDuration = GtMotion.fast,
    this.iconSize,
    this.iconSpacing,
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
        iconSize: iconSize,
        iconSpacing: iconSpacing,
        textAlign: textAlign,
        animateChanges: animateChanges,
        animationDuration: animationDuration,
      );
    }
    return _ButtonText(
      text: casedText,
      style: style ?? btnStyle,
      textAlign: textAlign,
      animateChanges: animateChanges,
      animationDuration: animationDuration,
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

  /// An optional square size for the icons, overriding the one derived from [size].
  final double? iconSize;

  /// An optional gap between the icons and [text], overriding
  /// [BuildContext.spacingBase].
  final double? iconSpacing;

  /// Optional text alignment to override the default button text alignment.
  final TextAlign textAlign;

  /// Whether changes to [text] use a short directional transition.
  final bool animateChanges;

  /// Duration of the label change transition.
  final Duration animationDuration;

  /// Creates a [_ButtonTextWithIcon].
  const _ButtonTextWithIcon({
    required this.text,
    this.alignment,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
    required this.size,
    this.iconSize,
    this.iconSpacing,
    this.textAlign = .center,
    required this.animateChanges,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (text.hasValue) {
      child = _ButtonText(
        text: text!,
        style: style,
        textAlign: textAlign,
        animateChanges: animateChanges,
        animationDuration: animationDuration,
      );
    }

    child = Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      mainAxisSize: .min,
      spacing: iconSpacing ?? context.spacingBase,
      children: [
        if (leadingIcon != null)
          _ButtonIconContainer(leadingIcon, size, iconSize),
        ?child,
        if (trailingIcon != null)
          _ButtonIconContainer(trailingIcon, size, iconSize),
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

  /// An optional square size for the icon, overriding the one derived from [size].
  final double? iconSize;

  /// Creates a [_ButtonIconContainer].
  const _ButtonIconContainer(this.icon, this.size, this.iconSize);

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const Offstage();
    double dimension = switch (size) {
      .pill => 11.0,
      .xsmall => 14.0,
      .small => 18.0,
      _ => 20.0,
    };
    if (iconSize case double iconSize) {
      dimension = iconSize;
    }
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size.square(dimension)),
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

  /// Whether changes to [text] use a short directional transition.
  final bool animateChanges;

  /// Duration of the label change transition.
  final Duration animationDuration;

  /// Creates a [_ButtonText].
  const _ButtonText({
    required this.text,
    this.style,
    this.textAlign = .center,
    required this.animateChanges,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final duration = GtMotion.adaptiveDuration(
      context,
      animateChanges ? animationDuration : Duration.zero,
    );

    return ClipRect(
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => _GtButtonTextTransition(
          animation: animation,
          incoming: child.key == ValueKey(text),
          child: child,
        ),
        child: GtText(
          text,
          key: ValueKey(text),
          textAlign: textAlign,
          style: style,
          maxLines: 1,
        ),
      ),
    );
  }
}

/// A private widget that fades and slides a button label in or out.
class _GtButtonTextTransition extends GtStatelessWidget {
  /// The label being transitioned.
  final Widget child;

  /// The animation driving the fade and slide.
  final Animation<double> animation;

  /// Whether [child] is the incoming label, which slides up from below,
  /// rather than the outgoing one, which slides up and out.
  final bool incoming;

  /// Creates a [_GtButtonTextTransition].
  const _GtButtonTextTransition({
    required this.child,
    required this.animation,
    required this.incoming,
  });

  @override
  Widget build(BuildContext context) {
    final offset = incoming ? const Offset(0, .2) : const Offset(0, -.2);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
