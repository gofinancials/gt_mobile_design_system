import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive Preview (Avatar)', type: GtVirtualKeypadForm)
Widget playgroundGtVirtualKeypadFormWithAvatarUseCase(BuildContext context) {
  final name = context.knobs.string(label: 'User Name', initialValue: 'Alex Lobaloba');
  final maxLength = context.knobs.int.slider(
    label: 'PIN Length',
    initialValue: 4,
    min: 4,
    max: 6,
  );

  return Scaffold(
    body: GtVirtualKeypadForm.withAvatar(
      formKey: GlobalKey<FormState>(),
      controller: TextEditingController(),
      name: name,
      maxLength: maxLength,
      onBioAuth: () {},
    ),
  );
}
