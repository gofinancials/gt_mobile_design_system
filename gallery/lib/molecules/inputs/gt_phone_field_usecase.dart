import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPhoneField', type: GtPhoneField)
Widget playgroundGtPhoneFieldUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Phone number');
  final showCountryCode = context.knobs.boolean(label: 'Show Country Code', initialValue: true);
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isRequired = context.knobs.boolean(label: 'Required', initialValue: true);
  final decoration = context.knobs.object.dropdown<(String, GtInputDecoration)>(
    label: 'Input Style',
    options: context.inputStyles.all,
    initialOption: context.inputStyles.all[1],
    labelBuilder: (v) => v.$1,
  );

  final codeSnippet = '''
GtPhoneField(
  label: '$label',
  showCountryCode: $showCountryCode,
  isEnabled: $isEnabled,
  isRequired: $isRequired,
  decoration: /* Selected: ${decoration.$1} */,
)''';

  return GtWidgetDocPage(
    title: 'GtPhoneField',
    description: '''
<b>GtPhoneField</b> is a phone number input with optional country code selector.

<b>Features:</b>
• Country code selector with flag and dial code
• Auto-formats phone number
• Async search across countries''',
    code: codeSnippet,
    child: SizedBox(
      width: 320.px,
      child: GtPhoneField(
        label: label,
        showCountryCode: showCountryCode,
        isEnabled: isEnabled,
        isRequired: isRequired,
        decoration: decoration.$2,
      ),
    ),
  );
}
