import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

/// A specialized text input field designed specifically for search functionality.
///
/// This widget provides a compact, pre-styled input tailored for searching.
/// By default, it utilizes [GtInputStyles.searchDecoration] to maintain
/// visual consistency across the application.
class GtSearchField extends GtStatefulWidget {
  /// The controller used to read and manipulate the search input text.
  final GtInputController? controller;

  /// Optional hint text that suggests what sort of input is expected.
  final String? hintText;

  /// Callback invoked whenever the search text changes.
  final OnChanged<String?>? onChange;

  /// Whether the input field is interactive and can be modified. Defaults to true.
  final bool isEnabled;

  /// Whether a valid input must be entered to pass validation. Defaults to true.
  final bool isRequired;

  /// An optional custom validator. Defaults to a URL validator if omitted.
  final OnValidate<String?>? validator;

  /// Optional text displayed below the input field to guide the user.
  final String? helperText;

  /// Custom visual styling for the input. Defaults to [GtInputStyles.searchDecoration].
  final GtInputDecoration? decoration;

  /// An optional widget to display at the start of the field (e.g., a search icon).
  final Widget? prefix;

  /// An optional widget to display at the end of the field (e.g., a clear icon).
  final Widget? suffix;

  /// Creates a new [GtSearchField].
  const GtSearchField({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.onChange,
    this.isRequired = true,
    this.decoration,
    this.helperText,
    this.isEnabled = true,
    this.prefix,
    this.suffix,
  });
  @override
  State<GtSearchField> createState() => _GtSearchFieldState();
}

class _GtSearchFieldState extends State<GtSearchField> {
  late final GtInputController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GtInputController();
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suffix = GenericListener(
      valueListenable: controller.controller,
      builder: (value) {
        if (value.text.isEmpty) return const Offstage();
        return InkWell(
          onTap: () {
            controller.clear();
            widget.onChange?.call(null);
          },
          child: GtIcon(
            Icons.cancel_rounded,
            variant: .disabled,
            size: 19,
            alignment: .centerRight,
          ),
        );
      },
    );
    return GtTextField(
      isEnabled: widget.isEnabled,
      decoration: widget.decoration ?? context.inputStyles.searchDecoration,
      helperText: widget.helperText,
      hintText: widget.hintText,
      controller: controller,
      suffix: widget.suffix ?? suffix,
      prefix: widget.prefix ?? GtIcon(GtIcons.magnifier, variant: .soft),
      validator: widget.validator ?? AppValidators.urlValidator,
      keyboardType: TextInputType.url,
      onChanged: widget.onChange,
      autofillHints: const [AutofillHints.url],
    );
  }
}
