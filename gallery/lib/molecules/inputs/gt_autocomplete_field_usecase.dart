import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAutocompleteField', type: GtAutocompleteField)
Widget playgroundGtAutocompleteFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Fruit');
  final hintText = context.knobs.string(label: 'Hint Text', initialValue: 'Type to search fruits...');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet = '''
GtAutocompleteField<String>(
  controller: GtInputController(),
  suggestions: [
    GtAutocompleteItem(value: "Apple", label: "Apple"),
    GtAutocompleteItem(value: "Banana", label: "Banana"),
    GtAutocompleteItem(value: "Orange", label: "Orange"),
  ],
  label: "$label",
  hintText: "$hintText",
  isEnabled: $isEnabled,
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtAutocompleteField',
    description: 'A text input field that provides a list of selectable suggestions as the user types.',
    code: codeSnippet,
    child: GtAutocompleteField<String>(
      controller: GtInputController(),
      suggestions: const [
        GtAutocompleteItem(value: "Apple", label: "Apple"),
        GtAutocompleteItem(value: "Banana", label: "Banana"),
        GtAutocompleteItem(value: "Orange", label: "Orange"),
      ],
      label: label,
      hintText: hintText.isEmpty ? null : hintText,
      isEnabled: isEnabled,
      decoration: decoration.$2,
    ),
  );
}
