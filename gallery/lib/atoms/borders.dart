// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Borders', type: GtRadii)
Widget playgroundBordersUseCase(BuildContext context) {
  final circularBorders = [
    ('context.borderRadiusXxs', context.borderRadiusXxs),
    ('context.borderRadiusXs', context.borderRadiusXs),
    ('context.borderRadiusSm', context.borderRadiusSm),
    ('context.borderRadiusMd', context.borderRadiusMd),
    ('context.borderRadiusLg', context.borderRadiusLg),
    ('context.borderRadiusXl', context.borderRadiusXl),
    ('context.borderRadius2Xl', context.borderRadius2Xl),
    ('context.borderRadius3Xl', context.borderRadius3Xl),
    ('context.borderRadius4Xl', context.borderRadius4Xl),
    ('context.borderRadius5Xl', context.borderRadius5Xl),
    ('context.borderRadiusFull', context.borderRadiusFull),
  ];
  final borderRadii = [
    ('context.radiusXxs', context.radiusXxs),
    ('context.radiusXs', context.radiusXs),
    ('context.radiusSm', context.radiusSm),
    ('context.radiusMd', context.radiusMd),
    ('context.radiusLg', context.radiusLg),
    ('context.radiusXl', context.radiusXl),
    ('context.radius2Xl', context.radius2Xl),
    ('context.radius3Xl', context.radius3Xl),
    ('context.radius4Xl', context.radius4Xl),
    ('context.radius5Xl', context.radius5Xl),
    ('context.radiusFull', context.radiusFull),
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
              sectionHeader: "Design System Border Radii",
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
                        "DP Value".upper,
                        textAlign: .start,
                        style: context.textStyles.h7(
                          color: context.palette.text.white,
                        ),
                      ),
                    ),
                  ],
                ),
                for (final radius in borderRadii)
                  TableRow(
                    children: [
                      GtCard(
                        borderRadius: .zero,
                        variant: .featured,
                        padding: context.insets.allDp(10.px),
                        child: GtText(radius.$1, textAlign: .start),
                      ),
                      const Offstage(),
                      GtCard(
                        borderRadius: .zero,
                        variant: .highlighted,
                        padding: context.insets.allDp(10.px),
                        child: GtText(
                          "${radius.$2.x.toStringAsFixed(0)}dp",
                          textAlign: .start,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: GalleryPageSectionHeader(title: "Circular Borders"),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              final border = circularBorders[index];
              return GtBorderContainer(
                borderRadius: border.$2,
                label: border.$1,
              );
            },
            itemCount: circularBorders.length,
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
  final String label;

  const GtBorderContainer({
    required this.borderRadius,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dp(200.px),
      padding: context.insets.allDp(10.px),
      decoration: BoxDecoration(
        color: context.palette.primary.base,
        borderRadius: borderRadius,
      ),
      alignment: .center,
      child: Center(
        child: GtText(
          label,
          style: context.textStyles.bodyXs(color: context.palette.text.white),
          textAlign: .center,
        ),
      ),
    );
  }
}
