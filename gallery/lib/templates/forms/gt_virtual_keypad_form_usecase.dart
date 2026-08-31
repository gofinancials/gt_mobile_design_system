import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive Preview', type: GtVirtualKeypadForm)
Widget playgroundGtVirtualKeypadFormUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Enter PIN');
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Please enter your secure 4-digit transaction PIN.',
  );
  final maxLength = context.knobs.int.slider(
    label: 'PIN Length',
    initialValue: 4,
    min: 4,
    max: 6,
  );
  final fillInactiveDots = context.knobs.boolean(
    label: 'Fill Inactive Dots',
    initialValue: false,
  );
  final hasHelperText = context.knobs.boolean(
    label: 'Show Helper Text',
    initialValue: false,
  );
  final hasErrorText = context.knobs.boolean(
    label: 'Show Error Text',
    initialValue: false,
  );
  final enableBioAuth = context.knobs.boolean(
    label: 'Enable Biometric Auth',
    initialValue: true,
  );
  final showAction = context.knobs.boolean(
    label: 'Show App Bar Action (Help)',
    initialValue: true,
  );
  final showFooter = context.knobs.boolean(
    label: 'Show Footer',
    initialValue: false,
  );

  return Scaffold(
    body: GtVirtualKeypadForm(
      formKey: GlobalKey<FormState>(),
      controller: TextEditingController(),
      title: title,
      subtitle: subtitle,
      maxLength: maxLength,
      fillInactiveDots: fillInactiveDots,
      helperText:
          hasHelperText ? 'Please do not share your PIN with anyone.' : null,
      errorText: hasErrorText ? 'Incorrect PIN. 2 attempts remaining.' : null,
      onBioAuth: enableBioAuth ? () {} : null,
      action: showAction ? GtHelpButton(onPressed: () {}) : null,
      footer: showFooter
          ? GtQuestionTextButton(
              "Forgot PIN?",
              action: "Reset now",
              onPressed: () {},
            )
          : null,
    ),
  );
}
