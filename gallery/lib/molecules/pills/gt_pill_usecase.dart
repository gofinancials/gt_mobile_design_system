import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPill', type: GtPill)
Widget playgroundGtPillUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Pill Text', initialValue: 'CUSTOM PILL');
  final showShadow = context.knobs.boolean(label: 'Show Shadow', initialValue: false);

  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Color Variant Template',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.primary,
    labelBuilder: (v) => v.name,
  );

  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: false);
  final icon = hasIcon ? GtIcon(GtIcons.spark, size: 12) : null;

  final hasTrailing = context.knobs.boolean(label: 'Has Trailing', initialValue: false);
  final trailing = hasTrailing ? GtIcon(GtIcons.chevronRight, size: 12) : null;

  final codeSnippet = '''
GtPill(
  text: "$text",
  variant: GtPillVariant.${variant.name},
  bgColor: palette.primary.alpha10,
  borderColor: palette.primary.alpha16,
  textColor: palette.primary.dark,
  showShadow: $showShadow,
  ${hasIcon ? 'icon: GtIcon(GtIcons.spark, size: 12),' : ''}
  ${hasTrailing ? 'trailing: GtIcon(GtIcons.chevronRight, size: 12),' : ''}
)''';

  return GtWidgetDocPage(
    title: 'GtPill (Root)',
    description: 'The base pill component for all specialized pills. Completely customizable styling.',
    code: codeSnippet,
    child: Center(
      child: GtPill(
        text: text,
        variant: variant,
        bgColor: variant.getBgColor(context.palette),
        borderColor: variant.getBorderColor(context.palette),
        textColor: variant.getTextColor(context.palette),
        showShadow: showShadow,
        icon: icon,
        trailing: trailing,
      ),
    ),
  );
}
