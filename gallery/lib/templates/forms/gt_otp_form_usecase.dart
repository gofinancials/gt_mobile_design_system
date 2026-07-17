import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive Preview', type: GtOtpForm)
Widget playgroundGtOtpFormUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Enter OTP');
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'We sent a code to your registered email address.',
  );

  return Scaffold(
    bottomNavigationBar: GtButtonBottomNavBar(
      button: GtRaisedButton(text: 'Confirm', onPressed: () {}),
    ),
    body: GtOtpForm(
      formKey: GlobalKey<FormState>(),
      title: title,
      subtitle: subtitle,
      onResendCode: () {},
    ),
  );
}
