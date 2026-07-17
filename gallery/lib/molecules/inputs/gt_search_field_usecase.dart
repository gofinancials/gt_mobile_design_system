import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSearchField', type: GtSearchField)
Widget playgroundGtSearchFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtSearchField',
    description: 'Documentation for GtSearchField',
    code: '''
GtSearchField(
  controller: GtInputController(),
  hintText: "Search here...",
)
''',
    child: GtSearchField(
      controller: GtInputController(),
      hintText: "Search here...",
    ),
  );
}
