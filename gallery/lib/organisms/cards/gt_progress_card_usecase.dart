import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProgressCard', type: GtProgressCard)
Widget playgroundGtProgressCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'complete your onboarding',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Reference form is still missing',
  );
  final percentSubtext = context.knobs.string(
    label: 'Percent Subtext',
    initialValue: 'COMPLETED',
  );
  final continueText = context.knobs.string(
    label: 'Continue Text',
    initialValue: 'continue',
  );

  final maxValue = context.knobs.double.slider(
    label: 'Max Value',
    min: 10,
    max: 200,
    initialValue: 100,
  );
  final currentValue = context.knobs.double.slider(
    label: 'Current Value',
    min: 0,
    max: maxValue,
    initialValue: min(maxValue, 65),
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtProgressCard',
    description:
        'A progress-tracking card that visualizes numeric status alongside description and action buttons.',
    code:
        '''
GtProgressCard(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
  maxValue: $maxValue,
  currentValue: ${min(maxValue, currentValue)},
  percentSubtext: "$percentSubtext",
  continueText: "$continueText",
  onContinue: () {},
)''',
    child: GtProgressCard(
      title: title,
      subtitle: subtitle,
      variant: variant,
      maxValue: maxValue,
      currentValue: min(maxValue, currentValue),
      percentSubtext: percentSubtext,
      continueText: continueText,
      onContinue: () {},
    ),
  );
}
