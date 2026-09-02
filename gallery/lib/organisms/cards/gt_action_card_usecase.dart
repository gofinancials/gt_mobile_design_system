import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionCard', type: GtActionCard)
Widget playgroundGtActionCardUseCase(BuildContext context) {
  final mode = context.knobs.object.dropdown<String>(
    label: 'Card Mode',
    options: ['standard', 'dismissible', 'dismissibleTrailing'],
    initialOption: 'standard',
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Refer a Friend, Earn ₦5,000 each',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Love your Pro account? Share with your friends.',
  );
  final actionText = context.knobs.string(
    label: 'Action Text',
    initialValue: 'Share Invite',
  );
  final dismissText = context.knobs.string(
    label: 'Dismiss Text',
    initialValue: 'DISMISS',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  Widget cardWidget;
  String codeSnippet;

  if (mode == 'dismissible') {
    cardWidget = GtActionCard.dismissible(
      title: title,
      subtitle: subtitle,
      icon: GtIcons.gift,
      onActionTap: () {},
      actionText: actionText,
      variant: variant,
      onDismiss: () {},
      dismissText: dismissText,
    );
    codeSnippet =
        '''GtActionCard.dismissible(
  title: "$title",
  subtitle: "$subtitle",
  icon: GtIcons.gift,
  onActionTap: () {},
  actionText: "$actionText",
  variant: GtCardVariant.${variant.name},
  onDismiss: () {},
  dismissText: "$dismissText",
)''';
  } else if (mode == 'dismissibleTrailing') {
    cardWidget = GtActionCard.dismissibleTrailing(
      title: title,
      subtitle: subtitle,
      trailing: GtSvg(
        GtVectorIllustrations.serviceStatus,
        width: context.dp(80.px),
        height: context.dp(80.px),
        alignment: Alignment.topRight,
      ),
      onActionTap: () {},
      actionText: actionText,
      variant: variant,
      onDismiss: () {},
      dismissText: dismissText,
    );
    codeSnippet =
        '''GtActionCard.dismissibleTrailing(
  title: "$title",
  subtitle: "$subtitle",
  trailing: GtSvg(GtVectorIllustrations.serviceStatus, width: 80, height: 80),
  onActionTap: () {},
  actionText: "$actionText",
  variant: GtCardVariant.${variant.name},
  onDismiss: () {},
  dismissText: "$dismissText",
)''';
  } else {
    cardWidget = GtActionCard(
      title: title,
      subtitle: subtitle,
      icon: GtIcons.gift,
      onActionTap: () {},
      actionText: actionText,
      variant: variant,
    );
    codeSnippet =
        '''GtActionCard(
  title: "$title",
  subtitle: "$subtitle",
  icon: GtIcons.gift,
  onActionTap: () {},
  actionText: "$actionText",
  variant: GtCardVariant.${variant.name},
)''';
  }

  return GtWidgetDocPage(
    title: 'GtActionCard',
    description:
        'An actionable card featuring promo information, call-to-actions, and optional dismiss buttons.',
    code: codeSnippet,
    child: cardWidget,
  );
}
