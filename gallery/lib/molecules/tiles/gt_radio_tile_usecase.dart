import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtRadioTile', type: GtRadioTile)
Widget playgroundGtRadioTileUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Personal Account');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Standard individual account type.');
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final activeColor = context.knobs.colorOrNull(label: 'Active Color', initialValue: null);
  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: true);
  final leading = hasIcon ? const GtIcon(GtIcons.user) : null;
  final style = context.knobs.object.dropdown<GtRadioStyle>(
    label: 'Radio Style',
    options: GtRadioStyle.values,
    initialOption: GtRadioStyle.standard,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtRadioTile',
    description: 'A customizable list tile with built-in single choice selection using GtRadio.',
    code: '''
GtRadioTile<String>(
  "Personal Account",
  value: "personal",
  groupValue: "personal",
  onChanged: (value) {},
  disabled: $disabled,
  radioStyle: GtRadioStyle.${style.name},
  ${hasIcon ? 'leading: GtIcon(GtIcons.user),' : ''}
  subtitle: "Standard individual account type.",
)''',
    child: Center(
      child: Padding(
        padding: context.insets.allDp(16.px),
        child: GtCard(
          padding: context.insets.allDp(16.px),
          variant: GtCardVariant.normal,
          child: GtRadioTile<String>(
            title,
            value: "personal",
            groupValue: "personal",
            onChanged: (val) {},
            disabled: disabled,
            activeColor: activeColor,
            leading: leading,
            subtitle: subtitle.isEmpty ? null : subtitle,
            radioStyle: style,
          ),
        ),
      ),
    ),
  );
}
