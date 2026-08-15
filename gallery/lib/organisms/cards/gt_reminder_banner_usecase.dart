import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtReminderBanner', type: GtReminderBanner)
Widget playgroundGtReminderBannerUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: "UPGRADE FOLA'S ACCOUNT",
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue:
        "You're 18 now! Time to upgrade your account and unlock more features.",
  );
  final actionText = context.knobs.string(
    label: 'Action Text',
    initialValue: 'GET STARTED',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtReminderBanner',
    description:
        'A contextual reminder banner supporting primary calls to action.',
    code:
        '''
GtReminderBanner(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
  icon: GtSvg(GtVectorIllustrations.referral),
  actionText: "$actionText",
  onActionTap: () {},
  onClose: () {},
)''',
    child: GtReminderBanner(
      title: title,
      subtitle: subtitle,
      variant: variant,
      icon: GtSvg(GtVectorIllustrations.referral),
      actionText: actionText,
      onActionTap: () {},
      onClose: () {},
    ),
  );
}
