import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDropdownField', type: GtDropdownField)
Widget playgroundGtDropdownFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Dropdown');
  final sheetTitle = context.knobs.string(
    label: 'Sheet Title',
    initialValue: 'Select an Option',
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all.first,
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet =
      '''
GtDropdownField<String>(
  controller: GtDropdownInputController(),
  options: const [
    GtDropdownData(value: "Option 1", label: "Option 1"),
    GtDropdownData(value: "Option 2", label: "Option 2"),
  ],
  label: "$label",
  sheetTitle: "$sheetTitle",
  isEnabled: $isEnabled,
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtDropdownField',
    description:
        'A text input field that provides a dropdown selection interface via a draggable bottom sheet.',
    code: codeSnippet,
    child: GtDropdownField<String>(
      controller: GtDropdownInputController(),
      options: const [
        GtDropdownData(value: "Option 1", label: "Option 1"),
        GtDropdownData(value: "Option 2", label: "Option 2"),
      ],
      label: label,
      sheetTitle: sheetTitle.isEmpty ? null : sheetTitle,
      isEnabled: isEnabled,
      decoration: decoration.$2,
    ),
  );
}
