import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Motion primitives', type: GtAnimatedCounter)
Widget playgroundGtMotionUseCase(BuildContext context) {
  final amount = context.knobs.double.slider(
    label: 'Amount',
    initialValue: 125000,
    min: 0,
    max: 1000000,
    divisions: 100,
  );

  return GtWidgetDocPage(
    title: 'Motion primitives',
    description:
        'Change the amount to preview odometer motion. Press and hold the card '
        'to preview tactile spring feedback.',
    child: Column(
      mainAxisSize: .min,
      spacing: context.spacingLg,
      children: [
        GtAnimatedCounter(
          value: amount,
          formatter: (value) => '₦${value.toStringAsFixed(2)}',
          style: context.textStyles.h3(),
          textAlign: .center,
        ),
        GtPressable(
          pressedScale: GtMotion.cardPressScale,
          child: GtCard(
            child: GtText(
              'PRESS AND HOLD',
              style: context.textStyles.button(),
              textAlign: .center,
            ),
          ),
        ),
      ],
    ),
  );
}
