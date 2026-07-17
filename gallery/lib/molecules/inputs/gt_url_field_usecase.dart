import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtUrlField', type: GtUrlField)
Widget playgroundGtUrlFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtUrlField',
    description: 'Documentation for GtUrlField',
    code: '''
GtUrlField(
  controller: GtInputController(),
  label: "URL",
)
''',
    child: GtUrlField(
      controller: GtInputController(),
      label: "URL",
    ),
  );
}
