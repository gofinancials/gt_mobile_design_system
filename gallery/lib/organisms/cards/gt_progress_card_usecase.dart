import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProgressCard', type: GtProgressCard)
Widget playgroundGtProgressCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtProgressCard',
    description: 'Documentation for GtProgressCard',
    code: '''
GtProgressCard(
  title: "Profile Completion",
  subtitle: "You are almost there!",
  maxValue: 100,
  currentValue: 75,
  percentSubtext: "Complete",
  continueText: "Continue",
  onContinue: () {},
)
''',
    child: GtProgressCard(
      title: "Profile Completion",
      subtitle: "You are almost there!",
      maxValue: 100,
      currentValue: 75,
      percentSubtext: "Complete",
      continueText: "Continue",
      onContinue: () {},
    ),
  );
}
