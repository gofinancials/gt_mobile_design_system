import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

/// A specialized text input field designed specifically for URL addresses.
///
/// This widget automatically applies URL validation, sets the appropriate
/// keyboard type, provides autofill hints for URLs, and includes a convenient
/// "paste" suffix button that reads a valid URL directly from the device clipboard.
class GtUrlField extends GtStatefulWidget {
  /// The controller used to read and manipulate the URL input text.
  final GtInputController controller;

  /// An optional label displayed for the input field.
  final String? label;

  /// Callback invoked whenever the URL text changes.
  final OnChanged<String?>? onChange;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Whether a valid URL must be entered to pass validation. Defaults to true.
  final bool isRequired;

  /// An optional color to override the default fill color of the input field.
  final Color? fillColor;

  /// An optional custom validator. Defaults to [AppValidators.urlValidator] if omitted.
  final OnValidate<String?>? validator;

  /// Optional text displayed below the input field to guide the user.
  final String? helperText;

  /// Custom visual styling for the input.
  final GtInputDecoration? decoration;

  /// Creates a new [GtUrlField].
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
