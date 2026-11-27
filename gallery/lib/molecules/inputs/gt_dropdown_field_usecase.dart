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
  final showSearch = context.knobs.boolean(
    label: 'Show Search',
    initialValue: true,
  );
  final primaryTick = context.knobs.boolean(
    label: 'Primary Tick',
    initialValue: false,
  );
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
  showSearch: $showSearch,${primaryTick ? '\n  tickColor: context.palette.primary.base,' : ''}
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtDropdownField',
    description:
        'A text input field that provides a dropdown selection interface via '
        'a draggable bottom sheet. The chosen option\'s tick defaults to the '
        'palette\'s success color; tickColor restyles it, such as primary to '
        'match a design that draws it in the brand color.',
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
      showSearch: showSearch,
      tickColor: primaryTick ? context.palette.primary.base : null,
      decoration: decoration.$2,
    ),
  );
}
