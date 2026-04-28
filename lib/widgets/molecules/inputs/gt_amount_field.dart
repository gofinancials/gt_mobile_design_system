import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtAmountField extends GtStatefulWidget {
  final GtInputController controller;
  final GtInputDecoration? decoration;
  final String? label;
  final OnChanged<String?>? onChange;
  final TextAlign textAlign;
  final bool isEnabled;
  final bool isRequired;
  final num? min;
  final num? max;

  const GtAmountField({
    super.key,
    required this.controller,
    this.label,
    this.onChange,
    this.isRequired = true,
    this.isEnabled = true,
    this.max,
    this.min,
    this.decoration,
    this.textAlign = .start,
  });
  @override
  State<GtAmountField> createState() => _GtAmountFieldState();
}

class _GtAmountFieldState extends State<GtAmountField> {
  @override
  Widget build(BuildContext context) {
    return GtTextField(
      decoration: widget.decoration,
      isEnabled: widget.isEnabled,
      label: widget.label,
      inputFormatters: [AppAmountFormatter()],
      controller: widget.controller,
      validator: (text) => AppValidators.amountValidator(
        text,
        isRequired: widget.isRequired,
        maxAmount: widget.max,
        minAmount: widget.min,
      ),
      textAlign: widget.textAlign,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: widget.onChange,
      autofillHints: const [AutofillHints.transactionAmount],
    );
  }
}
