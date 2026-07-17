import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtVirtualKeypadForm', type: GtVirtualKeypadForm)
Widget gtVirtualKeypadFormUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Virtual Keypad Form",
    description: "A form that utilizes a virtual keypad for secure PIN entry.",
    code: '''
GtVirtualKeypadForm(
  formKey: GlobalKey<FormState>(),
  controller: TextEditingController(),
  title: 'Enter PIN',
  description: 'Please enter your 4-digit PIN.',
  maxLength: 4,
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtVirtualKeypadForm"),
        GtVirtualKeypadForm(
          formKey: GlobalKey<FormState>(),
          controller: TextEditingController(),
          title: context.knobs.string(label: 'Title', initialValue: 'Enter PIN'),
          subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'Please enter your 4-digit PIN.'),
          maxLength: context.knobs.int.slider(label: 'Max Length', initialValue: 4, min: 4, max: 6),
        ),
      ],
    ),
  );
}
