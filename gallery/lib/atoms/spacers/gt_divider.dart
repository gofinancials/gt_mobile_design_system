import 'package:flutter/material.dart';
import 'package:gallery/widgets/gallery_page_header.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(
  name: 'Dividers',
  type: GtDivider,
  path: "[Atoms]/Spacing",
)
Widget playgroundDividerUseCase(BuildContext context) {
  final gapColor = context.knobs.object.dropdown<(String, Color)>(
    label: 'Divider Color',
    options: [
      ('Theme Divider Color', Theme.of(context).dividerColor),
      ('Primary Dark', context.palette.primary.darker),
      ('Success Dark', context.palette.success.base),
      ('Error Dark', context.palette.error.base),
      ('Text Strong', context.palette.text.strong),
    ],
    initialOption: ('Theme Divider Color', Theme.of(context).dividerColor),
  );

  final inComponentDividers = [
    GtDividerContainer(divider: GtDivider.xs(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.sm(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.sm(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.base(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.md(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.lg(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.xl(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.sectionSm(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.sectionMd(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.sectionLg(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.sectionXl(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.section2Xl(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.section3Xl(color: gapColor.$2)),
    GtDividerContainer(divider: GtDivider.section4Xl(color: gapColor.$2)),
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
              title: "dividers",
              rider: "Demarcate space between between componments",
            ),
          ),
          SliverPadding(
            padding: context.insets.onlyDp(
              bottom: context.spacing.sectionLg.px,
            ),
            sliver: SliverList.separated(
              itemBuilder: (_, index) => inComponentDividers[index],
              separatorBuilder: (_, index) => const GtGap.yLg(),
              itemCount: inComponentDividers.length,
            ),
          ),
        ],
      ),
    ),
  );
}

class GtDividerContainer extends StatelessWidget {
  final GtDivider divider;
  const GtDividerContainer({required this.divider, super.key});

  @override
  Widget build(BuildContext context) {
    final dividerValue = divider.getDividerSize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Size: ${dividerValue.toStringAsFixed(0)} px".toUpperCase(),
          style: context.textStyles.h4(),
        ),
        divider,
        Text("Thickness: 1px", style: context.textStyles.bodyL()),
      ],
    );
  }
}
