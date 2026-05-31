import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtLessonCompleteScreen',
  type: GtLessonCompleteScreen,
)
Widget buildGtLessonCompletScreen(BuildContext context) {
  return GtLessonCompleteScreen(
    title: context.knobs.string(
      label: "Title",
      initialValue: "lesson complete",
    ),
    subtitle: context.knobs.string(
      label: "Subtitle",
      initialValue:
          "You earned points for learning how to save smart. The more you save, the more you unlock.",
    ),
    primaryButton: GtRaisedButton(
      text: context.knobs.string(
        label: "Primary Button",
        initialValue: "Start Saving",
      ),
      onPressed: () {},
    ),
    secondaryButton: GtTextButton(
      text: context.knobs.string(
        label: "Secondary Button",
        initialValue: "back to learn",
      ),
      onPressed: () {},
    ),
  );
}
