import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class GtInkWell extends InkWell {
  final HapticFeedbackType hapticFeedbackType;
  final String? semanticsLabel;
  final String? semanticHint;
  final bool isSemanticButton;

  const GtInkWell({
    this.hapticFeedbackType = .light,
    this.semanticsLabel,
    this.semanticHint,
    this.isSemanticButton = true,
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
    // Callbacks are forwarded with their nullability intact rather than wrapped
    // in always non-null closures. [InkResponse] registers a gesture recognizer
    // for every non-null callback it is given, so wrapping them unconditionally
    // used to register a [DoubleTapGestureRecognizer] on every GtInkWell. That
    // forced each single tap to wait out the double-tap window before it could
    // win the gesture arena, adding a perceptible delay to every tappable
    // surface in the design system.
    Widget inkWell = InkWell(
      onTap: onTap == null
          ? null
          : () {
              onTap!.call();
              triggerHaptic(hapticFeedbackType);
            },
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onLongPressUp: onLongPressUp,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onSecondaryTap: onSecondaryTap,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      onFocusChange: onFocusChange,
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

    if (semanticsLabel != null || semanticHint != null || isSemanticButton) {
      inkWell = Semantics(
        label: semanticsLabel,
        hint: semanticHint,
        button: isSemanticButton,
        child: inkWell,
      );
    }

    return inkWell;
  }
}
