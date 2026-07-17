import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLessonSlide', type: GtLessonSlide)
Widget playgroundGtLessonSlideUseCase(BuildContext context) {
  final controller = GtLessonslideController(
    slides: [
      const GtLessonSlideData.withText(
        header: GtLessonSlideHeader(
          title: "Chapter 1",
          subTitle: "Introduction",
        ),
        data: "This is the first slide of the lesson.",
        title: "Welcome",
      ),
    ],
  );
  return GtWidgetDocPage(
    title: 'GtLessonSlide',
    description: 'Documentation for GtLessonSlide',
    code: '''
GtLessonSlide(
  controller: GtLessonslideController(
    slides: [
      GtLessonSlideData.withText(
        header: GtLessonSlideHeader(
          title: "Chapter 1",
          subTitle: "Introduction",
        ),
        data: "This is the first slide of the lesson.",
        title: "Welcome",
      ),
    ],
  ),
  onTapNext: () {},
  onTapPrev: () {},
  onLongPressDown: () {},
  onLongPressUp: () {},
)
''',
    child: GtLessonSlide(
      controller: controller,
      onTapNext: () {},
      onTapPrev: () {},
      onLongPressDown: () {},
      onLongPressUp: () {},
    ),
  );
}
