import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCountdownPie', type: GtCountdownPie)
Widget gtCountdownPieUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Countdown Pie",
    description:
        "A circular countdown indicator that acts as a shrinking pie chart.",
    code: '''
GtCountdownPie(
  duration: Duration(seconds: 10),
)
''',
    child: Center(
      child: GtCountdownPie(
        duration: Duration(
          seconds: context.knobs.int.slider(
            label: 'Seconds',
            initialValue: 10,
            min: 5,
            max: 60,
          ),
        ),
        size: context.knobs.double.slider(
          label: 'Size',
          initialValue: 52,
          min: 30,
          max: 100,
        ),
        strokeWidth: context.knobs.double.slider(
          label: 'Stroke Width',
          initialValue: 4.0,
          min: 2.0,
          max: 10.0,
        ),
      ),
    ),
  );
}
