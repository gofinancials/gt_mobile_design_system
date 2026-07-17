import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtButtonPill', type: GtButtonPill)
Widget playgroundGtButtonPillUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'Pill Text', initialValue: 'ACTION PILL');
  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Variant',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final isNormal = context.knobs.boolean(label: 'Size: Normal', initialValue: true);
  final showShadow = context.knobs.boolean(label: 'Show Shadow', initialValue: true);

  final codeSnippet = '''
GtButtonPill(
  text: "$text",
  variant: GtPillVariant.${variant.name},
  size: ${isNormal ? 'GtPillSize.normal' : 'GtPillSize.larger'},
  showShadow: $showShadow,
  onTap: () {},
)''';

  return GtWidgetDocPage(
    title: 'GtButtonPill',
    description: 'An interactive pill with press action handling, feedback animations, and optional drop shadow.',
    code: codeSnippet,
    child: Center(
      child: GtButtonPill(
        text: text,
        variant: variant,
        size: isNormal ? GtPillSize.normal : GtPillSize.larger,
        showShadow: showShadow,
        onTap: () {},
      ),
    ),
  );
}
