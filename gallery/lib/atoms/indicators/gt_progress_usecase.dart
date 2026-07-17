import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProgress', type: GtProgress)
Widget playgroundGtProgressUseCase(BuildContext context) {
  final isDeterminate = context.knobs.boolean(
    label: 'Determinate Mode',
    initialValue: true,
  );
  final value = isDeterminate
      ? context.knobs.double.slider(
          label: 'Progress Value',
          initialValue: 0.72,
          min: 0.0,
          max: 1.0,
        )
      : null;

  final codeSnippet =
      '''
// Standard Progress Indicator
GtProgress(
  ${value != null ? 'value: $value,' : ''}
)

// Or Animated variant (animates from 0.0 on load):
GtAnimatedProgress(
  value: ${value ?? 0.5},
)

// Interactive progress slider with a thumb:
GtSlider(value: ${value ?? 0.5}, onChanged: ($value) {})''';

  return GtWidgetDocPage(
    title: 'GtProgress',
    description: '''
<b>GtProgress</b> is a linear progress indicator used inline or standalone.

<b>Related widgets:</b>
• <b>GtAnimatedProgress</b> — Same API, but animates from 0 to value on mount.
• <b>GtSlider</b> — Interactive progress slider with a thumb.''',
    code: codeSnippet,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GtText(
          'GtProgress (Standard):',
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
        const GtGap.yXs(),
        GtProgress(value: value),
        const GtGap.yLg(),
        GtText(
          'GtAnimatedProgress (Animated on mount):',
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
        const GtGap.yXs(),
        GtAnimatedProgress(value: value ?? 0.5),
        const GtGap.yLg(),
        GtText(
          'GtSlider (Interactive):',
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
        const GtGap.yXs(),
        GtSlider(value: value ?? 0.5, onChanged: (val) {}),
      ],
    ),
  );
}
