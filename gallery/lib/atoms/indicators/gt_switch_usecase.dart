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
    accessibilityNotes: const [
      'CupertinoSwitch publishes its own toggled and enabled state, so this widget contributes only the name it lacks. Pass semanticsLabel.',
      'The name and the switch are merged into one node; without merging the user would meet them as two separate swipe stops.',
      'Setting disabled passes a null callback to CupertinoSwitch, which is what makes it announce as unavailable.',
    ],
    child: GtSwitch(value: isOn, onChanged: (val) {}),
  );
}
