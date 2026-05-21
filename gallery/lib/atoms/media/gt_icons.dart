import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Vector Icons', type: GtIcon)
Widget playgroundIconsUseCase(BuildContext context) {
  final allIcons = GtVectors.all;
  final allIconFonts = GtIcons.all;
  final allIllustrations = GtVectorIllustrations.all;
  final variant = context.knobs.object.dropdown<(String, GtIconVariant)>(
    label: "Icon Variant",
    initialOption: ("Strong", GtIconVariant.strong),
    options: [
      for (final variant in GtIconVariant.values)
        (variant.name.capitalise(), variant),
    ],
    labelBuilder: (value) => value.$1,
  );
  final color = context.knobs.colorOrNull(
    label: "Icon Color",
    initialValue: null,
  );
  final gridTemplate = context.grid.eightColumn;
  final delegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 120,
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
              title: "Icon Playground",
              rider: "IconFonts, Vector Icons & Illustrations",
              sectionHeader: "Icon fonts [GtIcon]",
            ),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIconFonts[index];
              return GalleryIconCard(
                label: icon.label,
                child: GtIcon(icon.value, size: 24, variant: variant.$2),
              );
            },
            itemCount: allIconFonts.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Icons with color [GtIcon.withColor]",
            ),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIconFonts[index];
              return GalleryIconCard(
                label: icon.label,
                child: GtIcon.withColor(icon.value, size: 24, color: color),
              );
            },
            itemCount: allIconFonts.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "All Illustrations [GtSvg]"),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIllustrations[index];
              return GalleryIconCard(
                label: icon.label,
                child: GtSvg(icon.value, height: 24, width: 24, color: color),
              );
            },
            itemCount: allIllustrations.length,
          ),

          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Default Icons [GtSvg.asIcon]",
            ),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIcons[index];
              return GalleryIconCard(
                label: icon.label,
                child: GtSvg.asIcon(icon.value, size: 24, variant: variant.$2),
              );
            },
            itemCount: allIcons.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Icons with color [GtSvg]"),
          ),
          SliverGrid.builder(
            gridDelegate: delegate,
            itemBuilder: (_, index) {
              final icon = allIcons[index];
              return GalleryIconCard(
                label: icon.label,
                child: GtSvg(icon.value, height: 24, width: 24, color: color),
              );
            },
            itemCount: allIcons.length,
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GalleryIconCard extends StatelessWidget {
  const GalleryIconCard({super.key, required this.child, required this.label});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.spacingMd,
      mainAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        child,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: GtStatusPill(text: label, variant: .primary),
        ),
      ],
    );
  }
}
