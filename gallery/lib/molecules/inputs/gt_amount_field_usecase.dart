import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAmountField', type: GtAmountField)
Widget playgroundGtAmountFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Amount');
  final min = context.knobs.double.slider(
    label: 'Min Amount',
    initialValue: 100.0,
    min: 0.0,
    max: 1000.0,
  );
  final max = context.knobs.double.slider(
    label: 'Max Amount',
    initialValue: 1000000.0,
    min: 10000.0,
    max: 5000000.0,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all.first,
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet =
      '''
final _amountCtrl = GtInputController();

GtAmountField(
  controller: _amountCtrl,
  label: '$label',
  min: $min,
  max: $max,
  decoration: /* Selected: ${decoration.$1} */,
  isEnabled: $isEnabled,
  isRequired: $isRequired,
)''';

  return GtWidgetDocPage(
    title: 'GtAmountField',
    description: '''
<b>GtAmountField</b> is a currency input with automatic Naira formatting and min/max limits.

<b>Features:</b>
• Auto-formats with ₦ symbol
• Validates minimum and maximum amounts
• Rejects non-numeric input''',
    code: codeSnippet,
    child: GtAmountField(
      controller: GtInputController(),
      label: label,
      min: min,
      max: max,
      decoration: decoration.$2,
      isEnabled: isEnabled,
      isRequired: isRequired,
    ),
  );
}
