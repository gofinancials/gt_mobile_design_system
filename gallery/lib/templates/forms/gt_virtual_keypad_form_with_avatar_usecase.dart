import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive Preview (Avatar)',
  type: GtVirtualKeypadForm,
)
Widget playgroundGtVirtualKeypadFormWithAvatarUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'User Name',
    initialValue: 'Alex Lobaloba',
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
  final showHeaderQuestion = context.knobs.boolean(
    label: 'Show Header Question Button',
    initialValue: true,
  );
  final questionText = context.knobs.string(
    label: 'Header Question Text',
    initialValue: 'Not you?',
  );
  final actionText = context.knobs.string(
    label: 'Header Action Text',
    initialValue: 'Switch account',
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
    body: GtVirtualKeypadForm.withAvatar(
      formKey: GlobalKey<FormState>(),
      controller: TextEditingController(),
      name: name,
      maxLength: maxLength,
      fillInactiveDots: fillInactiveDots,
      headerQuestionButton: showHeaderQuestion
          ? GtQuestionTextButton(
              questionText,
              action: actionText,
              onPressed: () {},
            )
          : null,
      helperText: hasHelperText ? 'Enter your 4-digit passcode' : null,
      errorText: hasErrorText ? 'Incorrect PIN entered' : null,
      onBioAuth: enableBioAuth ? () {} : null,
      action: showAction ? GtHelpButton(onPressed: () {}) : null,
      footer: showFooter
          ? GtQuestionTextButton(
              "Having trouble?",
              action: "Get help",
              onPressed: () {},
            )
          : null,
    ),
  );
}
