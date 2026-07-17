import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCardListTile', type: GtCardListTile)
Widget gtCardListTileUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Card List Tile",
    description: "A list tile styled as a card, often used for settings or selectable items.",
    code: '''
GtCardListTile(
  type: .sole,
  child: GtListTile(
    text: 'Security Settings',
    trailing: GtText('Manage your password and PIN'),
    leading: GtIcon.withColor(Icons.security, color: context.palette.primary.base),
    onTap: () {},
  ),
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtCardListTile"),
        GtCardListTile(
          type: .sole,
          child: GtListTile(
            text: context.knobs.string(label: 'Card Title', initialValue: 'Security Settings'),
            trailing: GtText(context.knobs.string(label: 'Card Subtitle', initialValue: 'Manage your password and PIN')),
            leading: GtIcon.withColor(Icons.security, color: context.palette.primary.base),
            onTap: () {},
          ),
        ),
      ],
    ),
  );
}
