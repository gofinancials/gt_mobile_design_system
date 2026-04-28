import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtEmailField extends GtStatefulWidget {
  final GtInputController controller;
  final GtInputDecoration? decoration;
  final String? label;
  final bool isRequired;
  final bool isEnabled;
  final bool autoFocus;
  final TextInputAction action;
  final OnChanged<String?>? onFieldSubmitted;

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

          const icon = GtIcons.cautionOutline;

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
