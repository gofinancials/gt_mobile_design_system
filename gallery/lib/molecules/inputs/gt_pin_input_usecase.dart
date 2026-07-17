import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPinInput code', type: GtPinInput)
Widget playgroundGtPinInputUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtPinInput',
    description: 'Documentation for GtPinInput',
    code: '''
GtPinInput(
  controller: TextEditingController(),
  length: 4,
)
''',
    child: GtPinInput(controller: TextEditingController(), length: 4),
  );
}
