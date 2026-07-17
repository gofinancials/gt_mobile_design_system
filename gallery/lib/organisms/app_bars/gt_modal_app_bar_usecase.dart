import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtModalAppBar', type: GtModalAppBar)
Widget playgroundGtModalAppBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtModalAppBar',
    description: 'Documentation for GtModalAppBar',
    code: '''
GtModalAppBar(
  title: "Transfer Details",
)
''',
    child: GtModalAppBar(
      title: "Transfer Details",
    ),
  );
}
