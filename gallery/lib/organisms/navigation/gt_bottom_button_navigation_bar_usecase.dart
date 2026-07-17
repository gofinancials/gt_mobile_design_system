import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtButtonBottomNavBar', type: GtButtonBottomNavBar)
Widget playgroundGtButtonBottomNavBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtButtonBottomNavBar',
    description: 'Documentation for GtButtonBottomNavBar',
    code: '''
GtButtonBottomNavBar(
  button: GtRaisedButton(text: "Continue", onPressed: () {}),
)
''',
    child: GtButtonBottomNavBar(
      button: GtRaisedButton(text: "Continue", onPressed: () {}),
    ),
  );
}
