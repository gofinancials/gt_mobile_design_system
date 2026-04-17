import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/string_extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtButtonText extends GtStatelessWidget {
  final Widget? icon;
  final Widget? trailingIcon;
  final String text;
  final TextDecoration? decoration;
  final AlignmentGeometry? alignment;
  final bool disabled;
  final Color? textColor;
  final Color? disabledTextColor;

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
    TextStyle btnStyle = context.textStyles.buttonM(color: textColor);
    if (textColor != null) {
      btnStyle = btnStyle.copyWith(decorationColor: textColor);
    }

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

class _ButtonTextWithIcon extends GtStatelessWidget {
  final String? text;
  final TextStyle? style;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final AlignmentGeometry? alignment;

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

class _ButtonIconContainer extends GtStatelessWidget {
  final Widget? icon;

  const _ButtonIconContainer(this.icon);

  @override
  Widget build(BuildContext context) {
    if (icon == null) return const Offstage();
    return GtSquareBox(size: 20, child: FittedBox(child: icon));
  }
}

class _ButtonText extends GtStatelessWidget {
  final String text;
  final TextStyle? style;

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
