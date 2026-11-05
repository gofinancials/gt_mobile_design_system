import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Supplies a title to the [GtSummaryBody] beneath it.
///
/// [GtSummaryScaffold] uses this for its headline layout, where the title has
/// to scroll with the body's content but is set on the scaffold. Publishing it
/// downward leaves the caller's body untouched, so none of its spacing or type
/// overrides are lost on the way through.
///
/// A [GtSummaryBody.title] set directly takes precedence over this scope.
class GtSummaryTitleScope extends InheritedWidget {
  /// The title the nearest [GtSummaryBody] renders when it has none of its own.
  final String title;

  /// Creates a [GtSummaryTitleScope].
  const GtSummaryTitleScope({
    required this.title,
    required super.child,
    super.key,
  });

  /// The title of the nearest enclosing scope.
  ///
  /// Returns null when there is no enclosing scope.
  static String? maybeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<GtSummaryTitleScope>();
    return scope?.title;
  }

  @override
  bool updateShouldNotify(GtSummaryTitleScope oldWidget) {
    return title != oldWidget.title;
  }
}
