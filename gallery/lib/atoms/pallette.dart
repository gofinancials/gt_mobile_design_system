// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Palette', type: GtColors, path: "[Atoms]")
Widget playgroundPaletteUseCase(BuildContext context) {
  final delegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: context.dp(290.px),
    mainAxisExtent: context.dp(180.px),
    mainAxisSpacing: context.dp(8.px),
    crossAxisSpacing: context.dp(8.px),
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
              title: "Colors",
              rider:
                  "These are the colors that are used in the design system. They are organized in palettes and each palette has a set of colors that are used for different products.",
              sectionHeader: "Primary Colors",
            ),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final primaryColors = context.palette.primary.all;
              return GtColorContainer(color: primaryColors[index].colorSet);
            },
            itemCount: context.palette.primary.all.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Background Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.bg.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.bg.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Cover Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.coverColors.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.coverColors.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Static Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.staticColors.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.staticColors.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Text Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.text.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.text.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Stroke Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.stroke.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.stroke.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Icon Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.icon.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.icon.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Faded Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.faded.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.faded.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Information Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.information.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.information.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Warning Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.warning.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.warning.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Error Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.error.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.error.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Success Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.success.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.success.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Away Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.away.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.away.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Feature Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.feature.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.feature.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Verified Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.verified.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.verified.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Highlighted Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.highlighted.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.highlighted.all.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Stable Colors"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final colors = context.palette.stable.all;
              return GtColorContainer(color: colors[index].colorSet);
            },
            gridDelegate: delegate,
            itemCount: context.palette.stable.all.length,
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GtColorContainer extends StatelessWidget {
  final ColorSet color;
  const GtColorContainer({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dp(180.px),
      padding: context.insets.allDp(16.px),
      decoration: BoxDecoration(
        color: color,
        borderRadius: 8.circularBorderRadius,
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        color.asCssHex,
        style: context.textStyles.subHeadM(
          color: color.isBright
              ? context.palette.text.strong
              : context.palette.text.white,
        ),
      ),
    );
  }
}
