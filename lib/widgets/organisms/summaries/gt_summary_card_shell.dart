import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The card every kind of summary content sits in.
///
/// Supplies the shared default padding and radius for all three card kinds.
/// Callers can override the background and padding for a particular card.
class GtSummaryCardShell extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// The card's content.
  final Widget child;

  /// Creates a [GtSummaryCardShell].
  const GtSummaryCardShell({
    this.backgroundColor,
    this.padding,
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GtCard(
      color: backgroundColor,
      padding: padding ?? context.insets.allDp(16.px),
      borderRadius: context.borderRadiusXl,
      child: child,
    );
  }
}
