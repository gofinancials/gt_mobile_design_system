import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtKeyPadGrid', type: GtKeyPadGrid)
Widget gtKeypadGridUseCase(BuildContext context) {
  final enableScaleEffect = context.knobs.boolean(
    label: 'Enable Scale Effect',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: "Keypad Grid",
    description: "A numeric keypad grid for entering numbers securely.",
    code:
        '''
GtKeyPadGrid(
  controller: TextEditingController(),
  limit: 4,
  enableScaleEffect: $enableScaleEffect,
  onBioAuth: () {},
)
''',
    child: GtKeyPadGrid(
      controller: TextEditingController(),
      enableScaleEffect: enableScaleEffect,
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
