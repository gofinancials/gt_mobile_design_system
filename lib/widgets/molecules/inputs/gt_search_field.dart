import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

class GtSearchField extends GtStatefulWidget {
  final GtInputController controller;
  final String? hintText;
  final OnChanged<String?>? onChange;
  final bool isEnabled;
  final bool isRequired;
  final Color? fillColor;
  final OnValidate<String?>? validator;
  final String? helperText;
  final GtInputDecoration? decoration;
  final Widget? prefix;
  final Widget? suffix;

  const GtSearchField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.onChange,
    this.isRequired = true,
    this.decoration,
    this.helperText,
    this.fillColor,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
  });
  @override
  State<GtSearchField> createState() => _GtSearchFieldState();
}

class _GtSearchFieldState extends State<GtSearchField> {
  @override
  Widget build(BuildContext context) {
    return GtTextField(
      isEnabled: widget.isEnabled,
      decoration: widget.decoration ?? context.inputStyles.searchDecoration,
      helperText: widget.helperText,
      hintText: widget.hintText,
      controller: widget.controller,
      suffix: widget.suffix,
      prefix: widget.prefix,
      validator: widget.validator ?? AppValidators.urlValidator,
      keyboardType: TextInputType.url,
      onChanged: widget.onChange,
      autofillHints: const [AutofillHints.url],
    );
  }
}
