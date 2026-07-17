import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHomeAppBar', type: GtHomeAppBar)
Widget playgroundGtHomeAppBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtHomeAppBar',
    description: 'Documentation for GtHomeAppBar',
    code: '''
GtHomeAppBar(
  userFullName: "John Doe",
  onClickAvatar: () {},
)
''',
    child: GtHomeAppBar(
      userFullName: "John Doe",
      onClickAvatar: () {},
    ),
  );
}
