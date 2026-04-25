// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Borders', type: GtRadii)
Widget playgroundBordersUseCase(BuildContext context) {
  final borders = [
    context.dp(context.radii.sm.px),
    context.dp(context.radii.md.px),
    context.dp(context.radii.lg.px),
    context.dp(context.radii.xl.px),
    context.dp(context.radii.xxl.px),
    context.dp(context.radii.xxxl.px),
    context.dp(context.radii.xxxxl.px),
    context.dp(context.radii.xxxxxl.px),
    context.dp(context.radii.full.px),
  ];
  final delegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: context.dp(200.px),
    mainAxisExtent: context.dp(200.px),
    mainAxisSpacing: context.dp(16.px),
    crossAxisSpacing: context.dp(16.px),
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
              title: "Borders",
              rider:
                  "Borders are used to separate content and create visual hierarchy. They can be used to create cards, buttons, and other UI elements.",
              sectionHeader: "Circular Borders",
            ),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius: borders[index].circularBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Left Borders"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius: borders[index].leftBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Right Borders"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius: borders[index].rightBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Top Borders"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius: borders[index].topBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Bottom Borders"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius: borders[index].bottomBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Top Left to Bottom Right Borders",
            ),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius:
                    borders[index].diagonalTopLeftBottomRightBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Top Right to Bottom Left Borders",
            ),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtBorderContainer(
                borderRadius:
                    borders[index].diagonalTopRightBottomLeftBorderRadius,
                value: borders[index],
              );
            },
            itemCount: borders.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GtBorderContainer extends StatelessWidget {
  final BorderRadius borderRadius;
  final double value;
  const GtBorderContainer({
    required this.borderRadius,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dp(200.px),
      decoration: BoxDecoration(
        color: GtColors.transparent.value,
        borderRadius: borderRadius,
        border: Border.all(
          color: context.palette.stroke.strong,
          width: context.dp(2.px),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Center(
        child: Text(
          "${value.toStringAsFixed(0)}PX",
          style: context.textStyles.subHeadM(),
        ),
      ),
    );
  }
}
