import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Reports changes to a [FormField] so its [Form] can react to them.
extension GtFormFieldStateExtension<T> on FormFieldState<T> {
  /// Calls [FormFieldState.didChange] with [value], so the field counts as
  /// touched and [AutovalidateMode.onUserInteraction] re-validates it.
  ///
  /// Does nothing while both this field and its [Form] leave
  /// [AutovalidateMode] at [AutovalidateMode.disabled]. [didChange] also calls
  /// [Form.onChanged] and rebuilds the form, and neither should happen on
  /// every edit of a form that only validates when it is submitted.
  ///
  /// Inside a build, which a controller set in `didUpdateWidget` can trigger,
  /// the call waits for the end of the frame: [didChange] also rebuilds the
  /// enclosing [Form], and an ancestor cannot rebuild mid-build.
  void notifyChanged(T? value) {
    final form = context.findAncestorStateOfType<FormState>();
    final formMode = form?.widget.autovalidateMode ?? .disabled;
    if (widget.autovalidateMode == .disabled && formMode == .disabled) return;

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase != SchedulerPhase.persistentCallbacks) return didChange(value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) didChange(value);
    });
  }
}
