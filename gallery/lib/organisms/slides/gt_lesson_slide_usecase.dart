import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLessonSlide', type: GtLessonSlide)
Widget playgroundGtLessonSlideUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtLessonSlide',
    description: 'An interactive lesson/story slide component that manages text and video layouts.',
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
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(24.px),
        variant: GtCardVariant.normal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: context.spacingMd,
          children: [
            const GtIcon(GtIcons.spark, size: 48),
            GtText(
              "Please refer to the visual display page in Widgetbook to preview the lesson slide widgets in their full-screen/animated context.",
              style: context.textStyles.bodyS(color: context.palette.text.sub),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
