import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCancelButton', type: GtCancelButton)
Widget playgroundGtCancelButtonUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtCancelButton',
    description: 'Documentation for GtCancelButton',
    code: '''
const GtCancelButton()
''',
    child: const GtCancelButton(),
  );
}
