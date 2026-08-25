import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized text input field designed specifically for monetary amounts.
///
/// This widget automatically applies amount formatting (e.g., adding commas),
/// uses a numeric keyboard with decimal support, and includes built-in
/// validation for required, minimum, and maximum amounts. By default, it
/// uses the [GtInputStyles.transferInputStyle].
class GtAmountField extends GtStatefulWidget {
  /// The controller used to read and manipulate the input text.
  final GtInputController controller;

  /// Custom visual styling for the input.
  ///
  /// If null, defaults to [GtInputStyles.transferInputStyle] from the current theme.
  final GtInputDecoration? decoration;

  /// An optional label displayed for the input field.
  final String? label;

  /// Callback invoked whenever the input text changes.
  final OnChanged<String?>? onChange;

  /// How the text should be aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Whether a valid amount must be entered to pass validation. Defaults to true.
  final bool isRequired;

  /// The minimum allowable amount for validation.
  final num? min;

  /// The maximum allowable amount for validation.
  final num? max;

  /// A widget to display before the input field.
  final Widget? suffix;

  /// A widget to display after the input field.
  final Widget? prefix;

  /// The list of autofill hints for the input field.
  final List<String>? autofillHints;

  /// The hint text to display for the input field.
  final String? hintText;

  /// Creates a new [GtAmountField].
  const GtAmountField({
    super.key,
    required this.controller,
    this.label,
    this.onChange,
    this.isRequired = true,
    this.isEnabled = true,
    this.max,
    this.min,
    this.prefix,
    this.suffix,
    this.decoration,
    this.textAlign = .start,
    this.hintText,
    this.autofillHints = const [AutofillHints.transactionAmount],
  });
  @override
  State<GtAmountField> createState() => _GtAmountFieldState();
}

class _GtAmountFieldState extends State<GtAmountField> {
  @override
  Widget build(BuildContext context) {
    return GtTextField(
      decoration: widget.decoration ?? context.inputStyles.transferInputStyle,
      isEnabled: widget.isEnabled,
      label: widget.label,
      autoCorrect: false,
      hintText: widget.hintText ?? "0.00",
      inputFormatters: [AppAmountFormatter()],
      controller: widget.controller,
      validator: (text) => AppValidators.amountValidator(
        text,
        isRequired: widget.isRequired,
        maxAmount: widget.max,
        minAmount: widget.min,
      ),
      prefix: widget.prefix,
      suffix: widget.suffix,
      textAlign: widget.textAlign,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: widget.onChange,
      autofillHints: widget.autofillHints,
    );
  }
}
