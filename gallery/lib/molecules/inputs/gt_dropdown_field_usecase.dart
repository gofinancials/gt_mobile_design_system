import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDropdownField', type: GtDropdownField)
Widget playgroundGtDropdownFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtDropdownField',
    description: 'Documentation for GtDropdownField',
    code: '''
GtDropdownField<String>(
  controller: GtDropdownInputController(),
  options: const [
    GtDropdownData(value: "Option 1", label: "Option 1"),
    GtDropdownData(value: "Option 2", label: "Option 2"),
  ],
  label: "Dropdown",
)
''',
    child: GtDropdownField<String>(
      controller: GtDropdownInputController(),
      options: const [
        GtDropdownData(value: "Option 1", label: "Option 1"),
        GtDropdownData(value: "Option 2", label: "Option 2"),
      ],
      label: "Dropdown",
    ),
  );
}
