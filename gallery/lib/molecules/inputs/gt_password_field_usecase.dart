import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPasswordField', type: GtPasswordField)
Widget playgroundGtPasswordFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Password');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final minLength = context.knobs.int.slider(label: 'Min Length', initialValue: 6, min: 3, max: 12);
  final decoration = context.knobs.object.dropdown(
    label: 'Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (d) => d.$1,
  );

  final codeSnippet = '''
final _passCtrl = GtInputController();

GtPasswordField(
  controller: _passCtrl,
  label: '$label',
  isEnabled: $isEnabled,
  minLength: $minLength,
  decoration: context.inputStyles.${decoration.$1.toLowerCase()},
)''';

  return GtWidgetDocPage(
    title: 'GtPasswordField',
    description: '''
<b>GtPasswordField</b> is a password input with visibility toggle and minimum length validation.

<b>Features:</b>
• Eye icon toggles password visibility
• Built-in minimum length check automatically enforced inside <b>GtForm</b>.''',
    code: codeSnippet,
    child: SizedBox(
      width: 320.px,
      child: GtPasswordField(
        controller: GtInputController(),
        label: label,
        isEnabled: isEnabled,
        minLength: minLength,
        decoration: decoration.$2,
      ),
    ),
  );
}
