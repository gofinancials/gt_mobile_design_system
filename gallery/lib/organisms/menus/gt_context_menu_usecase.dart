import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtContextMenu', type: GtContextMenu)
Widget playgroundGtContextMenuUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtContextMenu',
    description: 'Documentation for GtContextMenu',
    code: '''
GtContextMenu<String>(
  anchor: GtIconButton(icon: GtIcons.more, onPressed: () {}),
  items: [
    GtContextMenuItem(
      onTap: () {},
      label: "Edit",
      icon: GtIcons.pen,
    ),
    GtContextMenuItem(
      onTap: () {},
      label: "Delete",
      icon: GtIcons.trash,
    ),
  ],
)
''',
    child: Center(
      child: GtContextMenu<String>(
        anchor: GtIconButton(icon: GtIcons.more, onPressed: () {}),
        items: [
          GtContextMenuItem(
            onTap: () {},
            label: "Edit",
            icon: GtIcons.pen,
          ),
          GtContextMenuItem(
            onTap: () {},
            label: "Delete",
            icon: GtIcons.trash,
          ),
        ],
      ),
    ),
  );
}
