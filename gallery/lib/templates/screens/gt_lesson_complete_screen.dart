import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLessonCompleteScreen', type: GtLessonCompleteScreen)
Widget buildGtLessonCompleteScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtLessonCompleteScreen',
    description: 'A reward/completion screen layout showing points earned, illustration graphics, and navigation routes.',
    code: '''
GtLessonCompleteScreen(
  title: "lesson complete",
  subtitle: "You earned points for learning how to save smart.",
  primaryButton: GtRaisedButton(
    text: "Start Saving",
    onPressed: () => handleStartSaving(),
  ),
  secondaryButton: GtTextButton(
    text: "back to learn",
    onPressed: () => handleBackToLearn(),
  ),
)''',
    child: GtEmptyStateCard(
      description: 'Select "GtLessonCompleteScreen Gallery" in the sidebar to view the interactive completion screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtLessonCompleteScreen Gallery', type: GtLessonCompleteScreen)
Widget buildGtLessonCompleteScreenUsecase(BuildContext context) {
  return GtLessonCompleteScreen(
    title: context.knobs.string(
      label: "Title",
      initialValue: "lesson complete",
    ),
    subtitle: context.knobs.string(
      label: "Subtitle",
      initialValue: "You earned points for learning how to save smart. The more you save, the more you unlock.",
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
