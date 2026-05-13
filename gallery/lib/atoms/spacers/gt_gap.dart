import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Gaps', type: GtGap)
Widget playgroundGapUseCase(BuildContext context) {
  final inComponentGaps = const [
    GtGapRow(gap: GtGap.yXs(), label: "GtGap.yXs"),
    GtGapRow(gap: GtGap.ySm(), label: "GtGap.ySm"),
    GtGapRow(gap: GtGap.yBase(), label: "GtGap.yBase"),
    GtGapRow(gap: GtGap.yMd(), label: "GtGap.yMd"),
    GtGapRow(gap: GtGap.yLg(), label: "GtGap.yLg"),
    GtGapRow(gap: GtGap.yXl(), label: "GtGap.yXl"),
    GtGapRow(gap: GtGap.ySectionSm(), label: "GtGap.ySectionSm"),
    GtGapRow(gap: GtGap.ySectionMd(), label: "GtGap.ySectionMd"),
  ];

  final outComponentGaps = const [
    GtGapRow(gap: GtGap.ySectionSm(), label: "GtGap.ySectionSm"),
    GtGapRow(gap: GtGap.ySectionMd(), label: "GtGap.ySectionMd"),
    GtGapRow(gap: GtGap.ySectionLg(), label: "GtGap.ySectionLg"),
    GtGapRow(gap: GtGap.ySectionXl(), label: "GtGap.ySectionXl"),
    GtGapRow(gap: GtGap.ySection2xl(), label: "GtGap.ySection2xl"),
    GtGapRow(gap: GtGap.ySection3xl(), label: "GtGap.ySection3xl"),
    GtGapRow(gap: GtGap.ySection4xl(), label: "GtGap.ySection4xl"),
  ];
  final xGaps = const [
    GtGapColumn(gap: GtGap.hXs(), label: "GtGap.hXs"),
    GtGapColumn(gap: GtGap.hSm(), label: "GtGap.hSm"),
    GtGapColumn(gap: GtGap.hBase(), label: "GtGap.hBase"),
    GtGapColumn(gap: GtGap.hMd(), label: "GtGap.hMd"),
    GtGapColumn(gap: GtGap.hLg(), label: "GtGap.hLg"),
    GtGapColumn(gap: GtGap.hXl(), label: "GtGap.hXl"),
    GtGapColumn(gap: GtGap.hSectionSm(), label: "GtGap.hSectionSm"),
    GtGapColumn(gap: GtGap.hSectionMd(), label: "GtGap.hSectionMd"),
    GtGapColumn(gap: GtGap.hSectionLg(), label: "GtGap.hSectionLg"),
    GtGapColumn(gap: GtGap.hSectionXl(), label: "GtGap.hSectionXl"),
    GtGapColumn(gap: GtGap.hSection2xl(), label: "GtGap.hSection2xl"),
    GtGapColumn(gap: GtGap.hSection3xl(), label: "GtGap.hSection3xl"),
    GtGapColumn(gap: GtGap.hSection4xl(), label: "GtGap.hSection4xl"),
  ];

  final sGaps = const [
    GtGapColumn(gap: GtGap.sXs(), label: "GtGap.sXs", isHorizontal: false),
    GtGapColumn(gap: GtGap.sSm(), label: "GtGap.sSm", isHorizontal: false),
    GtGapColumn(gap: GtGap.sBase(), label: "GtGap.sBase", isHorizontal: false),
    GtGapColumn(gap: GtGap.sMd(), label: "GtGap.sMd", isHorizontal: false),
    GtGapColumn(gap: GtGap.sLg(), label: "GtGap.sLg", isHorizontal: false),
    GtGapColumn(gap: GtGap.sXl(), label: "GtGap.sXl", isHorizontal: false),
    GtGapColumn(
      gap: GtGap.sSectionSm(),
      label: "GtGap.sSectionSm",
      isHorizontal: false,
    ),
    GtGapColumn(
      gap: GtGap.sSectionMd(),
      label: "GtGap.sSectionMd",
      isHorizontal: false,
    ),
    GtGapColumn(
      gap: GtGap.sSectionLg(),
      label: "GtGap.sSectionLg",
      isHorizontal: false,
    ),
    GtGapColumn(
      gap: GtGap.sSectionXl(),
      label: "GtGap.sSectionXl",
      isHorizontal: false,
    ),
    GtGapColumn(
      gap: GtGap.sSection2xl(),
      label: "GtGap.sSection2xl",
      isHorizontal: false,
    ),
    GtGapColumn(
      gap: GtGap.sSection3xl(),
      label: "GtGap.sSection3xl",
      isHorizontal: false,
    ),
    GtGapColumn(
      gap: GtGap.sSection4xl(),
      label: "GtGap.sSection4xl",
      isHorizontal: false,
    ),
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
              sectionHeader: "Spacing Primitives (for column/row/wraps)",
            ),
          ),
          SliverToBoxAdapter(
            child: Table(
              defaultVerticalAlignment: .middle,
              columnWidths: {
                0: const FlexColumnWidth(4),
                1: const FixedColumnWidth(5),
                2: const FlexColumnWidth(4),
              },
              children: [
                TableRow(
                  children: [
                    GtCard(
                      borderRadius: .zero,
                      color: context.palette.feature.base,
                      padding: context.insets.allDp(10.px),
                      child: GtText(
                        "Accessor".upper,
                        textAlign: .start,
                        style: context.textStyles.h7(
                          color: context.palette.text.white,
                        ),
                      ),
                    ),
                    const Offstage(),
                    GtCard(
                      borderRadius: .zero,
                      color: context.palette.highlighted.base,
                      padding: context.insets.allDp(10.px),
                      child: GtText(
                        "Spacing Value".upper,
                        textAlign: .start,
                        style: context.textStyles.h7(
                          color: context.palette.text.white,
                        ),
                      ),
                    ),
                  ],
                ),
                for (final spacing in context.spacing.all)
                  TableRow(
                    children: [
                      GtCard(
                        borderRadius: .zero,
                        variant: .featured,
                        padding: context.insets.allDp(10.px),
                        child: GtText(spacing.label, textAlign: .start),
                      ),
                      const Offstage(),
                      GtCard(
                        borderRadius: .zero,
                        variant: .highlighted,
                        padding: context.insets.allDp(10.px),
                        child: GtText("${spacing.value}px", textAlign: .start),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(
              title: "Spacing between elements inside components",
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
  final String label;

  const GtGapRow({required this.gap, required this.label, super.key});

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
              "$label (${gapValue.toStringAsFixed(0)}px)",
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
  final String label;
  final bool isHorizontal;

  const GtGapColumn({
    required this.gap,
    required this.label,
    this.isHorizontal = true,
    super.key,
  });

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
          "$label (${gapValue.toStringAsFixed(0)}px)",
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
