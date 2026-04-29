import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
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
                      value: "New Stash",
                      label: "New stash",
                      icon: GtIcons.add,
                      onSelect: context.showToast,
                    ),
                    GtContextMenuItem(
                      value: "Archived stash",
                      label: "Archived stash",
                      icon: GtIcons.boxArchive,
                      onSelect: context.showToast,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
