import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Marks a subtree as disabled for accessibility purposes.
///
/// [IgnorePointer] — which the design system uses to make disabled controls
/// inert — only strips semantic *actions*. The control stays in the semantics
/// tree with no indication that it is unavailable, so a screen reader reads its
/// label and leaves the user to work out why nothing happens on activation.
///
/// The obvious fix, wrapping the subtree in `Semantics(enabled: false)`, does
/// not work: a control that already annotates its own enabled state would then
/// carry that flag twice, and Flutter refuses to merge configurations whose
/// flags collide. The result is one control announced as two nodes.
///
/// This scope avoids that by publishing the disabled state downward instead of
/// annotating. [GtSemantics] reads it and folds it into the single node it
/// already emits, so the state lands on the real control.
class GtDisabledScope extends InheritedWidget {
  /// Whether descendants should report themselves as disabled.
  final bool disabled;

  /// Creates a [GtDisabledScope].
  const GtDisabledScope({
    required this.disabled,
    required super.child,
    super.key,
  });

  /// Whether the nearest enclosing scope marks this subtree as disabled.
  ///
  /// Returns false when there is no enclosing scope.
  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GtDisabledScope>();
    return scope?.disabled ?? false;
  }

  @override
  bool updateShouldNotify(GtDisabledScope oldWidget) {
    return disabled != oldWidget.disabled;
  }
}
