// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Shadows', type: GtShadows, path: "[Atoms]")
Widget playgroundShadowsUseCase(BuildContext context) {
  final shadows = [
    (context.shadows.xs, "X-Small"),
    (context.shadows.sm, "Small"),
    (context.shadows.md, "Medium"),
    (context.shadows.lg, "Large"),
  ];
  final delegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: context.dp(300.px),
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
              title: "Shadows",
              rider:
                  "Shadows are used to create depth and visual hierarchy. They can be used to create cards, buttons, and other UI elements.",
            ),
          ),
          SliverGrid.builder(
            itemBuilder: (_, index) {
              return GtShadowContainer(
                shadow: shadows[index].$1(),
                label: shadows[index].$2,
              );
            },
            itemCount: shadows.length,
            gridDelegate: delegate,
          ),
          SliverToBoxAdapter(child: GtGap.ySectionLg()),
        ],
      ),
    ),
  );
}

class GtShadowContainer extends StatelessWidget {
  final List<BoxShadow> shadow;
  final String label;

  const GtShadowContainer({
    required this.shadow,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.dp(context.spacing.md.px),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.upper, style: context.textStyles.h5()),
        Container(
          height: context.dp(150.px),
          decoration: BoxDecoration(
            color: context.palette.bg.soft,
            borderRadius: context.dp(context.radii.md.px).circularBorderRadius,
          ),
          alignment: Alignment.bottomLeft,
          child: Center(
            child: Container(
              width: context.dp(80.px),
              decoration: BoxDecoration(
                color: context.palette.bg.white,
                shape: BoxShape.circle,
                boxShadow: shadow,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
