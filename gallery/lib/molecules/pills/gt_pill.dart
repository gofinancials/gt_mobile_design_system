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
    ("All", GtIcons.alignLeft),
    ("network providers", GtIcons.phone),
    ("internet providers", GtIcons.signal),
    ("pay AGAIN", GtIcons.arrowBottomRight),
    ("VIEW RECEIPT", GtIcons.hide),
  ];
  final selections = ["Savings", "Current", "Business"];
  (String, IconData) activeTab = context.knobs.object
      .dropdown<(String, IconData)>(
        label: "Active Pill Tab",
        options: tabs,
        initialOption: tabs.first,
        labelBuilder: (value) => value.$1,
      );
  String activeSelection = context.knobs.object.dropdown<String>(
    label: "Active Pill Selection",
    options: selections,
    initialOption: selections.first,
  );
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
                  const GalleryPageSectionHeader(title: "GtTabPill"),
                  SingleChildScrollView(
                    scrollDirection: .horizontal,
                    child: Row(
                      spacing: context.spacingBase,
                      crossAxisAlignment: .center,
                      children: [
                        for (final tab in tabs)
                          GtTabPill(
                            text: tab.$1,
                            value: tab,
                            activeValue: activeTab,
                            icon: tab.$2,
                            onSelect: (newTab) {
                              setState(() {
                                activeTab = newTab;
                              });
                            },
                            variant: pillVariant,
                          ),
                      ],
                    ),
                  ),
                  const GalleryPageSectionHeader(
                    title: "GtTabPill [selection]",
                  ),
                  SingleChildScrollView(
                    scrollDirection: .horizontal,
                    child: Row(
                      spacing: context.spacingSm,
                      crossAxisAlignment: .center,
                      children: [
                        for (final selection in selections)
                          GtTabPill.selection(
                            text: selection,
                            value: selection,
                            activeValue: activeSelection,
                            onSelect: (newTab) {
                              setState(() {
                                activeSelection = newTab;
                              });
                            },
                            variant: pillVariant,
                          ),
                      ],
                    ),
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
