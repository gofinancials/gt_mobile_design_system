import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtVirtualKeypadForm', type: GtVirtualKeypadForm)
Widget playgroundGtVirtualKeypadFormDoc(BuildContext context) {
  const codeSnippet = '''
GtVirtualKeypadForm(
  formKey: formKey,
  controller: pinController,
  title: 'Enter PIN',
  subtitle: 'Please enter your secure 4-digit transaction PIN.',
  maxLength: 4,
  fillInactiveDots: false,
  onBioAuth: () {
    // Biometric Auth callback
  },
  action: GtHelpButton(onPressed: () {}),
  footer: GtQuestionTextButton(
    "Forgot PIN?",
    action: "Reset now",
    onPressed: () {},
  ),
)''';

  return GtWidgetDocPage(
    title: 'GtVirtualKeypadForm',
    description:
        'A layout wrapper combining secure PIN visual input dots with a customizable virtual numerical keypad.',
    code: codeSnippet,
    child: GtEmptyStateCard(
      description:
          'Select "Interactive Preview" in the sidebar to test numerical pin keypad entry.',
      icon: GtIcons.alarmClock,
    ),
  );
}
