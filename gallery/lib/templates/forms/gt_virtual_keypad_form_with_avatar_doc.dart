import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtVirtualKeypadForm.withAvatar',
  type: GtVirtualKeypadForm,
)
Widget playgroundGtVirtualKeypadFormWithAvatarDoc(BuildContext context) {
  const codeSnippet = '''
Scaffold(
  body: GtVirtualKeypadForm.withAvatar(
    formKey: GlobalKey<FormState>(),
    controller: pinController,
    name: 'Alex Lobaloba',
    avatar: AppImageData.asset(GtAssetImages.avatar),
    headerQuestionButton: GtQuestionTextButton(
      "Not you?",
      action: "Switch account",
      onPressed: () {},
    ),
    maxLength: 4,
    fillInactiveDots: false,
    onBioAuth: () {
      // Biometric Auth callback
    },
    action: GtHelpButton(onPressed: () {}),
  ),
)''';

  return GtWidgetDocPage(
    title: 'GtVirtualKeypadForm.withAvatar',
    description:
        'A specialized virtual keypad form designed for authenticated user PIN validation displaying an avatar profile picture.',
    code: codeSnippet,
    child: GtEmptyStateCard(
      description:
          'Select "Interactive Preview (Avatar)" in the sidebar to test numerical pin keypad entry with avatar profile display.',
      icon: GtIcons.alarmClock,
    ),
  );
}
