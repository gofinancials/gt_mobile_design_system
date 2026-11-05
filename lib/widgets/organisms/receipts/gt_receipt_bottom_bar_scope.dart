import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Tells the [GtReceiptBody] or [GtTransferDetailBody] beneath it whether a
/// floating bottom bar is drawn over it.
///
/// [GtReceiptScaffold] and [GtTransferDetailScaffold] stack their bottom bar
/// over the body, so the body ends with trailing space to scroll clear of it.
/// When a scaffold draws no bar, it publishes that here so the body drops the
/// space, without the caller having to configure the body to match.
class GtReceiptBottomBarScope extends InheritedWidget {
  /// Whether a floating bottom bar is drawn over the body.
  final bool hasBottomBar;

  /// Creates a [GtReceiptBottomBarScope].
  const GtReceiptBottomBarScope({
    required this.hasBottomBar,
    required super.child,
    super.key,
  });

  /// Whether the nearest enclosing scope has a floating bottom bar.
  ///
  /// Returns null when there is no enclosing scope.
  static bool? maybeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<GtReceiptBottomBarScope>();
    return scope?.hasBottomBar;
  }

  @override
  bool updateShouldNotify(GtReceiptBottomBarScope oldWidget) {
    return hasBottomBar != oldWidget.hasBottomBar;
  }
}
