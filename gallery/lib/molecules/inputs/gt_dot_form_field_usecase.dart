import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDotFormField', type: GtDotFormField)
Widget playgroundGtDotFormFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtDotFormField',
    description: 'Documentation for GtDotFormField',
    code: '''
GtDotFormField(
  controller: TextEditingController(),
  helperText: "Dot Form",
)
''',
    child: GtDotFormField(
      controller: TextEditingController(),
      helperText: "Dot Form",
      length: 6,
    ),
  );
}
