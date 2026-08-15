import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDobField', type: GtDobField)
Widget playgroundGtDobFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtDobField',
    description: 'Documentation for GtDobField',
    code: '''
GtDobField(
  controller: GtDobController(),
)
''',
    child: GtDobField(controller: GtDobController()),
  );
}
