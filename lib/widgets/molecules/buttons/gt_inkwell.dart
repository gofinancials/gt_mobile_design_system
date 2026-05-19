import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class GtInkWell extends InkWell {
  final HapticFeedbackType hapticFeedbackType;

  const GtInkWell({
    this.hapticFeedbackType = .light,
    super.onTap,
    super.key,
    super.child,
    super.onDoubleTap,
    super.onLongPress,
    super.onLongPressUp,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    super.onSecondaryTap,
    super.onSecondaryTapUp,
    super.onSecondaryTapDown,
    super.onSecondaryTapCancel,
    super.onHighlightChanged,
    super.onHover,
    super.mouseCursor,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.overlayColor,
    super.splashColor,
    super.splashFactory,
    super.radius,
    super.borderRadius,
    super.customBorder,
    super.enableFeedback,
    super.excludeFromSemantics,
    super.focusNode,
    super.canRequestFocus,
    super.onFocusChange,
    super.autofocus,
    super.statesController,
    super.hoverDuration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        super.onTap?.call();
        triggerHaptic(hapticFeedbackType);
      },
      onDoubleTap: () {
        super.onDoubleTap?.call();
      },
      onLongPress: () {
        super.onLongPress?.call();
      },
      onLongPressUp: () {
        super.onLongPressUp?.call();
      },
      onTapDown: (details) {
        super.onTapDown?.call(details);
      },
      onTapUp: (details) {
        super.onTapUp?.call(details);
      },
      onTapCancel: () {
        super.onTapCancel?.call();
      },
      onSecondaryTap: () {
        super.onSecondaryTap?.call();
      },
      onSecondaryTapUp: (details) {
        super.onSecondaryTapUp?.call(details);
      },
      onSecondaryTapDown: (details) {
        super.onSecondaryTapDown?.call(details);
      },
      onSecondaryTapCancel: () {
        super.onSecondaryTapCancel?.call();
      },
      onHighlightChanged: (value) {
        super.onHighlightChanged?.call(value);
      },
      onHover: (value) {
        super.onHover?.call(value);
      },
      onFocusChange: (value) {
        super.onFocusChange?.call(value);
      },
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      autofocus: autofocus,
      statesController: statesController,
      hoverDuration: hoverDuration,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      child: child,
    );
  }
}
