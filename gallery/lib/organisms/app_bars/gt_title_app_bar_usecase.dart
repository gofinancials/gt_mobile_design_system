import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTitleAppBar', type: GtTitleAppBar)
Widget playgroundGtTitleAppBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtTitleAppBar',
    description: 'Documentation for GtTitleAppBar',
    code: '''
GtTitleAppBar(
  title: "Settings",
)
''',
    child: GtTitleAppBar(
      title: "Settings",
    ),
  );
}
