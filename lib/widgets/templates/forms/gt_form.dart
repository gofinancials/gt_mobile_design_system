import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtForm extends GtStatefulWidget {
  final Widget child;
  final bool? canPop;
  final VoidCallback? onChanged;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;

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
        key: Key("AugofillGroup-${widget.formKey}"),
        child: widget.child,
      ),
    );
  }
}
