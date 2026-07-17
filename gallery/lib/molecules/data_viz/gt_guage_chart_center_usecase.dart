import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtGuageChartCenter', type: GtGuageChartCenter)
Widget playgroundGtGuageChartCenterUseCase(BuildContext context) {
  final valueText = context.knobs.string(
    label: 'Value Text',
    initialValue: '75%',
  );
  final pillText = context.knobs.string(
    label: 'Pill Text',
    initialValue: '+5%',
  );
  final footerText = context.knobs.string(
    label: 'Footer Text',
    initialValue: 'Overall Completion',
  );
  final valueColor = context.knobs.colorOrNull(
    label: 'Value Color',
    initialValue: null,
  );

  final codeSnippet =
      '''
GtGuageChartCenter(
  '$valueText',
  pillText: '$pillText',
  footerText: '$footerText',${valueColor != null ? "\n  valueColor: Color(0x${valueColor.toARGB32().toRadixString(16)})," : ""}
)''';

  return GtWidgetDocPage(
    title: 'GtGuageChartCenter',
    description:
        'A widget designed to display centered content within a GtGuageChart.',
    code: codeSnippet,
    child: Center(
      child: GtGuageChartCenter(
        valueText,
        pillText: pillText.isEmpty ? null : pillText,
        footerText: footerText.isEmpty ? null : footerText,
        valueColor: valueColor,
      ),
    ),
  );
}
