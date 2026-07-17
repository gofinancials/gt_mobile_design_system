import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _lessonsController = GtLessonslideController(
  slides: [
    GtLessonSlideData.withImage(
      color: GtColors.pink100.value,
      title: "LESSON 1",
      data: AppImageData(GtVectorIllustrations.vault),
      alignment: Alignment.center,
      header: const GtLessonSlideHeader(
        title: "WHAT IS SAVING",
        subTitle: "Saving means keeping some of your money to use later instead of spending it all at once.",
      ),
    ),
    GtLessonSlideData.withImage(
      color: GtColors.purple100.value,
      title: "LESSON 2",
      data: AppImageData(GtVectorIllustrations.cash),
      alignment: Alignment.center,
      header: GtLessonSlideHeader(
        title: "why saving matters?".toUpperCase(),
        subTitle: "Saving helps you plan ahead, buy things you really want, and handle unexpected needs.",
      ),
    ),
  ],
);

@widgetbook.UseCase(name: 'GtLessonSlides', type: GtLessonSlides)
Widget playgroundGtLessonSlidesDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtLessonSlides',
    description: 'An educational slides template supporting lessons, images, audio/video playback, and navigation controls.',
    code: '''
GtLessonSlides(
  controller: lessonsController,
  onCancel: () => handleCancel(),
  onCompleted: () => handleCompleted(),
)''',
    child: GtEmptyStateCard(
      description: 'Select "GtLessonSlides Gallery" in the sidebar to view the interactive lesson slides in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtLessonSlides Gallery', type: GtLessonSlides)
Widget playgroundGtLessonSlidesUseCase(BuildContext context) {
  return GtLessonSlides(
    controller: _lessonsController,
    indicatorColor: context.knobs.colorOrNull(label: "Indicator Color"),
    onCancel: () {},
    onCompleted: () {},
  );
}
