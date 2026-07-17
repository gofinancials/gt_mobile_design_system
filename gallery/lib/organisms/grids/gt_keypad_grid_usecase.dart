import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtKeyPadGrid', type: GtKeyPadGrid)
Widget gtKeypadGridUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Keypad Grid",
    description: "A numeric keypad grid for entering numbers securely.",
    code: '''
GtKeyPadGrid(
  controller: TextEditingController(),
  limit: 4,
  onBioAuth: () {},
)
''',
    child: GtKeyPadGrid(
      controller: TextEditingController(),
      limit: context.knobs.int.slider(
        label: 'Limit',
        initialValue: 4,
        min: 4,
        max: 6,
      ),
      onBioAuth:
          context.knobs.boolean(label: 'Enable BioAuth', initialValue: true)
          ? () {}
          : null,
    ),
  );
}
