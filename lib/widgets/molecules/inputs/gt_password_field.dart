import 'package:gt_mobile_foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtPasswordField extends GtStatefulWidget {
  final GtInputController controller;
  final String? label;
  final bool isEnabled;
  final GtInputDecoration? decoration;
  final int minLength;
  final OnValidate<String?>? validator;
  final OnChanged<String?>? onFieldSubmitted;
  final TextInputAction action;

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
