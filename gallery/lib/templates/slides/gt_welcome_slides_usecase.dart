import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

List<GtSlideData> getPersonalAppSlides(BuildContext context) {
  final palette = context.palette;
  return [
    GtSlideData(
      title: "And more...",
      subtitle: "Buy, sell, save or schedule with peace of mind",
      image: AppImageData.asset(GtVectorIllustrations.date),
      backgroundColor: palette.success.darker,
      textColor: palette.staticColors.white,
    ),
    GtSlideData(
      title: "BLAZING FAST",
      subtitle: "Pay someone, buy something, or sort your bills",
      image: AppImageData.asset(GtVectorIllustrations.bolt),
      backgroundColor: palette.primary.base,
      textColor: palette.staticColors.white,
    ),
  ];
}

@widgetbook.UseCase(name: 'GtWelcomeSlides', type: GtWelcomeSlides)
Widget playgroundGtWelcomeSlidesDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtWelcomeSlides',
    description:
        'An onboarding/welcome slides template with customizable logo, colors, and dot indicators.',
    code: '''
GtWelcomeSlides(
  slides: [
    GtSlideData(
      title: "Blazing Fast",
      subtitle: "Pay someone, buy something, or sort your bills",
      image: AppImageData.asset(GtVectorIllustrations.bolt),
      backgroundColor: palette.primary.base,
      textColor: palette.staticColors.white,
    ),
  ],
  showLogo: true,
)''',
    child: GtEmptyStateCard(
      description:
          'Select "GtWelcomeSlides Gallery" in the sidebar to view the interactive welcome slides in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtWelcomeSlides Gallery', type: GtWelcomeSlides)
Widget playgroundGtWelcomeSlidesUseCase(BuildContext context) {
  return GtWelcomeSlides(
    slides: getPersonalAppSlides(context),
    showLogo: context.knobs.boolean(label: "Show Logo", initialValue: true),
    iconColor: context.knobs.colorOrNull(label: "Icon Color"),
    activeDotColor: context.knobs.colorOrNull(label: "Active dot color"),
    inActiveDotColor: context.knobs.colorOrNull(label: "Inactive dot color"),
  );
}
