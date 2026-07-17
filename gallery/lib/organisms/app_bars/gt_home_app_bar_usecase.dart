import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHomeAppBar', type: GtHomeAppBar)
Widget playgroundGtHomeAppBarUseCase(BuildContext context) {
  final userFullName = context.knobs.string(
    label: 'User Full Name',
    initialValue: 'Alex Lobaloba',
  );
  final showSearch = context.knobs.boolean(
    label: 'Show Search Button',
    initialValue: true,
  );
  final showNotification = context.knobs.boolean(
    label: 'Show Notification Button',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtHomeAppBar',
    description:
        'A specialized app bar for home dashboards displaying user avatar, name, search triggers, and notifications.',
    code:
        '''
GtHomeAppBar(
  userFullName: "$userFullName",
  onClickAvatar: () {},
  ${showSearch ? 'onClickSearch: () {},' : ''}
  ${showNotification ? 'onClickNotification: () {},' : ''}
)''',
    child: GtHomeAppBar(
      userFullName: userFullName,
      onClickAvatar: () {},
      onClickSearch: showSearch ? () {} : null,
      onClickNotification: showNotification ? () {} : null,
    ),
  );
}
