import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtInstructionCard', type: GtInstructionCard)
Widget playgroundGtInstructionCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtInstructionCard',
    description: 'Documentation for GtInstructionCard',
    code: '''
GtInstructionCard(
  icon: GtIcon(GtIcons.camera),
  title: "Take a selfie",
  description: "Please ensure your face is well lit.",
  onTap: () {},
)
''',
    child: GtInstructionCard(
      icon: const GtIcon(GtIcons.camera),
      title: "Take a selfie",
      description: "Please ensure your face is well lit.",
      onPressed: () {},
    ),
  );
}
