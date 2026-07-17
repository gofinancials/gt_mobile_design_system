import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtForm', type: GtForm)
Widget playgroundGtFormDoc(BuildContext context) {
  final codeSnippet = '''
final _formKey = GlobalKey<FormState>();

GtForm(
  formKey: _formKey,
  child: Column(
    children: [
      GtEmailField(controller: emailCtrl),
      GtPasswordField(controller: passCtrl),
      GtRaisedButton(
        text: 'Validate',
        onPressed: () => context.validateForm(_formKey),
      ),
    ],
  ),
)
''';

  return GtWidgetDocPage(
    title: 'GtForm',
    description: '''
<b>GtForm</b> is a specialized form container that coordinates input validation across nested fields.

It uses an extension <b>context.validateForm(formKey)</b> to trigger validators on all descendent inputs.''',
    code: codeSnippet,
    child: GtEmptyStateCard(
      description:
          'Select "Interactive Preview" in the sidebar\nto test validation behavior on mock inputs.',
      icon: GtIcons.alarmClock,
    ),
  );
}
