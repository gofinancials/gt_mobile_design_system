import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Represents the data for a single key cell in the virtual keypad.
///
/// This class encapsulates the value and optional icon for each button
/// displayed in the [GtKeyPadGrid].
class GtKeyCellData {
  /// An optional icon to display on the key (e.g., backspace, biometric icon).
  final IconData? icon;

  /// The underlying string value associated with this key.
  ///
  /// For numeric keys, this is the number itself (e.g., '1').
  /// For special keys, this acts as an identifier (e.g., 'bio', 'x').
  final String value;

  GtKeyCellData._(this.value, {this.icon});

  /// Returns a 2D list representing the standard 4x3 layout of the keypad.
  ///
  /// The layout includes numbers 0-9, a biometric authentication key, and a backspace key.
  static List<List<GtKeyCellData>> get values {
    return [
      [GtKeyCellData._('1'), GtKeyCellData._('2'), GtKeyCellData._('3')],
      [GtKeyCellData._('4'), GtKeyCellData._('5'), GtKeyCellData._('6')],
      [GtKeyCellData._('7'), GtKeyCellData._('8'), GtKeyCellData._('9')],
      [
        GtKeyCellData._('bio', icon: GtIcons.faceId),
        GtKeyCellData._('0'),
        GtKeyCellData._('x', icon: GtIcons.delete),
      ],
    ];
  }
}
