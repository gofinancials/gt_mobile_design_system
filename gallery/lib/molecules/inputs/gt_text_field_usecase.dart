import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTextField', type: GtTextField)
Widget playgroundGtTextFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Name');
  final hintText = context.knobs.string(label: 'Hint Text', initialValue: 'Enter your name');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet = '''
GtTextField(
  controller: GtInputController(),
  label: "$label",
  hintText: "$hintText",
  isEnabled: $isEnabled,
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtTextField',
    description: 'A customizable text input field conforming to the design system styling.',
    code: codeSnippet,
    child: GtTextField(
      controller: GtInputController(),
      label: label,
      hintText: hintText.isEmpty ? null : hintText,
      isEnabled: isEnabled,
      decoration: decoration.$2,
    ),
  );
}
