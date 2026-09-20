import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtUrlField', type: GtUrlField)
Widget playgroundGtUrlFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'URL');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isRequired = context.knobs.boolean(
    label: 'Required',
    initialValue: true,
  );
  final errorMessage = context.knobs.stringOrNull(
    label: 'Error Message',
    initialValue: null,
  );
  final emptyMessage = context.knobs.stringOrNull(
    label: 'Empty Message',
    initialValue: null,
  );
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all.first,
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet =
      '''
GtUrlField(
  controller: GtInputController(),
  label: "$label",
  isEnabled: $isEnabled,
  isRequired: $isRequired,
  errorMessage: ${errorMessage == null ? 'null' : '"$errorMessage"'},
  emptyMessage: ${emptyMessage == null ? 'null' : '"$emptyMessage"'},
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtUrlField',
    description:
        'A text field specialized for entering URLs with standard URL format validation.',
    code: codeSnippet,
    child: GtUrlField(
      controller: GtInputController(),
      label: label,
      isEnabled: isEnabled,
      isRequired: isRequired,
      errorMessage: errorMessage,
      emptyMessage: emptyMessage,
      decoration: decoration.$2,
    ),
  );
}
