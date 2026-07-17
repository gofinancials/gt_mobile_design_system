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

GtMoreContextMenu<String>(
  items: [
    GtContextMenuItem(
      label: "New stash",
      icon: GtIcons.plus,
      onTap: () => context.showToast("New Stash"),
    ),
    GtContextMenuItem(
      label: "Archived stash",
      icon: GtIcons.boxArchive,
      onTap: () => context.showToast("Archived Stash"),
    ),
  ],
)

GtPillContextMenu<String>(
  items: [
    GtContextMenuItem(
      label: "Account information",
      icon: GtIcons.shareIos,
      onTap: () => context.showToast("Account information"),
    ),
    GtContextMenuItem(
      label: "Manage accounts",
      icon: GtIcons.gear,
      onTap: () => context.showToast("Manage accounts"),
    ),
    GtContextMenuItem(
      label: "Branding",
      icon: GtIcons.paintbrush,
      onTap: () => context.showToast("Branding"),
    ),
    GtContextMenuItem(
      label: "Account statements",
      icon: GtIcons.fileContent,
      onTap: () => context.showToast("Account statements"),
    ),
    GtContextMenuItem(
      label: "Switch accounts",
      icon: GtIcons.switchOutline,
      onTap: () => context.showToast("Switch accounts"),
    ),
  ],
  anchor: GtButtonPill(text: "MANAGE", variant: .primary),
)
''',

    child: Row(
      mainAxisAlignment: .center,
      spacing: context.spacingBase,
      children: [
        GtContextMenu<String>(
          anchor: IgnorePointer(
            child: GtIconButton(icon: GtIcons.more, onPressed: () {}),
          ),
          items: [
            GtContextMenuItem(onTap: () {}, label: "Edit", icon: GtIcons.pen),
            GtContextMenuItem(
              onTap: () {},
              label: "Delete",
              icon: GtIcons.trash,
            ),
          ],
        ),
        GtMoreContextMenu<String>(
          items: [
            GtContextMenuItem(
              label: "New stash",
              icon: GtIcons.plus,
              onTap: () => context.showToast("New Stash"),
            ),
            GtContextMenuItem(
              label: "Archived stash",
              icon: GtIcons.boxArchive,
              onTap: () => context.showToast("Archived Stash"),
            ),
          ],
        ),
        GtPillContextMenu<String>(
          items: [
            GtContextMenuItem(
              label: "Account information",
              icon: GtIcons.shareIos,
              onTap: () => context.showToast("Account information"),
            ),
            GtContextMenuItem(
              label: "Manage accounts",
              icon: GtIcons.gear,
              onTap: () => context.showToast("Manage accounts"),
            ),
            GtContextMenuItem(
              label: "Branding",
              icon: GtIcons.paintbrush,
              onTap: () => context.showToast("Branding"),
            ),
            GtContextMenuItem(
              label: "Account statements",
              icon: GtIcons.fileContent,
              onTap: () => context.showToast("Account statements"),
            ),
            GtContextMenuItem(
              label: "Switch accounts",
              icon: GtIcons.switchOutline,
              onTap: () => context.showToast("Switch accounts"),
            ),
          ],
          anchor: GtButtonPill(text: "MANAGE", variant: .primary),
        ),
      ],
    ),
  );
}
