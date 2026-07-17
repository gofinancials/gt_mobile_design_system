import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTextField', type: GtTextField)
Widget playgroundGtTextFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtTextField',
    description: 'Documentation for GtTextField',
    code: '''
GtTextField(
  controller: GtInputController(),
)
''',
    child: GtTextField(
      controller: GtInputController(),
    ),
  );
}
