import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtOtpForm', type: GtOtpForm)
Widget gtOtpFormUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "OTP Form",
    description: "A form designed for entering One-Time Passwords (OTP).",
    code: '''
GtOtpForm(
  formKey: GlobalKey<FormState>(),
  title: 'Enter OTP',
  description: 'We sent a code to your email',
  onResendCode: () {},
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtOtpForm"),
        GtOtpForm(
          formKey: GlobalKey<FormState>(),
          title: context.knobs.string(label: 'Title', initialValue: 'Enter OTP'),
          subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'We sent a code to your email'),
          onResendCode: () {},
        ),
      ],
    ),
  );
}
