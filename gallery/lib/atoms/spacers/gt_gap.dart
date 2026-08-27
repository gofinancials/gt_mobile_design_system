import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Gaps', type: GtGap)
Widget playgroundGapUseCase(BuildContext context) {
  return const _GapsPlayground();
}

class _GapsPlayground extends GtStatefulWidget {
  const _GapsPlayground();

  @override
  State<_GapsPlayground> createState() => _GapsPlaygroundState();
}

class _GapsPlaygroundState extends State<_GapsPlayground> {
  late final GtTabController<String> _controller;
  late final List<GtTabData<String>> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      GtTabData(label: "Vertical Gaps", value: "vertical"),
      GtTabData(label: "Horizontal Gaps", value: "horizontal"),
      GtTabData(label: "Square Gaps", value: "square"),
    ];
    _controller = GtTabController<String>(initialValue: _tabs.first);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bg.white,
      body: SafeArea(
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GtTabbar<String>(controller: _controller, tabs: _tabs),
              const GtGap.yMd(),
              Expanded(
                child: GtTabbarView<String>.lazy(
                  controller: _controller,
                  tabs: _tabs,
                  tabBuilders: {
                    "vertical": (_) => GtWidgetDocPage(
                      title: "Vertical Gaps (y)",
                      description:
                          "Use y-gaps inside columns to space out elements vertically.",
                      code: '''
const GtGap.yXs()         // 2px
const GtGap.ySm()         // 4px
const GtGap.yBase()       // 8px
const GtGap.yMd()         // 12px
const GtGap.yLg()         // 16px
const GtGap.yXl()         // 20px
const GtGap.ySectionSm()  // 24px
const GtGap.ySectionMd()  // 32px
const GtGap.ySectionLg()  // 40px
const GtGap.ySectionXl()  // 48px
const GtGap.ySection2xl() // 64px
const GtGap.ySection3xl() // 80px
const GtGap.ySection4xl() // 96px''',
                      child: Column(
                        spacing: context.spacingLg,
                        children: const [
                          GtGapRow(gap: GtGap.yXs(), label: "GtGap.yXs"),
                          GtGapRow(gap: GtGap.ySm(), label: "GtGap.ySm"),
                          GtGapRow(gap: GtGap.yBase(), label: "GtGap.yBase"),
                          GtGapRow(gap: GtGap.yMd(), label: "GtGap.yMd"),
                          GtGapRow(gap: GtGap.yLg(), label: "GtGap.yLg"),
                          GtGapRow(gap: GtGap.yXl(), label: "GtGap.yXl"),
                          GtGapRow(
                            gap: GtGap.ySectionSm(),
                            label: "GtGap.ySectionSm",
                          ),
                          GtGapRow(
                            gap: GtGap.ySectionMd(),
                            label: "GtGap.ySectionMd",
                          ),
                          GtGapRow(
                            gap: GtGap.ySectionLg(),
                            label: "GtGap.ySectionLg",
                          ),
                          GtGapRow(
                            gap: GtGap.ySectionXl(),
                            label: "GtGap.ySectionXl",
                          ),
                          GtGapRow(
                            gap: GtGap.ySection2xl(),
                            label: "GtGap.ySection2xl",
                          ),
                          GtGapRow(
                            gap: GtGap.ySection3xl(),
                            label: "GtGap.ySection3xl",
                          ),
                          GtGapRow(
                            gap: GtGap.ySection4xl(),
                            label: "GtGap.ySection4xl",
                          ),
                        ],
                      ),
                    ),
                    "horizontal": (_) => GtWidgetDocPage(
                      title: "Horizontal Gaps (h)",
                      description:
                          "Use h-gaps inside rows to space out elements horizontally.",
                      code: '''
const GtGap.hXs()         // 2px
const GtGap.hSm()         // 4px
const GtGap.hBase()       // 8px
const GtGap.hMd()         // 12px
const GtGap.hLg()         // 16px
const GtGap.hXl()         // 20px
const GtGap.hSectionSm()  // 24px
const GtGap.hSectionMd()  // 32px
const GtGap.hSectionLg()  // 40px
const GtGap.hSectionXl()  // 48px
const GtGap.hSection2xl() // 64px
const GtGap.hSection3xl() // 80px
const GtGap.hSection4xl() // 96px''',
                      child: Wrap(
                        spacing: context.dp(context.spacing.sectionSm.px),
                        runSpacing: context.dp(context.spacing.md.px),
                        children: const [
                          GtGapColumn(gap: GtGap.hXs(), label: "GtGap.hXs"),
                          GtGapColumn(gap: GtGap.hSm(), label: "GtGap.hSm"),
                          GtGapColumn(gap: GtGap.hBase(), label: "GtGap.hBase"),
                          GtGapColumn(gap: GtGap.hMd(), label: "GtGap.hMd"),
                          GtGapColumn(gap: GtGap.hLg(), label: "GtGap.hLg"),
                          GtGapColumn(gap: GtGap.hXl(), label: "GtGap.hXl"),
                          GtGapColumn(
                            gap: GtGap.hSectionSm(),
                            label: "GtGap.hSectionSm",
                          ),
                          GtGapColumn(
                            gap: GtGap.hSectionMd(),
                            label: "GtGap.hSectionMd",
                          ),
                          GtGapColumn(
                            gap: GtGap.hSectionLg(),
                            label: "GtGap.hSectionLg",
                          ),
                          GtGapColumn(
                            gap: GtGap.hSectionXl(),
                            label: "GtGap.hSectionXl",
                          ),
                          GtGapColumn(
                            gap: GtGap.hSection2xl(),
                            label: "GtGap.hSection2xl",
                          ),
                          GtGapColumn(
                            gap: GtGap.hSection3xl(),
                            label: "GtGap.hSection3xl",
                          ),
                          GtGapColumn(
                            gap: GtGap.hSection4xl(),
                            label: "GtGap.hSection4xl",
                          ),
                        ],
                      ),
                    ),
                    "square": (_) => GtWidgetDocPage(
                      title: "Square / Symmetrical Gaps (s)",
                      description:
                          "Creates a square space block (both height and width constrained).",
                      code: '''
const GtGap.sXs()         // 2px
const GtGap.sSm()         // 4px
const GtGap.sBase()       // 8px
const GtGap.sMd()         // 12px
const GtGap.sLg()         // 16px
const GtGap.sXl()         // 20px
const GtGap.sSectionSm()  // 24px
const GtGap.sSectionMd()  // 32px
const GtGap.sSectionLg()  // 40px
const GtGap.sSectionXl()  // 48px
const GtGap.sSection2xl() // 64px
const GtGap.sSection3xl() // 80px
const GtGap.sSection4xl() // 96px''',
                      child: Wrap(
                        spacing: context.dp(context.spacing.sectionSm.px),
                        runSpacing: context.dp(context.spacing.md.px),
                        children: const [
                          GtGapColumn(
                            gap: GtGap.sXs(),
                            label: "GtGap.sXs",
                            isHorizontal: false,
                          ),
                          GtGapColumn(
                            gap: GtGap.sSm(),
                            label: "GtGap.sSm",
                            isHorizontal: false,
                          ),
                          GtGapColumn(
                            gap: GtGap.sBase(),
                            label: "GtGap.sBase",
                            isHorizontal: false,
                          ),
                          GtGapColumn(
                            gap: GtGap.sMd(),
                            label: "GtGap.sMd",
                            isHorizontal: false,
                          ),
                          GtGapColumn(
                            gap: GtGap.sLg(),
                            label: "GtGap.sLg",
                            isHorizontal: false,
                          ),
                          GtGapColumn(
                            gap: GtGap.sXl(),
                            label: "GtGap.sXl",
                            isHorizontal: false,
                          ),
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
                        ],
                      ),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GtGapRow extends StatelessWidget {
  final GtGap gap;
  final String label;

  const GtGapRow({required this.gap, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final gapValue = gap.getGap(context);
    return Table(
      columnWidths: const {0: FlexColumnWidth(5), 1: FlexColumnWidth(7)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            GtText(
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
        GtText(
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
