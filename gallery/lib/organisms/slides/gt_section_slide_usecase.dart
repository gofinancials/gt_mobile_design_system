import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSectionSlide', type: GtSectionSlide)
Widget playgroundGtSectionSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtSectionSlide',
    description:
        'A horizontal scrollable section for displaying a series of slides or cards.',
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
    child: GtEmptyStateCard(
      variant: GtCardVariant.normal,
      icon: GtIcons.alarmClock,
      description:
          "Please refer to the visual display page in Widgetbook to preview the section slide widgets in their full horizontal-scroll context.",
    ),
  );
}
