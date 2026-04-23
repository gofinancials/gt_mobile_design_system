import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Pills Gallery', type: GtPill)
Widget buildGtPillUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: "Pill Text",
    initialValue: "VERIFIED",
    maxLines: 1,
  );
  final pillVariant = context.knobs.object.dropdown(
    label: "Pill Variant",
    options: GtPillVariant.values,
    initialOption: GtPillVariant.success,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final pillSize = context.knobs.object.dropdown(
    label: "Pill Size",
    options: GtPillSize.values,
    initialOption: GtPillSize.normal,
    labelBuilder: (value) => value.name.capitalise(),
  );
  final icons = [
    ("None", null),
    ("Check", GtIcons.checkBox),
    ("Caution", GtIcons.cautionOutline),
    ("Bell", GtIcons.bell),
    ("Bolt", GtIcons.bolt),
  ];
  final iconsTrailing = [
    ("None", null),
    ("Copy", GtIcons.copyFilled),
    ("Files", GtIcons.files),
    ("Eyes", GtIcons.eyeClosed),
    ("Art", GtIcons.art),
  ];
  final leading = context.knobs.object.dropdown<(String, IconData?)>(
    label: "Leading Icon",
    options: icons,
    initialOption: icons.first,
    labelBuilder: (value) => value.$1,
  );
  final trailing = context.knobs.object.dropdown<(String, IconData?)>(
    label: "Trailing Icon",
    options: iconsTrailing,
    initialOption: iconsTrailing.first,
    labelBuilder: (value) => value.$1,
  );
  final alignment = context.knobs.object.dropdown<(String, Alignment?)>(
    label: "Pill Alignment",
    options: [
      ("None", null),
      ("Centre", Alignment.center),
      ("Left", Alignment.centerLeft),
      ("Right", Alignment.centerRight),
    ],
    initialOption: ("Centre", Alignment.center),
    labelBuilder: (value) => value.$1,
  );
  final tabs = [
    GtTabData(value: "all", label: "All", icon: GtIcons.alignLeft),
    GtTabData(
      value: "networks",
      label: "network providers",
      icon: GtIcons.phone,
    ),
    GtTabData(
      value: "internets",
      label: "internet providers",
      icon: GtIcons.signal,
    ),
    GtTabData(value: "pay", label: "pay AGAIN", icon: GtIcons.arrowBottomRight),
    GtTabData(
      value: "view",
      label: "VIEW RECEIPT",
      icon: GtIcons.arrowBottomRight,
    ),
  ];
  final selections = [
    GtTabData(value: "savings", label: "savings"),
    GtTabData(value: "savings", label: "current"),
    GtTabData(value: "business", label: "business"),
  ];
  final activeTab = GtTabController(initialValue: tabs.first);
  final activeSelection = GtTabController(initialValue: selections.first);
  final showShadow = context.knobs.boolean(label: "Show Shadow");
  return StatefulBuilder(
    builder: (context, setState) {
      return Scaffold(
        key: PageStorageKey("Pills Playground"),
        body: Padding(
          padding: context.insets.defaultHorizontalInsets,
          child: CustomScrollView(
            key: PageStorageKey("Pills Playground List"),
            slivers: [
              SliverList.list(
                children: [
                  GalleryPageHeader(
                    title: "Pills",
                    rider: "Playground for cards",
                    sectionHeader: "GtStatusPill",
                  ),
                  GtStatusPill(
                    text: text,
                    variant: pillVariant,
                    icon: leading.$2,
                    trailing: trailing.$2,
                    alignment: alignment.$2,
                    size: pillSize,
                  ),
                ],
              ),
              SliverList.list(
                children: [
                  const GalleryPageSectionHeader(title: "GtButtonPill"),
                  GtButtonPill(
                    text: text,
                    variant: pillVariant,
                    icon: leading.$2,
                    trailing: trailing.$2,
                    alignment: alignment.$2,
                    showShadow: showShadow,
                    size: pillSize,
                  ),
                  const GalleryPageSectionHeader(title: "GtInfoPill"),
                  GtInfoPill(
                    text: text,
                    variant: pillVariant,
                    icon: leading.$2,
                    trailing: trailing.$2,
                    alignment: alignment.$2,
                    showShadow: showShadow,
                    useDisplayFont: context.knobs.boolean(
                      label: "Toggle Display Font",
                    ),
                  ),
                ],
              ),
              SliverList.list(
                children: [
                  const GalleryPageSectionHeader(
                    title: "GtTabPill [GtSelectionTab]",
                  ),
                  GtSelectionTabbar(tabs: tabs, controller: activeTab),
                  const GalleryPageSectionHeader(
                    title: "GtTabPill [selection]",
                  ),
                  GtSelectionTabbar(
                    tabs: selections,
                    controller: activeSelection,
                    useAlternateStyle: true,
                  ),
                  GtTabbarView(
                    controller: activeSelection,
                    tabViews: {
                      for (final selection in selections)
                        selection: Padding(
                          padding: context.insets.symmetricDp(vertical: 20.px),
                          child: GtText(selection.label.upper, textAlign: .center),
                        ),
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(child: const GtGap.ySectionXl()),
            ],
          ),
        ),
      );
    },
  );
}
