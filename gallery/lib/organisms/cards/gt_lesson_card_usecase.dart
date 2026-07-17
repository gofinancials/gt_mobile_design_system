import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLessonCard', type: GtLessonCard)
Widget playgroundGtLessonCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtLessonCard',
    description: 'Documentation for GtLessonCard',
    code: '''
GtLessonCard(
  illustration: const AppImageData.asset("assets/images/placeholder.png"), // use real asset
  title: "Introduction to Saving",
  description: "Learn the basics of saving money.",
  totalLessons: 10,
  watchedLessons: 3,
  duration: Duration(minutes: 45),
  onTap: () {},
)
''',
    child: GtLessonCard(
      illustration: const AppImageData.asset("assets/images/placeholder.png"), // use real asset
      title: "Introduction to Saving",
      description: "Learn the basics of saving money.",
      totalLessons: 10,
      watchedLessons: 3,
      duration: const Duration(minutes: 45),
      onTap: () {},
    ),
  );
}
