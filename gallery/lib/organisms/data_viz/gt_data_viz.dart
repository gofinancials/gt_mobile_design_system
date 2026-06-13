import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
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
                  valueColor: context.palette.error.base,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

final _range = DateTimeRange<DateTime>(
  start: .now().subtract(30.days),
  end: .now(),
);
final _calendarCtrl = GtCalendarController(
  GtCalendarValue(range: _range),
  dateRange: DateTimeRange(start: .now().subtract(365.days), end: .now()),
);

List<GtLineChartItem> _lineChartItems(DateTimeRange range) {
  return List.generate(range.duration.inDays, (index) {
    return GtLineChartItem(
      Random().nextDouble() * 100_000_000,
      date: .now().add(index.days),
    );
  });
}

final data = ValueNotifier(_lineChartItems(_range));

@widgetbook.UseCase(name: 'GtLineChart', type: GtLineChartContainer)
Widget buildGtLineChartUsecase(BuildContext context) {
  return Scaffold(
    appBar: GtModalAppBar(),
    body: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: context.insets.defaultHorizontalInsets,
          sliver: SliverList.list(
            children: [
              GtPageHeader(
                title: "Line Charts",
                subtitle: "Simple and effective way to display data.",
                subTitleColor: context.palette.text.darkerSub,
              ),
              const GtGap.ySectionSm(),
            ],
          ),
        ),
        SliverPadding(
          padding: context.insets.defaultAllInsets,
          sliver: SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: data,
              builder: (context, items, _) => GtLineChartContainer(
                items: items,
                calendarTitle: "Select Range",
                title: "Total Balance",
                maxValue: 100_000_000,
                color: context.palette.bg.strong,
                gradient: LinearGradient(
                  colors: [
                    context.palette.error.base,
                    context.palette.away.base,
                    context.palette.success.base,
                  ],
                  stops: [0.2, 0.6, 1],
                  begin: .bottomCenter,
                  end: .topCenter,
                ),
                controller: _calendarCtrl,
                onRangeUpdate: (range) {
                  data.value = _lineChartItems(range);
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
