import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/data.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProfileHeader', type: GtProfileHeader)
Widget playgroundGtProfileHeaderUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Foluke Collins',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'foluke.c@gmail.com • Active',
  );
  final tag = context.knobs.string(label: 'Tag', initialValue: '');
  final showImage = context.knobs.boolean(
    label: 'Show Avatar Image',
    initialValue: false,
  );
  final tappable = context.knobs.boolean(
    label: 'Tappable Avatar',
    initialValue: false,
  );
  final isSkeleton = context.knobs.boolean(
    label: 'Skeleton',
    initialValue: false,
  );

  final avatar = showImage ? AppImageData(GtNetworkImages.sampleAvatar1) : null;

  return GtWidgetDocPage(
    title: 'GtProfileHeader',
    description:
        'The header of a person\'s profile: their uppercased name and an '
        'optional supporting line beside their avatar, with an optional tag '
        'pill, such as their role, below.',
    code: isSkeleton
        ? 'GtProfileHeader.skeleton()'
        : '''
GtProfileHeader(
  title: "$title",${subtitle.isEmpty ? '' : '\n  subtitle: "$subtitle",'}${tag.isEmpty ? '' : '\n  tag: "$tag",'}${showImage ? '\n  avatar: AppImageData(GtNetworkImages.sampleAvatar1),' : ''}${tappable ? '\n  onClickAvatar: () {},\n  avatarSemanticsLabel: "View $title",' : ''}
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: isSkeleton
            ? const GtProfileHeader.skeleton()
            : GtProfileHeader(
                title: title,
                subtitle: subtitle.isEmpty ? null : subtitle,
                tag: tag.isEmpty ? null : tag,
                avatar: avatar,
                onClickAvatar: tappable
                    ? () => context.showToast('Avatar selected')
                    : null,
                avatarSemanticsLabel: 'View $title',
              ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtProfileHeader with tag', type: GtProfileHeader)
Widget playgroundGtProfileHeaderTagUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Foluke Collins',
  );
  final tag = context.knobs.string(label: 'Tag', initialValue: 'Account owner');

  return GtWidgetDocPage(
    title: 'GtProfileHeader with tag',
    description:
        'The profile header as it opens a team category: the name and avatar '
        'with the person\'s role in a pill below, and no supporting line.',
    code:
        '''
GtProfileHeader(
  title: "$title",
  tag: "$tag",
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtProfileHeader(title: title, tag: tag.isEmpty ? null : tag),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtProfileHeroHeader', type: GtProfileHeroHeader)
Widget playgroundGtProfileHeroHeaderUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Name',
    initialValue: 'Alex Lobaloba',
  );
  final accountName = context.knobs.string(
    label: 'Account Name',
    initialValue: 'Funmilola Consulting Ltd',
  );
  final showImage = context.knobs.boolean(
    label: 'Show Avatar Image',
    initialValue: false,
  );
  final switchable = context.knobs.boolean(
    label: 'Switchable Account',
    initialValue: true,
  );
  final isSkeleton = context.knobs.boolean(
    label: 'Skeleton',
    initialValue: false,
  );

  final avatar = showImage ? AppImageData(GtNetworkImages.sampleAvatar1) : null;

  return GtWidgetDocPage(
    title: 'GtProfileHeroHeader',
    description:
        'The centred header of the signed-in user\'s own profile: their '
        'avatar and uppercased name over a pill naming the account they act '
        'for, which opens an account switcher when tappable.',
    code: isSkeleton
        ? 'GtProfileHeroHeader.skeleton()'
        : '''
GtProfileHeroHeader(
  name: "$name",${showImage ? '\n  avatar: AppImageData(GtNetworkImages.sampleAvatar1),' : ''}${accountName.isEmpty ? '' : '\n  accountName: "$accountName",'}${switchable ? '\n  onSwitchAccount: () {},\n  switchAccountSemanticsLabel: "Switch account",' : ''}
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: isSkeleton
            ? const GtProfileHeroHeader.skeleton()
            : GtProfileHeroHeader(
                name: name,
                avatar: avatar,
                accountName: accountName.isEmpty ? null : accountName,
                onSwitchAccount: switchable
                    ? () => context.showToast('Switch account selected')
                    : null,
                switchAccountSemanticsLabel: 'Switch account',
              ),
      ),
    ),
  );
}
