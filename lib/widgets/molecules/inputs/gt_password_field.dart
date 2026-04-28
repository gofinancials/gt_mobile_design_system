import 'package:gt_mobile_foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized text input field designed for passwords.
///
/// This widget automatically includes a suffix icon to toggle password visibility
/// (obscuring/revealing text), disables auto-correction, sets the appropriate
/// keyboard type, and applies default password validation based on a minimum length.
class GtPasswordField extends GtStatefulWidget {
  /// The controller used to read and manipulate the password input.
  final GtInputController controller;

  /// An optional label displayed for the input field.
  final String? label;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Custom visual styling for the input.
  final GtInputDecoration? decoration;

  /// The minimum required length for the password to pass default validation. Defaults to 3.
  final int minLength;

  /// An optional custom validator. If null, a default password validator is used.
  final OnValidate<String?>? validator;

  /// Callback invoked when the user submits the field (e.g., presses the keyboard action button).
  final OnChanged<String?>? onFieldSubmitted;

  /// The type of action button to use for the keyboard. Defaults to [TextInputAction.next].
  final TextInputAction action;

  /// Creates a new [GtPasswordField].
  const GtPasswordField({
    required this.controller,
    this.label,
    this.isEnabled = true,
    this.minLength = 3,
    this.validator,
    this.action = TextInputAction.next,
    this.onFieldSubmitted,
    super.key,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() => _GtPasswordFieldState();
}

class _GtPasswordFieldState extends State<GtPasswordField> {
  late ValueNotifier<bool> hidePass;

  @override
  void initState() {
    super.initState();
    hidePass = ValueNotifier(true);
  }

  @override
  void dispose() {
    super.dispose();
    hidePass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BoolListener(
      valueListenable: hidePass,
      builder: (passwordHidden) {
        final icon = passwordHidden ? GtIcons.eyeOpen : GtIcons.eyeClosed;
        return GtTextField(
          decoration: widget.decoration,
          autoCorrect: false,
          label: widget.label,
          textCapitalization: TextCapitalization.none,
          obscureText: passwordHidden,
          controller: widget.controller,
          textInputAction: widget.action,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator:
              widget.validator ??
              (password) => AppValidators.passwordValidator(
                password,
                minLength: widget.minLength,
              ),
          suffix: InkWell(
            child: GtAnimatedSwitcher(child: GtIcon(icon, key: ValueKey(icon))),
            onTap: () {
              HapticFeedback.lightImpact();
              hidePass.value = !passwordHidden;
            },
          ),
          keyboardType: TextInputType.visiblePassword,
          isEnabled: widget.isEnabled,
          autofillHints: const [AutofillHints.password],
        );
      },
    );
  }
}
