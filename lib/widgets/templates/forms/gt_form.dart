import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A standardized form widget for the GT Mobile Design System.
///
/// [GtForm] wraps Flutter's native [Form] widget and automatically includes
/// an [AutofillGroup] to enhance the user experience with form data autofill.
class GtForm extends GtStatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// Typically a [Column] or [ListView] containing the form fields.
  final Widget child;

  /// Determines whether the enclosing route can be popped.
  ///
  /// Useful for preventing users from accidentally leaving a form with unsaved changes.
  final bool? canPop;

  /// Called when one of the form fields changes.
  final VoidCallback? onChanged;

  /// Used to enable/disable form field auto-validation and update their error text.
  final AutovalidateMode autovalidateMode;

  /// A global key that uniquely identifies the form and allows validation of its fields.
  final GlobalKey<FormState> formKey;

  /// Creates a [GtForm].
  const GtForm({
    super.key,
    required this.child,
    this.autovalidateMode = AutovalidateMode.disabled,
    required this.formKey,
    this.onChanged,
    this.canPop,
  });

  @override
  State<GtForm> createState() => _GtFormState();
}

class _GtFormState extends State<GtForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      canPop: widget.canPop,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      child: AutofillGroup(
        key: Key("AutofillGroup-${widget.formKey}"),
        child: widget.child,
      ),
    );
  }
}
