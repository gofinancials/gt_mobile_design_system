import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAutocompleteField', type: GtAutocompleteField)
Widget playgroundGtAutocompleteFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtAutocompleteField',
    description: 'Documentation for GtAutocompleteField',
    code: '''
GtAutocompleteField<String>(
  controller: GtInputController(),
  suggestions: [
    GtAutocompleteItem(value: "Apple", label: "Apple"),
    GtAutocompleteItem(value: "Banana", label: "Banana"),
  ],
  label: "Fruit",
)
''',
    child: GtAutocompleteField<String>(
      controller: GtInputController(),
      suggestions: [
        GtAutocompleteItem(value: "Apple", label: "Apple"),
        GtAutocompleteItem(value: "Banana", label: "Banana"),
      ],
      label: "Fruit",
    ),
  );
}
