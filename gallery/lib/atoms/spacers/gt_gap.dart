import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Gaps', type: GtGap, path: "[Atoms]/Spacing")
Widget playgroundGapUseCase(BuildContext context) {
  final inComponentGaps = const [
    GtGapRow(gap: GtGap.yXs()),
    GtGapRow(gap: GtGap.ySm()),
    GtGapRow(gap: GtGap.yBase()),
    GtGapRow(gap: GtGap.yMd()),
    GtGapRow(gap: GtGap.yLg()),
    GtGapRow(gap: GtGap.yXl()),
    GtGapRow(gap: GtGap.ySectionSm()),
    GtGapRow(gap: GtGap.ySectionMd()),
  ];

  final outComponentGaps = const [
    GtGapRow(gap: GtGap.ySectionSm()),
    GtGapRow(gap: GtGap.ySectionMd()),
    GtGapRow(gap: GtGap.ySectionLg()),
    GtGapRow(gap: GtGap.ySectionXl()),
    GtGapRow(gap: GtGap.ySection2xl()),
    GtGapRow(gap: GtGap.ySection3xl()),
    GtGapRow(gap: GtGap.ySection4xl()),
  ];
  final xGaps = const [
    GtGapColumn(gap: GtGap.hXs()),
    GtGapColumn(gap: GtGap.hSm()),
    GtGapColumn(gap: GtGap.hBase()),
    GtGapColumn(gap: GtGap.hMd()),
    GtGapColumn(gap: GtGap.hLg()),
    GtGapColumn(gap: GtGap.hXl()),
    GtGapColumn(gap: GtGap.hSectionSm()),
    GtGapColumn(gap: GtGap.hSectionMd()),
    GtGapColumn(gap: GtGap.hSectionLg()),
    GtGapColumn(gap: GtGap.hSectionXl()),
    GtGapColumn(gap: GtGap.hSection2xl()),
    GtGapColumn(gap: GtGap.hSection3xl()),
    GtGapColumn(gap: GtGap.hSection4xl()),
  ];

  final sGaps = const [
    GtGapColumn(gap: GtGap.sXs(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSm(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sBase(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sMd(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sLg(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sXl(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSectionSm(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSectionMd(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSectionLg(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSectionXl(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSection2xl(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSection3xl(), isHorizontal: false),
    GtGapColumn(gap: GtGap.sSection4xl(), isHorizontal: false),
  ];

  return Scaffold(
    body: Padding(
      padding: context.insets.symmetricDp(
        horizontal: context.grid.singleColumn.margins.px,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GalleryPageHeader(
              title: "spacing",
              rider:
                  "Begin by adding an Ellipse shape onto a white background frame – this will allow you to perceive shadows more distinctly.",
              sectionHeader: "Spacing between elements inside components",
            ),
          ),
          SliverList.separated(
            itemBuilder: (_, index) => inComponentGaps[index],
            separatorBuilder: (_, index) => const GtGap.yLg(),
            itemCount: inComponentGaps.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Spacing between Sections"),
          ),
          SliverList.separated(
            itemBuilder: (_, index) => outComponentGaps[index],
            separatorBuilder: (_, index) => const GtGap.yLg(),
            itemCount: outComponentGaps.length,
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Horizontal Spacing"),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              spacing: context.dp(context.spacing.sectionSm.px),
              runSpacing: context.dp(context.spacing.md.px),
              children: xGaps,
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Square Spacing"),
          ),
          SliverPadding(
            padding: context.insets.onlyDp(
              bottom: context.spacing.sectionLg.px,
            ),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: context.dp(context.spacing.sectionSm.px),
                runSpacing: context.dp(context.spacing.md.px),
                children: sGaps,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class GtGapRow extends StatelessWidget {
  final GtGap gap;
  const GtGapRow({required this.gap, super.key});

  @override
  Widget build(BuildContext context) {
    final gapValue = gap.getGap(context);
    return Table(
      columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(10)},
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: [
            Text(
              "${gapValue.toStringAsFixed(0)} px",
              style: context.textStyles.bodyM(),
            ),
            Container(color: context.palette.primary.darker, child: gap),
          ],
        ),
      ],
    );
  }
}

class GtGapColumn extends StatelessWidget {
  final GtGap gap;
  final bool isHorizontal;

  const GtGapColumn({required this.gap, this.isHorizontal = true, super.key});

  @override
  Widget build(BuildContext context) {
    final gapValue = gap.getGap(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: context.dp(context.spacing.xs.px),
      children: [
        Text(
          "${gapValue.toStringAsFixed(0)} px",
          style: context.textStyles.bodyM(),
        ),
        Container(
          color: context.palette.primary.darker,
          height: isHorizontal ? context.dp(10.px) : null,
          child: gap,
        ),
      ],
    );
  }
}
