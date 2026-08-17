import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class GtInkWell extends InkWell {
  final HapticFeedbackType hapticFeedbackType;
  final bool enableScaleEffect;
  final double pressedScale;
  final Duration scaleDuration;
  final String? semanticsLabel;
  final String? semanticHint;

  /// The accessibility role announced for this surface.
  ///
  /// Defaults to [GtSemanticRole.button] to match the historical behaviour of
  /// [isSemanticButton]. Set this explicitly whenever the surface is not a
  /// button: a checkbox, radio, tab, or card announced as "button" tells the
  /// user nothing about its state.
  final GtSemanticRole? role;

  /// Whether the control is checked, for [GtSemanticRole.checkbox] and
  /// [GtSemanticRole.radio].
  final bool? isChecked;

  /// Whether the control is toggled on, for [GtSemanticRole.toggle].
  final bool? isToggled;

  /// Whether the control is selected, for [GtSemanticRole.tab].
  final bool? isSelected;

  /// Whether the control is expanded, for [GtSemanticRole.disclosure].
  final bool? isExpanded;

  /// Whether the control can currently be operated.
  ///
  /// Disabled controls stay in the semantics tree but are announced as
  /// unavailable rather than silently ignoring activation.
  final bool isEnabled;

  /// Whether the semantics of descendants should be dropped.
  ///
  /// Set this when [semanticsLabel] already describes the whole surface and the
  /// children would otherwise contribute duplicate or fragmented labels.
  final bool excludeDescendantSemantics;

  /// Whether this surface announces itself as a button.
  ///
  /// Prefer [role] instead, which can also express checkboxes, radios,
  /// toggles, tabs, and links.
  @Deprecated(
    'Use role instead. isSemanticButton cannot express non-button roles. '
    'This field will be removed in the next major release.',
  )
  final bool isSemanticButton;

  const GtInkWell({
    this.hapticFeedbackType = .light,
    this.enableScaleEffect = true,
    this.pressedScale = GtMotion.buttonPressScale,
    this.scaleDuration = GtMotion.fast,
    this.semanticsLabel,
    this.semanticHint,
    this.role,
    this.isChecked,
    this.isToggled,
    this.isSelected,
    this.isExpanded,
    this.isEnabled = true,
    this.excludeDescendantSemantics = false,
    @Deprecated(
      'Use role instead. isSemanticButton cannot express non-button roles. '
      'This field will be removed in the next major release.',
    )
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

  /// The role this surface actually reports, resolving the deprecated
  /// [isSemanticButton] flag when [role] has not been supplied.
  GtSemanticRole get resolvedRole {
    if (role != null) return role!;
    // ignore: deprecated_member_use_from_same_package
    return isSemanticButton ? .button : .none;
  }

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
      onTap: onTap == null || !isEnabled
          ? null
          : () {
              triggerHaptic(hapticFeedbackType);
              onTap!.call();
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

    final isInteractive =
        isEnabled &&
        (onTap != null || onDoubleTap != null || onLongPress != null);

    return GtSemantics(
      role: resolvedRole,
      label: semanticsLabel,
      hint: semanticHint,
      isChecked: isChecked,
      isToggled: isToggled,
      isSelected: isSelected,
      isExpanded: isExpanded,
      enabled: isEnabled,
      excludeDescendants: excludeDescendantSemantics,
      child: GtPressable(
        enabled: enableScaleEffect && isInteractive,
        pressedScale: pressedScale,
        duration: scaleDuration,
        child: inkWell,
      ),
    );
  }
}
