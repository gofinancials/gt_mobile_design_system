import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAppBar', type: GtAppBar)
Widget playgroundGtAppBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtAppBar',
    description: 'Documentation for GtAppBar',
    code: '''
GtAppBar(
  title: "Title",
  leading: const GtBackButton(),
  trailing: GtIconButton(icon: GtIcons.magnifier, onPressed: () {}),
)
''',
    child: GtAppBar(
      title: "Title",
      leading: const GtBackButton(),
      trailing: GtIconButton(icon: GtIcons.magnifier, onPressed: () {}),
    ),
  );
}
