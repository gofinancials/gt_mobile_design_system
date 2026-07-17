import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSectionSlide', type: GtSectionSlide)
Widget playgroundGtSectionSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtSectionSlide',
    description: 'Documentation for GtSectionSlide',
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
)
''',
    child: SizedBox(
      height: 350,
      child: GtSectionSlide(
        title: "Featured Products",
        children: [
          GtProductCard(
            name: "Savings",
            icon: GtIcons.wallet,
            onTap: () {},
          ),
          GtProductCard(
            name: "Investments",
            icon: GtIcons.chartBarTrendUp,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
