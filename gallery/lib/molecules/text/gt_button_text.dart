import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Button Text', type: GtButtonText)
Widget playgroundGtButtonTextUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'SUBMIT TRANSACTION',
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final size = context.knobs.object.dropdown(
    label: 'Button Size',
    options: GtButtonSize.values,
    initialOption: GtButtonSize.large,
    labelBuilder: (s) => s.name,
  );
  final textCase = context.knobs.object.dropdown(
    label: 'Text Case',
    options: GtButtonTextCase.values,
    initialOption: GtButtonTextCase.upper,
    labelBuilder: (c) => c.name,
  );

  final codeSnippet =
      '''
GtButtonText(
  "$text",
  disabled: $disabled,
  size: GtButtonSize.${size.name},
  textCase: GtButtonTextCase.${textCase.name},
)''';

  return GtWidgetDocPage(
    title: 'GtButtonText',
    description:
        'A specialized text widget used inside buttons supporting cases, styles, and leading/trailing icons.',
    code: codeSnippet,
    child: Center(
      child: GtButtonText(
        text,
        disabled: disabled,
        size: size,
        textCase: textCase,
      ),
    ),
  );
}
