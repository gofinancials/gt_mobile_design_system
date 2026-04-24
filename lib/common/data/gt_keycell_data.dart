import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtKeyCellData {
  final IconData? icon;
  final String value;

  GtKeyCellData._(this.value, {this.icon});

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
