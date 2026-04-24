import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

class GtDotFormField extends GtStatefulWidget {
  final bool isEnabled;
  final String? helperText;
  final String? errorText;
  final OnValidate<String?>? validator;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final int length;

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
