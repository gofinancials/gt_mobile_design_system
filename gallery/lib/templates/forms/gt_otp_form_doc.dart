import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtOtpForm', type: GtOtpForm)
Widget playgroundGtOtpFormDoc(BuildContext context) {
  const codeSnippet = '''
Scaffold(
  bottomNavigationBar: GtButtonBottomNavBar(
    button: GtRaisedButton(text: 'Confirm', onPressed: () {}),
  ),
  body: GtOtpForm(
    formKey: GlobalKey<FormState>(),
    title: title,
    subtitle: subtitle,
    onResendCode: () {},
  ),
)''';

  return GtWidgetDocPage(
    title: 'GtOtpForm',
    description:
        'A composite form template designed for One-Time Password verification and countdown timers.',
    code: codeSnippet,
    child: GtEmptyStateCard(
      description:
          'Select "Interactive Preview" in the sidebar to test the OTP form behavior.',
      icon: GtIcons.alarmClock,
    ),
  );
}
