import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSwitch', type: GtSwitch)
Widget gtSwitchUseCase(BuildContext context) {
  final isOn = context.knobs.boolean(label: 'Is On', initialValue: true);
  return GtWidgetDocPage(
    title: "Switch Indicator",
    description: "A standard switch used to toggle between two states.",
    code:
        '''
GtSwitch(
  value: $isOn,
  onChanged: (val) {},
)
''',
    child: GtSwitch(value: isOn, onChanged: (val) {}),
  );
}
