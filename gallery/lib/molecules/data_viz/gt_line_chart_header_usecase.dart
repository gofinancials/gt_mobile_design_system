import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLineChartHeader', type: GtLineChartHeader)
Widget playgroundGtLineChartHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Total Balance',
  );
  final value = context.knobs.string(
    label: 'Value',
    initialValue: '\$12,450.00',
  );
  final range = context.knobs.string(label: 'Range', initialValue: 'Jan - Dec');
  final actionText = context.knobs.string(
    label: 'Action Text',
    initialValue: 'Select Date',
  );
  final isSameDay = context.knobs.boolean(
    label: 'Is Same Day',
    initialValue: false,
  );

  final codeSnippet =
      '''
GtLineChartHeader(
  title: "$title",
  value: "$value",
  range: "$range",
  actionText: "$actionText",
  isSameDay: $isSameDay,
  onTapAction: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtLineChartHeader',
    description:
        'The header section of the GtLineChart displaying balance, range, and filter action.',
    code: codeSnippet,
    child: GtLineChartHeader(
      title: title,
      value: value,
      range: range.isEmpty ? null : range,
      actionText: actionText,
      isSameDay: isSameDay,
      onTapAction: () {},
    ),
  );
}
