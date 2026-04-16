import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(
  name: 'Vector Icons',
  type: GtIcon,
  path: "[Atoms]/[Images]",
)
Widget playgroundIconsUseCase(BuildContext context) {
  final allIcons = GtVectorIcons.all;
  final allIllustrations = GtVectorIllustrations.all;
  double size = context.knobs.object.dropdown<double>(
    label: "Icon Size",
    initialOption: 10,
    options: [8, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
  );
  final variant = context.knobs.object.dropdown<(String, GtIconVariant)>(
    label: "Icon Variant",
    initialOption: ("Strong", GtIconVariant.strong),
    options: [
      for (final variant in GtIconVariant.values)
        (variant.name.capitalise(), variant),
    ],
    labelBuilder: (value) => value.$1,
  );
  final color = context.knobs.color(
    label: "Icon Color",
    initialValue: context.palette.icon.strong,
  );
  final gridTemplate = context.grid.eightColumn;
  final delegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: size * 1.2,
    mainAxisExtent: size * 1.2,
    mainAxisSpacing: context.dp(gridTemplate.gutter.px),
    crossAxisSpacing: context.dp(gridTemplate.gutter.px),
  );

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "Vector Icons & Illustrations",
              rider: "Vector Icon Playground",
              sectionHeader: "Default Icons [GtSvg.asIcon/GtIcon]",
            ),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIcons[index];
              return GtSvg.asIcon(icon, size: size, variant: variant.$2);
            },
            itemCount: allIcons.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Icons with color"),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIcons[index];
              return GtSvg(icon, height: size, width: size, color: color);
            },
            itemCount: allIcons.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "All Illustrations"),
          ),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 40,
              mainAxisExtent: 40,
              mainAxisSpacing: context.dp(gridTemplate.gutter.px),
              crossAxisSpacing: context.dp(gridTemplate.gutter.px),
            ),
            itemBuilder: (_, index) {
              final icon = allIllustrations[index];
              return GtSvg(icon);
            },
            itemCount: allIllustrations.length,
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}
