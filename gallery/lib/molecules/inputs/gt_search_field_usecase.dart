import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSearchField', type: GtSearchField)
Widget playgroundGtSearchFieldUseCase(BuildContext context) {
  final hintText = context.knobs.string(
    label: "Hint Text",
    initialValue: "Search here...",
  );
  final autoFocus = context.knobs.boolean(
    label: "Auto Focus",
    initialValue: true,
  );
  final isEnabled = context.knobs.boolean(label: "Enabled", initialValue: true);
  final isRequired = context.knobs.boolean(
    label: "Required",
    initialValue: true,
  );
  final helperText = context.knobs.string(
    label: "Helper Text",
    initialValue: "",
  );
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all.first,
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet =
      '''
GtSearchField(
  controller: GtInputController(),
  hintText: "$hintText",
  autoFocus: $autoFocus,
  isEnabled: $isEnabled,
  isRequired: $isRequired,
  helperText: ${helperText.isEmpty ? "null" : '"$helperText"'},
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtSearchField',
    description:
        'A specialized text input field designed specifically for search functionality.',
    code: codeSnippet,
    child: GtSearchField(
      controller: GtInputController(),
      hintText: hintText.isEmpty ? null : hintText,
      autoFocus: autoFocus,
      isEnabled: isEnabled,
      isRequired: isRequired,
      helperText: helperText.isEmpty ? null : helperText,
      decoration: decoration.$2,
    ),
  );
}
