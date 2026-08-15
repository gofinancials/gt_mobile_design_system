import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCheckBoxTile', type: GtCheckBoxTile)
Widget playgroundGtCheckBoxTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Enable Notifications',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Get alerts for incoming transfers.',
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final shape = context.knobs.object.dropdown<GtCheckBoxShape>(
    label: 'Shape',
    options: GtCheckBoxShape.values,
    initialOption: GtCheckBoxShape.square,
    labelBuilder: (s) => s.name,
  );
  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: true);
  final leading = hasIcon ? const GtIcon(GtIcons.bell) : null;

  return GtWidgetDocPage(
    title: 'GtCheckBoxTile',
    description:
        'A customizable list tile with built-in selection using GtCheckBox.',
    code:
        '''
GtCheckBoxTile<String>(
  "Enable Notifications",
  value: "notifications",
  isActive: true,
  onChanged: (value) {},
  disabled: $disabled,
  shape: GtCheckBoxShape.${shape.name},
  ${hasIcon ? 'leading: GtIcon(GtIcons.bell),' : ''}
  subtitle: "Get alerts for incoming transfers.",
)''',
    child: Center(
      child: Padding(
        padding: context.insets.allDp(16.px),
        child: GtCard(
          padding: context.insets.allDp(16.px),
          variant: GtCardVariant.normal,
          child: GtCheckBoxTile<String>(
            title,
            value: "notifications",
            isActive: true,
            onChanged: (val) {},
            disabled: disabled,
            shape: shape,
            leading: leading,
            subtitle: subtitle.isEmpty ? null : subtitle,
          ),
        ),
      ),
    ),
  );
}
