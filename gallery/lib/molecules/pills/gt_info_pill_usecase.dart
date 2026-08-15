import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInfoPill', type: GtInfoPill)
Widget playgroundGtInfoPillUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Pill Text',
    initialValue: 'INFO PILL',
  );
  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Variant',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.info,
    labelBuilder: (v) => v.name,
  );
  final showShadow = context.knobs.boolean(
    label: 'Show Shadow',
    initialValue: false,
  );
  final useDisplayFont = context.knobs.boolean(
    label: 'Use Display Font',
    initialValue: false,
  );

  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: false);
  final icon = hasIcon ? GtIcons.info : null;

  final codeSnippet =
      '''
GtInfoPill(
  text: "$text",
  variant: GtPillVariant.${variant.name},
  showShadow: $showShadow,
  useDisplayFont: $useDisplayFont,
  ${hasIcon ? 'icon: GtIcons.info,' : ''}
)''';

  return GtWidgetDocPage(
    title: 'GtInfoPill',
    description:
        'A capsule badge designed to display informational labels and tags with body or display typography.',
    code: codeSnippet,
    child: Center(
      child: GtInfoPill(
        text: text,
        variant: variant,
        showShadow: showShadow,
        useDisplayFont: useDisplayFont,
        icon: icon,
      ),
    ),
  );
}
