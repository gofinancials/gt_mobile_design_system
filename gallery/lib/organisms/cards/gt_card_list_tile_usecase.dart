import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCardListTile', type: GtCardListTile)
Widget playgroundGtCardListTileUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Tile Title', initialValue: 'Security Settings');
  final subtitle = context.knobs.string(label: 'Tile Subtitle', initialValue: 'Manage password and biometric security');
  final type = context.knobs.object.dropdown<GtCardListTileType>(
    label: 'Tile Group Position',
    options: GtCardListTileType.values,
    initialOption: GtCardListTileType.sole,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtCardListTile',
    description: 'A layout wrapper designed to encase standard list tiles within custom-bordered card configurations.',
    code: '''
GtCardListTile(
  type: GtCardListTileType.${type.name},
  child: GtListTile(
    text: "$text",
    trailing: GtText("$subtitle"),
    leading: GtIcon(GtIcons.lock, size: 24),
    onTap: () {},
  ),
)''',
    child: GtCardListTile(
      type: type,
      child: GtListTile(
        text: text,
        trailing: GtText(subtitle),
        leading: GtIcon(GtIcons.lock, size: 24),
        onTap: () {},
      ),
    ),
  );
}
