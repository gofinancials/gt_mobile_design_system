import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/data.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAccountListTile', type: GtAccountListTile)
Widget playgroundGtAccountListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Account Title',
    initialValue: 'Savings Account',
  );
  final subtitle = context.knobs.string(
    label: 'Account Subtitle',
    initialValue: '₦ 5,230,490.50',
  );
  final hasBoldSubtitle = context.knobs.boolean(
    label: 'Bold Subtitle',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtAccountListTile',
    description:
        'A list tile tailored for displaying account details with title, subtitle and leading avatar/icon.',
    code:
        '''
GtAccountListTile(
  "$title",
  subtitle: "$subtitle",
  leading: const GtImage(
    image: AppImageData("${GtNetworkImages.sampleAvatar1}"),
  )
  hasBoldSubtitle: $hasBoldSubtitle,
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtAccountListTile(
          title,
          subtitle: subtitle,
          leading: const GtImage(
            image: AppImageData(GtNetworkImages.sampleAvatar1),
          ),
          hasBoldSubtitle: hasBoldSubtitle,
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtContactListTile', type: GtContactListTile)
Widget playgroundGtContactListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Contact Name',
    initialValue: 'Alex Lobaloba',
  );
  final subtitle = context.knobs.string(
    label: 'Contact Details',
    initialValue: 'alex.loba@sterling.com',
  );

  return GtWidgetDocPage(
    title: 'GtContactListTile',
    description:
        'A list tile tailored for displaying contact lists with a standard right chevron indicator.',
    code:
        '''
GtContactListTile(
  "$title",
  subtitle: "$subtitle",
  leading: GtAvatar(initials: "AL"),
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtContactListTile(
          title,
          subtitle: subtitle,
          leading: const GtAvatar(initials: "AL"),
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtStakeHolderListTile', type: GtStakeHolderListTile)
Widget playgroundGtStakeHolderListTileUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Stakeholder Name',
    initialValue: 'Chinedu Egwu',
  );
  final position = context.knobs.string(
    label: 'Position',
    initialValue: 'Managing Director',
  );
  final footer = context.knobs.string(
    label: 'Ownership Detail',
    initialValue: '45% shares owned',
  );

  return GtWidgetDocPage(
    title: 'GtStakeHolderListTile',
    description:
        'A list tile displaying stakeholder names, roles, and shares/metadata.',
    code:
        '''
GtStakeHolderListTile(
  "$name",
  position: "$position",
  footer: "$footer",
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtStakeHolderListTile(
          name,
          position: position,
          footer: footer,
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtStakeHolderStatusListTile',
  type: GtStakeHolderStatusListTile,
)
Widget playgroundGtStakeHolderStatusListTileUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Stakeholder Name',
    initialValue: 'Chinedu Egwu',
  );
  final position = context.knobs.string(
    label: 'Position',
    initialValue: 'Managing Director',
  );
  final isVerified = context.knobs.boolean(
    label: 'Is Verified',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtStakeHolderStatusListTile',
    description:
        'Displays a stakeholder card with an trailing verification status.',
    code:
        '''
GtStakeHolderStatusListTile(
  "$name",
  position: "$position",
  isVerified: $isVerified,
  trailing: GtStatusPill(
    text: "Verified",
    variant: GtPillVariant.success,
  ),
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtStakeHolderStatusListTile(
          name,
          position: position,
          isVerified: isVerified,
          trailing: const GtStatusPill(
            text: "Verified",
            variant: GtPillVariant.success,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtAccountTypeListTile', type: GtAccountTypeListTile)
Widget playgroundGtAccountTypeListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Type Title',
    initialValue: 'Sole Proprietorship',
  );
  final subtitle = context.knobs.string(
    label: 'Type Subtitle',
    initialValue: 'Register a business owned by a single person.',
  );

  return GtWidgetDocPage(
    title: 'GtAccountTypeListTile',
    description:
        'A list tile showing structured account/business type selection rows.',
    code:
        '''
GtAccountTypeListTile(
  "$title",
  icon: GtIcons.user,
  subtitle: "$subtitle",
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtAccountTypeListTile(
          title,
          icon: GtIcons.user,
          subtitle: subtitle,
          onTap: () {},
        ),
      ),
    ),
  );
}
