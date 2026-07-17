import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProAppBar', type: GtProAppBar)
Widget playgroundGtProAppBarUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtProAppBar',
    description: 'Documentation for GtProAppBar',
    code: '''
GtProAppBar(
  fullName: "John Doe",
  businessName: "Sterling Bank",
  onClickStat: () {},
  onClickProfile: () {},
  onClickNotification: () {},
)
''',
    child: GtProAppBar(
      fullName: "John Doe",
      businessName: "Sterling Bank",
      onClickStat: () {},
      onClickProfile: () {},
      onClickNotification: () {},
    ),
  );
}
