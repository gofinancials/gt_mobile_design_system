import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtEmailField', type: GtEmailField)
Widget playgroundGtEmailFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Email address');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isRequired = context.knobs.boolean(label: 'Required', initialValue: true);
  final decoration = context.knobs.object.dropdown(
    label: 'Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (d) => d.$1,
  );

  final codeSnippet = '''
final _emailCtrl = GtInputController();

GtEmailField(
  controller: _emailCtrl,
  label: '$label',
  isEnabled: $isEnabled,
  isRequired: $isRequired,
  decoration: context.inputStyles.${decoration.$1.toLowerCase()},
)''';

  return GtWidgetDocPage(
    title: 'GtEmailField',
    description: '''
<b>GtEmailField</b> is a specialised text input for email addresses with built-in validation.

<b>Validation:</b> Uses standard email regex and required field validations automatically when validated inside a <b>GtForm</b>.''',
    code: codeSnippet,
    child: SizedBox(
      width: 320.px,
      child: GtEmailField(
        controller: GtInputController(),
        label: label,
        isEnabled: isEnabled,
        isRequired: isRequired,
        decoration: decoration.$2,
      ),
    ),
  );
}
