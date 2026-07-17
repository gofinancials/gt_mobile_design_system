import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSectionSlide', type: GtSectionSlide)
Widget playgroundGtSectionSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtSectionSlide',
    description: 'A horizontal scrollable section for displaying a series of slides or cards.',
    code: '''
GtSectionSlide(
  title: "Featured Products",
  children: [
    GtProductCard(
      name: "Savings",
      icon: GtIcons.wallet,
      onTap: () {},
    ),
    GtProductCard(
      name: "Investments",
      icon: GtIcons.chart,
      onTap: () {},
    ),
  ],
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(24.px),
        variant: GtCardVariant.normal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: context.spacingMd,
          children: [
            const GtIcon(GtIcons.spark, size: 48),
            GtText(
              "Please refer to the visual display page in Widgetbook to preview the section slide widgets in their full horizontal-scroll context.",
              style: context.textStyles.bodyS(color: context.palette.text.sub),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
