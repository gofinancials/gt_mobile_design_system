import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';

/// A data model representing a single actionable item within a context menu.
///
/// Used by context menu widgets like `GtContextMenu`, `GtPillContextMenu`,
/// and `GtMoreContextMenu` to configure the list of available options.
class GtContextMenuItem<T> {
  /// The text displayed for this menu item.
  final String label;

  /// The icon displayed alongside the label.
  final IconData icon;

  /// The callback triggered when this menu item is selected.
  final OnPressed onTap;

  /// Creates a new [GtContextMenuItem].
  const GtContextMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
