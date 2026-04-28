import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

class GtUrlField extends GtStatefulWidget {
  final GtInputController controller;
  final String? label;
  final OnChanged<String?>? onChange;
  final bool isEnabled;
  final bool isRequired;
  final Color? fillColor;
  final OnValidate<String?>? validator;
  final String? helperText;
  final GtInputDecoration? decoration;

  const GtUrlField({
    super.key,
    required this.controller,
    this.validator,
    this.label,
    this.onChange,
    this.isRequired = true,
    this.decoration,
    this.helperText,
    this.fillColor,
    this.isEnabled = true,
  });
  @override
  State<GtUrlField> createState() => _GtUrlFieldState();
}

class _GtUrlFieldState extends State<GtUrlField> {
  @override
  Widget build(BuildContext context) {
    return GtTextField(
      isEnabled: widget.isEnabled,
      decoration: widget.decoration,
      helperText: widget.helperText,
      label: widget.label,
      controller: widget.controller,
      suffix: GtTextButton(
        text: "paste".ctr(),
        size: .xsmall,
        alignment: .centerEnd,
        onPressed: () async {
          final text = await context.getClipboardText();
          if (!text.hasValue) return;
          if (!AppRegex.urlRegex.hasMatch(text.value)) return;
          widget.controller.text = text.value;
        },
      ),
      validator: widget.validator ?? AppValidators.urlValidator,
      keyboardType: TextInputType.url,
      onChanged: widget.onChange,
      autofillHints: const [AutofillHints.url],
    );
  }
}
