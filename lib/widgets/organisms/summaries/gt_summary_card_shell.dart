import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The card every kind of summary content sits in.
///
/// Exists so the three card kinds cannot drift apart: they share one padding
/// and one radius by construction rather than by three copies of the same two
/// values.
class GtSummaryCardShell extends GtStatelessWidget {
  /// The card's content.
  final Widget child;

  /// Creates a [GtSummaryCardShell].
  const GtSummaryCardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GtCard(
      padding: context.insets.allDp(16.px),
      borderRadius: context.borderRadiusXl,
      child: child,
    );
  }
}
