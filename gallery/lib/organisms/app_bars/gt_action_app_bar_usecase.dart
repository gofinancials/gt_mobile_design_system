import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionAppBar', type: GtActionAppBar)
Widget playgroundGtActionAppBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtActionAppBar',
    description: 'Documentation for GtActionAppBar',
    code: '''
GtActionAppBar()
''',
    child: GtActionAppBar(),
  );
}
