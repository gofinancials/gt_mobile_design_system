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
  final pillColor = context.knobs.colorOrNull(
    label: 'Pill Color',
    initialValue: null,
  );
  final dashboardStyles = context.knobs.boolean(
    label: 'Dashboard Text Styles (12)',
    initialValue: false,
  );

  TextStyle? pillTextStyle;
  TextStyle? footerStyle;
  if (dashboardStyles) {
    pillTextStyle = context.textStyles.labelXs(
      color: context.palette.text.strong,
    );
    footerStyle = context.textStyles.bodyXs(color: context.palette.text.soft);
  }

  final codeSnippet =
      '''
GtGuageChartCenter(
  '$valueText',
  pillText: '$pillText',
  footerText: '$footerText',${valueColor != null ? "\n  valueColor: Color(0x${valueColor.toARGB32().toRadixString(16)})," : ""}${pillColor != null ? "\n  pillColor: Color(0x${pillColor.toARGB32().toRadixString(16)})," : ""}${dashboardStyles ? "\n  pillTextStyle: context.textStyles.labelXs(\n    color: context.palette.text.strong,\n  ),\n  footerStyle: context.textStyles.bodyXs(\n    color: context.palette.text.soft,\n  )," : ""}
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
        pillColor: pillColor,
        pillTextStyle: pillTextStyle,
        footerStyle: footerStyle,
      ),
    ),
  );
}
