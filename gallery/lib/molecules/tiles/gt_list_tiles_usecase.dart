import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtListTile', type: GtListTile)
Widget playgroundGtListTileUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Text', initialValue: 'General List Item');

  return GtWidgetDocPage(
    title: "GtListTile",
    description: "A general-purpose list tile that displays a primary text with optional leading/trailing widgets.",
    code: '''
GtListTile(
  text: "$text",
  leading: GtIcon(GtIcons.user),
  trailing: GtIcon(GtIcons.chevronRight),
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 8.px),
        variant: GtCardVariant.normal,
        child: GtListTile(
          text: text,
          leading: const GtIcon(GtIcons.user),
          trailing: const GtIcon(GtIcons.chevronRight),
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtIconListTile', type: GtIconListTile)
Widget playgroundGtIconListTileUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Account Settings');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Manage password, 2FA and sessions.');
  final isAlt = context.knobs.boolean(label: 'Use Alternate Style (Boxed Icon)', initialValue: false);

  final code = isAlt
      ? '''
GtIconListTile.alt(
  "$title",
  subtitle: "$subtitle",
  icon: GtIcons.user,
  onTap: () {},
)'''
      : '''
GtIconListTile(
  "$title",
  subtitle: "$subtitle",
  icon: GtIcons.user,
  onTap: () {},
)''';

  return GtWidgetDocPage(
    title: "GtIconListTile",
    description: "A list tile that emphasizes a leading icon alongside a title and subtitle.",
    code: code,
    child: Center(
      child: GtCard(
        padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 8.px),
        variant: GtCardVariant.normal,
        child: isAlt
            ? GtIconListTile.alt(
                title,
                subtitle: subtitle.isEmpty ? null : subtitle,
                icon: GtIcons.user,
                onTap: () {},
              )
            : GtIconListTile(
                title,
                subtitle: subtitle.isEmpty ? null : subtitle,
                icon: GtIcons.user,
                onTap: () {},
              ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtSimpleActionListTile', type: GtSimpleActionListTile)
Widget playgroundGtSimpleActionListTileUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Personal Info');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'View profile details');

  return GtWidgetDocPage(
    title: "GtSimpleActionListTile",
    description: "A straightforward list tile used for simple navigation actions, featuring a title and a trailing chevron.",
    code: '''
GtSimpleActionListTile(
  "$title",
  subtitle: "$subtitle",
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 8.px),
        variant: GtCardVariant.normal,
        child: GtSimpleActionListTile(
          title,
          subtitle: subtitle,
          onTap: () {},
        ),
      ),
    ),
  );
}
