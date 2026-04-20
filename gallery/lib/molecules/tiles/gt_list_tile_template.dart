import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'ListTileTemplates',
  type: GtBaseListTileTemplate,
  path: "[Molecules]/[Tiles]",
)
Widget gtListTileTemplateUseCase(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: context.insets.defaultAllInsets,
      children: [
        GalleryPageHeader(
          title: "List Tile Templates",
          rider: "Templates",
          sectionHeader: "GtBaseListTileTemplate",
        ),
        const SizedBox(height: 8),
        GtBaseListTileTemplate(
          title: GtText(
            context.knobs.string(label: 'Base Title', initialValue: 'Custom Base Title'),
            style: context.textStyles.h6(),
          ),
          subtitle: GtText(
            context.knobs.string(label: 'Base Subtitle', initialValue: 'Custom Base Subtitle'),
            style: context.textStyles.bodyS(),
          ),
          leading: GtSquareConstrainedBox(
            40,
            child: DecoratedBox(
              decoration: BoxDecoration(color: context.palette.primary.alpha10),
              child: const GtIcon(GtIcons.star),
            ),
          ),
          trailing: const GtIcon(GtIcons.chevronRight),
          asCard: context.knobs.boolean(label: 'Base As Card', initialValue: true),
          cardColor: context.palette.bg.weak,
          onTap: () {},
        ),
        const SizedBox(height: 24),
        GtText('GtStandardTextTileTemplate', style: context.textStyles.h6()),
        const SizedBox(height: 8),
        GtStandardTextTileTemplate(
          title: context.knobs.string(
            label: 'Standard Title',
            initialValue: 'Standard Text Title',
          ),
          subtitle: context.knobs.string(
            label: 'Standard Subtitle',
            initialValue: 'Standard text subtitle goes here.',
          ),
          leading: const GtIcon(GtIcons.user),
          trailing: GtSwitch(value: true, onChanged: (_) {}),
          asCard: context.knobs.boolean(
            label: 'Standard As Card',
            initialValue: true,
          ),
          cardBorderRadius: context.borderRadiusXl,
          onTap: () {},
        ),
      ],
    ),
  );
}