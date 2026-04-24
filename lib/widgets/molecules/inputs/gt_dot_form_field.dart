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

  /// Creates a [GtDotFormField].
  const GtDotFormField({
    super.key,
    this.isEnabled = true,
    this.validator,
    required this.controller,
    this.helperText,
    this.errorText,
    this.focusNode,
    required this.length,
  });

  @override
  State<GtDotFormField> createState() => _GtDotFormFieldState();
}

class _GtDotFormFieldState extends State<GtDotFormField> {
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
                      color: errorText.hasValue ? textColor : null,
                    ),
                  ),
                  if (helperText.hasValue)
                    GtText(
                      helperText,
                      style: context.textStyles.bodyM(color: textColor),
                      textAlign: .center,
                      maxLines: 3,
                    ),
                ],
              );
            },
            onReset: () => widget.controller.clear(),
            validator: (value) => widget.validator?.call(value?.text),
            initialValue: widget.controller,
            autovalidateMode: .disabled,
            enabled: widget.isEnabled,
          );
        },
      ),
    );
  }
}
