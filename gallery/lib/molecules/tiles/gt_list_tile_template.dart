import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBaseListTileTemplate', type: GtBaseListTileTemplate)
Widget playgroundGtBaseListTileTemplateUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Custom Base Title');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Custom Base Subtitle');
  final asCard = context.knobs.boolean(label: 'As Card', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtBaseListTileTemplate',
    description: 'A foundational list tile template with customizable leading, trailing, and card options.',
    code: '''
GtBaseListTileTemplate(
  title: GtText("$title"),
  subtitle: GtText("$subtitle"),
  leading: GtIcon(GtIcons.star),
  trailing: GtIcon(GtIcons.chevronRight),
  asCard: $asCard,
  onTap: () {},
)''',
    child: Center(
      child: GtBaseListTileTemplate(
        title: GtText(title, style: context.textStyles.h6()),
        subtitle: GtText(subtitle, style: context.textStyles.bodyS()),
        leading: const GtIcon(GtIcons.star),
        trailing: const GtIcon(GtIcons.chevronRight),
        asCard: asCard,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtStandardTextTileTemplate', type: GtStandardTextTileTemplate)
Widget playgroundGtStandardTextTileTemplateUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Standard Title');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Standard text subtitle goes here.');
  final asCard = context.knobs.boolean(label: 'As Card', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtStandardTextTileTemplate',
    description: 'A template emphasizing title and subtitle text layout.',
    code: '''
GtStandardTextTileTemplate(
  title: "$title",
  subtitle: "$subtitle",
  leading: GtIcon(GtIcons.user),
  trailing: GtSwitch(value: true, onChanged: (_) {}),
  asCard: $asCard,
  onTap: () {},
)''',
    child: Center(
      child: GtStandardTextTileTemplate(
        title: title,
        subtitle: subtitle,
        leading: const GtIcon(GtIcons.user),
        trailing: GtSwitch(value: true, onChanged: (_) {}),
        asCard: asCard,
        onTap: () {},
      ),
    ),
  );
}
