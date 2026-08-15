import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCountIndicator', type: GtCountIndicator)
Widget gtCountIndicatorUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Count Indicator",
    description:
        "A circular badge used to display numeric counts, such as unread notifications.",
    code: '''
GtCountIndicator(
  3,
  type: GtCountIndicatorType.error,
)
''',
    child: Center(
      child: GtCountIndicator(
        context.knobs.int.slider(
          label: 'Count',
          initialValue: 3,
          min: 0,
          max: 20,
        ),
        type: context.knobs.object.dropdown<GtCountIndicatorType>(
          label: 'Type',
          options: GtCountIndicatorType.values,
          initialOption: GtCountIndicatorType.error,
        ),
        size: context.knobs.double.slider(
          label: 'Size',
          initialValue: 20,
          min: 10,
          max: 50,
        ),
      ),
    ),
  );
}
