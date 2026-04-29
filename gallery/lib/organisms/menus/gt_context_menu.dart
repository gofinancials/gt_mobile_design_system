import 'package:flutter/material.dart';
import 'package:gallery/widgets/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtContextMenu', type: GtContextMenu)
Widget buildGtContextMeunuUsecase(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    body: Padding(
      padding: context.insets.defaultHorizontalInsets,
      child: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              GalleryPageHeader(
                title: "GtContextMenu Showcase",
                rider:
                    "Interact and use our context menu widgets as represented by the GtContextMenu/GtPillContextMenu/GtMoreContextMenu classes",
                sectionHeader: "GtMoreContextMenu",
              ),
              GtSectionHeader(
                "Gt More Context menu example",
                trailing: GtMoreContextMenu<String>(
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
              ),
              GalleryPageSectionHeader(title: "GtPillContextMenu"),
              GtSectionHeader(
                "Gt Pill Context menu example",
                trailing: GtPillContextMenu<String>(
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
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
