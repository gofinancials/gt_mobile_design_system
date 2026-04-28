import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized text input field designed specifically for email addresses.
///
/// This widget automatically applies email validation, provides autofill hints
/// for email, and displays a visual warning indicator (a caution icon) if the
/// currently entered text is not a valid email format.
class GtEmailField extends GtStatefulWidget {
  /// The controller used to read and manipulate the email input.
  final GtInputController controller;

  /// Custom visual styling for the input.
  final GtInputDecoration? decoration;

  /// An optional label displayed for the input field.
  final String? label;

  /// Whether a valid email must be entered to pass validation. Defaults to true.
  final bool isRequired;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Whether the field should automatically request focus when rendered. Defaults to false.
  final bool autoFocus;

  /// The type of action button to use for the keyboard. Defaults to [TextInputAction.next].
  final TextInputAction action;

  /// Callback invoked when the user submits the field (e.g., presses the keyboard action button).
  final OnChanged<String?>? onFieldSubmitted;

  /// Creates a new [GtEmailField].
  const GtEmailField({
    super.key,
    required this.controller,
    this.label,
    this.isEnabled = true,
    this.isRequired = true,
    this.autoFocus = false,
    this.action = TextInputAction.next,
    this.onFieldSubmitted,
    this.decoration,
  });

  @override
  State<GtEmailField> createState() => _GtEmailFieldState();
}

class _GtEmailFieldState extends State<GtEmailField> {
  @override
  Widget build(BuildContext context) {
    return GtTextField(
      autoCorrect: false,
      decoration: widget.decoration,
      autoFocus: widget.autoFocus,
      isEnabled: widget.isEnabled,
      controller: widget.controller,
      label: widget.label,
      keyboardType: TextInputType.emailAddress,
      textInputAction: widget.action,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: (text) =>
          AppValidators.emailValidator(text, isRequired: widget.isRequired),
      suffix: ValueListenableBuilder(
        valueListenable: widget.controller.controller,
        builder: (context, TextEditingValue val, _) {
          final bool hasMatch = AppRegex.mailRegEx.hasMatch(val.text);

          if (val.text.isEmpty || hasMatch) {
            return const Offstage();
          }

          const icon = GtIcons.cautionSolid;

          return GtIcon.withColor(
            icon,
            color: context.palette.error.base,
            size: 16,
            key: const ValueKey(icon),
          );
        },
      ),
      autofillHints: const [AutofillHints.email],
    );
  }
}
