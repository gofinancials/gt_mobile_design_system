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
  final showHelp = context.knobs.boolean(
    label: 'Show Help Button',
    initialValue: true,
  );
  final showSearch = context.knobs.boolean(
    label: 'Show Search Button',
    initialValue: true,
  );
  final showHide = context.knobs.boolean(
    label: 'Show Hide Button',
    initialValue: false,
  );
  final showNotification = context.knobs.boolean(
    label: 'Show Notification Button',
    initialValue: true,
  );
  final showToggleAccounts = context.knobs.boolean(
    label: 'Show Account Toggle',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtHomeAppBar',
    description:
        'A specialized app bar for home dashboards displaying user avatar, name, search triggers, and notifications. Every icon-only button takes a localised semantics label so screen readers can name it.',
    code:
        '''
GtHomeAppBar(
  userFullName: "$userFullName",
  onClickAvatar: () {},
  ${showHelp ? 'onClickHelp: () {},\n  helpSemanticsLabel: "Help",' : ''}
  ${showSearch ? 'onClickSearch: () {},\n  searchSemanticsLabel: "Search",' : ''}
  ${showHide ? 'onClickHide: () {},\n  hideSemanticsLabel: "Hide balances",' : ''}
  ${showNotification ? 'onClickNotification: () {},\n  notificationSemanticsLabel: "Notifications",' : ''}
  ${showToggleAccounts ? 'onToggleAccounts: () {},\n  toggleAccountText: "All Accounts",\n  toggleAccountSemanticsLabel: "Switch account, All Accounts",' : ''}
)''',
    child: GtHomeAppBar(
      userFullName: userFullName,
      onClickAvatar: () {},
      onClickHelp: showHelp ? () {} : null,
      helpSemanticsLabel: 'Help',
      onClickSearch: showSearch ? () {} : null,
      searchSemanticsLabel: 'Search',
      onClickHide: showHide ? () {} : null,
      hideSemanticsLabel: 'Hide balances',
      onClickNotification: showNotification ? () {} : null,
      notificationSemanticsLabel: 'Notifications',
      onToggleAccounts: showToggleAccounts ? () {} : null,
      toggleAccountText: 'All Accounts',
      toggleAccountSemanticsLabel: 'Switch account, All Accounts',
    ),
  );
}
