import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtUserTiles', type: GtAccountListTile)
Widget gtAccountListTileUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "User Profile Tiles",
    description: "List tiles tailored for displaying user profiles, contacts, and stakeholders.",
    code: '''
GtAccountListTile(
  'John Doe',
  subtitle: 'Account: 0123456789',
  leading: GtAvatar(initials: 'JD'),
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtAccountListTile"),
        GtAccountListTile(
          context.knobs.string(label: 'Account Name', initialValue: 'Savings Account'),
          subtitle: context.knobs.string(label: 'Account Number', initialValue: '0123456789'),
          leading: GtAvatar(
            initials: context.knobs.string(label: 'Initials', initialValue: 'SA'),
          ),
          trailing: GtIcon(GtIcons.chevronRight, size: 14),
        ),
        const GtGap.yLg(),
        
        GalleryPageSectionHeader(title: "GtContactListTile"),
        GtContactListTile(
          context.knobs.string(label: 'Contact Name', initialValue: 'Jane Doe'),
          subtitle: context.knobs.string(label: 'Bank Name', initialValue: 'GTBank'),
          leading: GtAvatar(
            initials: context.knobs.string(label: 'Initials', initialValue: 'JD'),
          ),
          onTap: () {},
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtStakeHolderListTile"),
        GtStakeHolderListTile(
          context.knobs.string(label: 'Name', initialValue: 'Alice Smith'),
          position: context.knobs.string(label: 'Status', initialValue: 'Director'),
          footer: context.knobs.string(label: 'Footer', initialValue: '20% Shares'),
          onTap: () {},
        ),
      ],
    ),
  );
}
