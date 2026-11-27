import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

/// A form field widget that displays input as a series of dots.
///
/// This widget is commonly used for secure inputs like PINs, passcodes, or OTPs.
/// It integrates with Flutter's [Form] system, supporting validation, error states,
/// and disabled states via an internal [FormField].
class GtDotFormField extends GtStatefulWidget {
  /// Whether the form field is interactive.
  ///
  /// When false, the widget visually indicates it is disabled and ignores input.
  final bool isEnabled;

  /// Optional text displayed below the input dots to guide the user.
  final String? helperText;

  /// Optional text displayed below the input dots to indicate an error.
  ///
  /// If provided, this overrides [helperText] and styles the text as an error.
  final String? errorText;

  /// An optional function that validates the input text.
  final OnValidate<String?>? validator;

  /// Controls the text being edited and represented by the dots.
  final TextEditingController controller;

  /// An optional focus node to control the focus state of the input.
  final FocusNode? focusNode;

  /// The total number of dots (characters) expected in this field.
  final int length;

  /// The color used for both the filled active dots and the borders of the inactive dots.
  final Color? color;

  /// The color of the inactive dots
  final Color? inactiveColor;

  /// Whether the dots should be filled with color when inactive, or just outlined.
  final bool filled;

  /// When the input is validated without the app calling
  /// [FormState.validate].
  ///
  /// When this or the enclosing [GtForm] sets a mode other than
  /// [AutovalidateMode.disabled], every change to [controller], such as a key
  /// on a virtual keypad, marks the input as changed for its [Form]. So
  /// [AutovalidateMode.onUserInteraction] shows the error as the input
  /// changes and clears it once the input is valid again. Defaults to
  /// [AutovalidateMode.disabled].
  final AutovalidateMode autovalidateMode;

  /// Creates a [GtDotFormField].
  const GtDotFormField({
    super.key,
    this.isEnabled = true,
    this.validator,
    required this.controller,
    this.helperText,
    this.errorText,
    this.focusNode,
    this.filled = false,
    this.color,
    this.inactiveColor,
    required this.length,
    this.autovalidateMode = .disabled,
  });

  @override
  State<GtDotFormField> createState() => _GtDotFormFieldState();
}

/// The state for [GtDotFormField].
class _GtDotFormFieldState extends State<GtDotFormField> {
  /// The key of the [FormField] that validates the input.
  final _fieldKey = GlobalKey<FormFieldState<TextEditingController>>();

  /// The text last reported to the [FormField].
  late String _reportedText;

  @override
  void initState() {
    super.initState();
    _reportedText = widget.controller.text;
    widget.controller.addListener(_reportChange);
  }

  @override
  void didUpdateWidget(covariant GtDotFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_reportChange);
    _reportedText = widget.controller.text;
    widget.controller.addListener(_reportChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_reportChange);
    super.dispose();
  }

  /// Reports an edit of the input to the [FormField], which re-validates it
  /// under [AutovalidateMode.onUserInteraction].
  void _reportChange() {
    final text = widget.controller.text;
    if (text == _reportedText) return;
    _reportedText = text;
    _fieldKey.currentState?.notifyChanged(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GtDisabledOverlay(
      !widget.isEnabled,
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final text = widget.controller.text;

          return FormField<TextEditingController>(
            key: _fieldKey,
            forceErrorText: widget.errorText,
            builder: (formState) {
              final hasErrorText = widget.errorText.hasValue;
              final formHasError = formState.hasError && !formState.isValid;

              final errorText = widget.errorText ?? formState.errorText;
              final hasError =
                  errorText.hasValue && (hasErrorText || formHasError);
              final helperText = hasError ? errorText : widget.helperText;
              final textColor = hasError
                  ? palette.error.base
                  : palette.text.darkerSub;

              return Column(
                crossAxisAlignment: .center,
                mainAxisSize: MainAxisSize.min,
                spacing: context.spacingLg,
                children: [
                  Focus(
                    focusNode: widget.focusNode,
                    child: GtInputDots(
                      inputValue: text,
                      maxLength: widget.length,
                      color: hasError ? textColor : widget.color,
                      inactiveColor: widget.inactiveColor,
                      filled: widget.filled,
                    ),
                  ),
                  if (helperText.hasValue)
                    GtText(
                      helperText,
                      style: context.textStyles.bodyS(color: textColor),
                      textAlign: .center,
                      maxLines: 3,
                    ),
                ],
              );
            },
            onReset: () {
              // A reset leaves the input untouched, so clearing it is not an
              // edit to report.
              _reportedText = '';
              widget.controller.clear();
            },
            validator: (value) => widget.validator?.call(value?.text),
            initialValue: widget.controller,
            autovalidateMode: widget.autovalidateMode,
            enabled: widget.isEnabled,
          );
        },
      ),
    );
  }
}
