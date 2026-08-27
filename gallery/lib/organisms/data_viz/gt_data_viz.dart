import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtGuageChart', type: GtGuageChart)
Widget buildGtGuageChartUsecase(BuildContext context) {
  final value = context.knobs.double.slider(
    label: 'Guage Progress',
    initialValue: 0.5,
    min: 0.0,
    max: 1.0,
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Guage Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.highlighted,
    labelBuilder: (v) => v.name,
  );
  final centerValue = context.knobs.string(
    label: 'Center Value Text',
    initialValue: '₦ 250,000.00',
  );
  final pillText = context.knobs.string(
    label: 'Pill Text',
    initialValue: '5% interest',
  );
  final footerText = context.knobs.string(
    label: 'Footer Text',
    initialValue: 'Available to spend: ₦ 19,000',
  );

  return GtWidgetDocPage(
    title: 'GtGuageChart',
    description:
        'A circular gauge chart used for representing progress or metrics.',
    code:
        '''
GtGuageChart(
  value: $value,
  variant: GtCardVariant.${variant.name},
  center: GtGuageChartCenter(
    "$centerValue",
    pillText: "$pillText",
    footerText: "$footerText",
  ),
)''',
    child: GtGuageChart(
      value: value,
      variant: variant,
      center: GtGuageChartCenter(
        centerValue,
        pillText: pillText,
        footerText: footerText,
      ),
    ),
  );
}

List<GtLineChartItem> _lineChartItems(DateTimeRange range) {
  return List.generate(range.duration.inDays, (index) {
    return GtLineChartItem(
      Random().nextDouble() * 100000000,
      date: DateTime.now().add(Duration(days: index)),
    );
  });
}

@widgetbook.UseCase(name: 'GtLineChartContainer', type: GtLineChartContainer)
Widget buildGtLineChartUsecase(BuildContext context) {
  return const _LineChartPreview();
}

class _LineChartPreview extends GtStatefulWidget {
  const _LineChartPreview();

  @override
  State<_LineChartPreview> createState() => _LineChartPreviewState();
}

class _LineChartPreviewState extends State<_LineChartPreview> {
  late final DateTimeRange<DateTime> _range;
  late final GtCalendarController _calendarCtrl;
  late final ValueNotifier<List<GtLineChartItem>> _data;

  @override
  void initState() {
    super.initState();
    _range = DateTimeRange<DateTime>(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
    _calendarCtrl = GtCalendarController(
      GtCalendarValue(range: _range),
      dateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 365)),
        end: DateTime.now(),
      ),
    );
    _data = ValueNotifier(_lineChartItems(_range));
  }

  @override
  void dispose() {
    _calendarCtrl.dispose();
    _data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hideYAxisLabels = context.knobs.boolean(
      label: 'Hide Y Axis Labels',
      initialValue: false,
    );
    final calendarTitle = context.knobs.string(
      label: 'Calendar Title',
      initialValue: 'Select Range',
    );
    final title = context.knobs.string(
      label: 'Chart Title',
      initialValue: 'Total Balance',
    );
    final maxValue = context.knobs.double.input(
      label: 'Max Y Value',
      initialValue: 100000000.0,
    );

    return GtWidgetDocPage(
      title: 'GtLineChartContainer',
      description:
          'A container combining a header, date range filter, and an interactive line chart.',
      code:
          '''
GtLineChartContainer(
  items: [],
  calendarTitle: "$calendarTitle",
  title: "$title",
  maxValue: $maxValue,
  hideYAxisLabels: $hideYAxisLabels,
  controller: calendarController,
  onRangeUpdate: (range) {},
)''',
      child: Center(
        child: ListListener<GtLineChartItem>(
          valueListenable: _data,
          builder: (items) => GtLineChartContainer(
            items: items,
            calendarTitle: calendarTitle,
            title: title,
            maxValue: maxValue,
            color: context.palette.bg.strong,
            hideYAxisLabels: hideYAxisLabels,
            controller: _calendarCtrl,
            onRangeUpdate: (range) {
              _data.value = _lineChartItems(range);
            },
          ),
        ),
      ),
    );
  }
}
