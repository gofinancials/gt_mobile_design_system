import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCopyPill', type: GtCopyPill)
Widget playgroundGtCopyPillUseCase(BuildContext context) {
  final value = context.knobs.string(label: 'Copy Value', initialValue: '1234567890');
  final text = context.knobs.string(label: 'Display Text', initialValue: 'COPY CODE');
  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Variant',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.strong,
    labelBuilder: (v) => v.name,
  );

  final codeSnippet = '''
GtCopyPill(
  "$value",
  text: "$text",
  variant: GtPillVariant.${variant.name},
)''';

  return GtWidgetDocPage(
    title: 'GtCopyPill',
    description: 'A button pill that automatically copies its target value to the clipboard and gives haptic feedback on tap.',
    code: codeSnippet,
    child: Center(
      child: GtCopyPill(
        value,
        text: text.isEmpty ? null : text,
        variant: variant,
      ),
    ),
  );
}
