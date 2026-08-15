import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtStatusPill', type: GtStatusPill)
Widget playgroundGtStatusPillUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: 'Pill Text',
    initialValue: 'COMPLETED',
  );
  final variant = context.knobs.object.dropdown<GtPillVariant>(
    label: 'Variant',
    options: GtPillVariant.values,
    initialOption: GtPillVariant.success,
    labelBuilder: (v) => v.name,
  );
  final isNormal = context.knobs.boolean(
    label: 'Size: Normal',
    initialValue: true,
  );

  final codeSnippet =
      '''
GtStatusPill(
  text: "$text",
  variant: GtPillVariant.${variant.name},
  size: ${isNormal ? 'GtPillSize.normal' : 'GtPillSize.larger'},
)''';

  return GtWidgetDocPage(
    title: 'GtStatusPill',
    description:
        'A status indicator pill with preset color schemes based on the status variant.',
    code: codeSnippet,
    child: Center(
      child: GtStatusPill(
        text: text,
        variant: variant,
        size: isNormal ? GtPillSize.normal : GtPillSize.larger,
      ),
    ),
  );
}
