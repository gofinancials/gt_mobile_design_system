import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtGuageChart', type: GtGuageChart)
Widget buildGtGuageChartUsecase(BuildContext context) {
  return Scaffold(
    appBar: GtModalAppBar(),
    body: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: context.insets.defaultHorizontalInsets,
          sliver: SliverList.list(
            children: [
              GtPageHeader(
                title: "Guage Charts",
                subtitle: "Simple and effective way to display data.",
                subTitleColor: context.palette.text.darkerSub,
              ),
              const GtGap.ySectionSm(),
            ],
          ),
        ),
        SliverPadding(
          padding: context.insets.defaultAllInsets,
          sliver: SliverGrid.extent(
            maxCrossAxisExtent: 600,
            mainAxisSpacing: context.spacingMd,
            crossAxisSpacing: context.spacingMd,
            children: [
              GtGuageChart(
                value: 0.1,
                center: GtGuageChartCenter(
                  "₦130,000.00",
                  pillText: "5% interest",
                  footerText: "Available to spend: ₦19,000",
                ),
              ),
              GtGuageChart(
                value: 0.5,
                variant: .highlighted,
                center: GtGuageChartCenter(
                  "₦250,000.00",
                  pillText: "5% interest",
                  footerText: "Available to spend: ₦19,000",
                ),
              ),
              GtGuageChart(
                value: 0.9,
                variant: .warning,
                center: GtGuageChartCenter(
                  "₦750,000.00",
                  pillText: "5% interest",
                  footerText: "Available to spend: ₦19,000",
                ),
              ),
              GtGuageChart(
                value: 1,
                variant: .error,
                center: GtGuageChartCenter(
                  "₦1,000,000.00",
                  pillText: "5% interest",
                  footerText: "Available to spend: ₦19,000",
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
