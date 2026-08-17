import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// A specialized input field designed for capturing PINs or One-Time Passwords (OTPs).
///
/// Uses individual cells for each digit and automatically handles focus traversal
/// between them. Supports validation, error states, and automatic submission.
class GtPinInput extends GtStatefulWidget {
  /// An optional controller to read or manipulate the current PIN text.
  final TextEditingController? controller;

  /// An optional focus node to control the focus state of the input.
  final FocusNode? focusNode;

  /// Whether the input field is enabled and interactive. Defaults to `true`.
  final bool isEnabled;

  /// The number of digits/characters required for the PIN. Defaults to `6`.
  final int length;

  /// Whether to obscure the entered text, typically used for secure PINs. Defaults to `false`.
  final bool obscureText;

  /// Whether the input field should automatically request focus when rendered. Defaults to `true`.
  final bool autoFocus;

  /// An optional callback used to validate the entered PIN. Returns an error string if invalid.
  final OnValidate<String?>? validator;

  /// An optional callback triggered whenever the entered PIN changes.
  final OnChanged<String?>? onChanged;

  /// An optional callback triggered when the user finishes entering the PIN or submits the field.
  final OnChanged<String?>? onFieldSubmitted;

  /// Optional custom text style for the entered PIN characters.
  final TextStyle? style;

  /// Optional semantic label for accessibility.
  final String? semanticsLabel;

  /// The size constraint for the individual PIN cells.
  final Size? fieldSize;

  /// Optional controller for explicitly triggering validation shake feedback.
  final GtSpringShakeController? shakeController;

  /// Whether entered digits use a subtle scale animation.
  final bool enableEntryAnimation;

  /// Duration of the digit-entry and cell-state animations.
  final Duration entryAnimationDuration;

  /// Curve used by digit-entry and cell-state animations.
  final Curve entryAnimationCurve;

  /// Whether individual digit entry produces haptic feedback.
  final bool enableHapticFeedback;

  /// Haptic feedback used for individual digit entry.
  final HapticFeedbackType hapticFeedbackType;

  /// Optional haptic feedback emitted when all digits have been entered.
  final HapticFeedbackType? completionHapticFeedbackType;

  /// Creates a [GtPinInput].
  const GtPinInput({
    super.key,
    this.length = 6,
    this.focusNode,
    this.semanticsLabel,
    this.controller,
    this.validator,
    this.isEnabled = true,
    this.autoFocus = true,
    this.onChanged,
    this.obscureText = false,
    this.style,
    this.onFieldSubmitted,
    this.fieldSize,
    this.shakeController,
    this.enableEntryAnimation = true,
    this.entryAnimationDuration = GtMotion.fast,
    this.entryAnimationCurve = GtSpringCurves.bouncy,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = .light,
    this.completionHapticFeedbackType,
  });

  @override
  State<GtPinInput> createState() => _GtPinInputState();
}

class _GtPinInputState extends State<GtPinInput> {
  late final PinInputController _pinInputController;

  @override
  void initState() {
    super.initState();
    _pinInputController = PinInputController(
      textController: widget.controller,
      focusNode: widget.focusNode,
    );
  }

  @override
  void dispose() {
    _pinInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? context.textStyles.h4();
    final palette = context.palette;
    final defaultSize = Size(context.dp(48.px), context.dp(64.px));
    final animationDuration = GtMotion.adaptiveDuration(
      context,
      widget.entryAnimationDuration,
    );
    final reduceMotion = animationDuration == Duration.zero;
    final packageAnimationCurve = _GtBoundedCurve(widget.entryAnimationCurve);

    Widget field = MaterialPinFormField(
      key: const Key("otp_input"),
      pinController: _pinInputController,
      validator: (value) {
        final error = widget.validator?.call(value);
        return error;
      },
      semanticLabel: widget.semanticsLabel,
      enabled: widget.isEnabled,
      length: widget.length,
      obscureText: widget.obscureText,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      scrollPadding: .zero,
      autofillHints: [AutofillHints.oneTimeCode],
      autoFocus: widget.autoFocus,
      textInputAction: TextInputAction.done,
      enableHapticFeedback: widget.enableHapticFeedback,
      hapticFeedbackType: widget.hapticFeedbackType,
      onCompleted: (value) {
        if (widget.completionHapticFeedbackType != null) {
          triggerHaptic(widget.completionHapticFeedbackType!);
        }
        widget.onFieldSubmitted?.call(value);
      },
      onSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      formErrorStyle: context.textStyles.bodyXs(color: palette.error.base),
      clearErrorOnInput: true,
      theme: MaterialPinTheme(
        shape: .outlined,
        spacing: context.spacingBase,
        textStyle: textStyle,
        borderRadius: context.borderRadiusXl,
        cellSize: widget.fieldSize ?? defaultSize,
        borderColor: palette.bg.soft,
        fillColor: palette.bg.soft,
        focusedFillColor: Colors.transparent,
        filledFillColor: Colors.transparent,
        focusedBorderColor: palette.stroke.strong,
        enableErrorShake: true,
        errorBorderColor: palette.error.base,
        errorTextStyle: textStyle.copyWith(color: palette.error.base),
        filledBorderColor: palette.stroke.sub,
        cursorColor: palette.text.strong,
        animateCursor: !reduceMotion,
        borderWidth: 1.5,
        entryAnimation: widget.enableEntryAnimation && !reduceMotion
            ? .scale
            : .none,
        animationDuration: animationDuration,
        // pin_code_fields applies this curve to AnimatedSwitcher and then
        // applies it again inside the entry transition. Bound spring output so
        // the second Curve.transform never receives a value outside 0...1.
        animationCurve: packageAnimationCurve,
        errorAnimationDuration: GtMotion.adaptiveDuration(
          context,
          GtMotion.fluid,
        ),
      ),
    );

    if (widget.shakeController != null) {
      field = GtSpringShake(controller: widget.shakeController!, child: field);
    }

    return field;
  }
}

class _GtBoundedCurve extends Curve {
  final Curve curve;

  const _GtBoundedCurve(this.curve);

  @override
  double transformInternal(double t) {
    return curve.transform(t).clamp(0.0, 1.0);
  }
}
