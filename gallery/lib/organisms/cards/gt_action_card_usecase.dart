import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionCard', type: GtActionCard)
Widget playgroundGtActionCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtActionCard',
    description: 'Documentation for GtActionCard',
    code: '''
GtActionCard(
  title: "Complete your profile",
  subtitle: "Add your BVN to unlock more features.",
  icon: GtIcons.userOutline,
  actionText: "Add BVN",
  onActionTap: () {},
)
''',
    child: GtActionCard(
      title: "Complete your profile",
      subtitle: "Add your BVN to unlock more features.",
      icon: GtIcons.user,
      actionText: "Add BVN",
      onActionTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'GtActionCard dismissible', type: GtActionCard)
Widget playgroundGtActionCardDismissibleUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtActionCard dismissible',
    description: 'Documentation for GtActionCard dismissible',
    code: '''
GtActionCard.dismissible(
  title: "Update App",
  subtitle: "A new version of the app is available.",
  icon: GtIcons.arrowDownToLine,
  actionText: "Update Now",
  onActionTap: () {},
  dismissText: "Later",
  onDismiss: () {},
)
''',
    child: GtActionCard.dismissible(
      title: "Update App",
      subtitle: "A new version of the app is available.",
      icon: GtIcons.arrowBottomRight,
      actionText: "Update Now",
      onActionTap: () {},
      dismissText: "Later",
      onDismiss: () {},
    ),
  );
}
