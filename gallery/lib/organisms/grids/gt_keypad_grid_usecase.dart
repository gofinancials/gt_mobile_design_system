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
  final bioIcon = context.knobs.object.dropdown<String>(
    label: 'Bio Icon',
    options: ['platform', 'faceId', 'fingerprint'],
  );
  final bioIconData = switch (bioIcon) {
    'faceId' => GtIcons.faceId,
    'fingerprint' => GtIcons.fingerprint,
    _ => null,
  };

  return GtWidgetDocPage(
    title: "Keypad Grid",
    description: "A numeric keypad grid for entering numbers securely.",
    code:
        '''
GtKeyPadGrid(
  controller: TextEditingController(),
  limit: 4,
  enableScaleEffect: $enableScaleEffect,
  onBioAuth: () {},${bioIconData == null ? '' : '\n  bioIcon: GtIcons.$bioIcon,'}
)
''',
    child: GtKeyPadGrid(
      controller: TextEditingController(),
      enableScaleEffect: enableScaleEffect,
      bioIcon: bioIconData,
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
