import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtListTile', type: GtListTile)
Widget playgroundGtListTileUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'General List Item',
  );

  return GtWidgetDocPage(
    title: "GtListTile",
    description:
        "A general-purpose list tile that displays a primary text with optional leading/trailing widgets.",
    code:
        '''
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
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Account Settings',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Manage password, 2FA and sessions.',
  );
  final isAlt = context.knobs.boolean(
    label: 'Use Alternate Style (Boxed Icon)',
    initialValue: false,
  );

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
    description:
        "A list tile that emphasizes a leading icon alongside a title and subtitle.",
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

@widgetbook.UseCase(
  name: 'GtSimpleActionListTile',
  type: GtSimpleActionListTile,
)
Widget playgroundGtSimpleActionListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Personal Info',
  );
  final (trailingLabel, trailingIcon) =
      context.knobs.object.dropdown<(String, IconData)>(
    label: 'Trailing Icon',
    initialOption: ('chevronRight', GtIcons.chevronRight),
    options: const [
      ('chevronRight', GtIcons.chevronRight),
      ('chevronLeft', GtIcons.chevronLeft),
      ('chevronDown', GtIcons.chevronDown),
      ('chevronUp', GtIcons.chevronUp),
      ('arrowNorthEast', GtIcons.arrowNorthEast),
      ('arrowDoorOut', GtIcons.arrowDoorOut),
      ('more', GtIcons.more),
      ('moreHorizontal', GtIcons.moreHorizontal),
      ('add', GtIcons.add),
      ('cancel', GtIcons.cancel),
      ('spark', GtIcons.spark),
      ('info', GtIcons.info),
    ],
    labelBuilder: (option) => option.$1,
  );
  final trailingVariant = context.knobs.object.dropdown<GtIconVariant>(
    label: 'Trailing Icon Variant',
    initialOption: GtIconVariant.soft,
    options: GtIconVariant.values,
    labelBuilder: (v) => v.name,
  );
  final trailingIconSize = context.knobs.double.slider(
    label: 'Trailing Icon Size',
    initialValue: 20.0,
    min: 14.0,
    max: 36.0,
  );
  final (styleName, titleStyle) =
      context.knobs.object.dropdown<(String, TextStyle?)>(
    label: 'Title Style',
    initialOption: ('Default (h6)', null),
    options: [
      ('Default (h6)', null),
      ('h5', context.textStyles.h5()),
      ('subHeadS', context.textStyles.subHeadS()),
      ('bodyM', context.textStyles.bodyM()),
      ('labelM', context.textStyles.labelM()),
    ],
    labelBuilder: (v) => v.$1,
  );
  final customPadding = context.knobs.boolean(
    label: 'Custom Padding (Dense)',
    initialValue: false,
  );

  final paddingParam = customPadding
      ? '\n  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),'
      : '';
  final iconParam = trailingIcon == GtIcons.chevronRight
      ? ''
      : '\n  trailing: GtIcons.$trailingLabel,';
  final sizeParam = trailingIconSize == 20.0
      ? ''
      : '\n  trailingIconSize: $trailingIconSize,';
  final variantParam = trailingVariant == GtIconVariant.soft
      ? ''
      : '\n  trailingIconVariant: GtIconVariant.${trailingVariant.name},';
  final styleParam = titleStyle == null
      ? ''
      : '\n  titleStyle: context.textStyles.$styleName(),';

  final code = '''
GtSimpleActionListTile(
  "$title",$iconParam$sizeParam$variantParam$styleParam$paddingParam
  onTap: () {},
)''';

  return GtWidgetDocPage(
    title: "GtSimpleActionListTile",
    description:
        "A straightforward list tile used for simple navigation actions, featuring a title and a trailing chevron.",
    code: code,
    child: Center(
      child: GtCard(
        padding: context.insets.symmetricDp(horizontal: 16.px, vertical: 8.px),
        variant: GtCardVariant.normal,
        child: GtSimpleActionListTile(
          title,
          trailing: trailingIcon,
          trailingIconSize: trailingIconSize,
          trailingIconVariant: trailingVariant,
          titleStyle: titleStyle,
          padding: customPadding
              ? context.insets.symmetricDp(horizontal: 16.px, vertical: 6.px)
              : null,
          onTap: () {},
        ),
      ),
    ),
  );
}
