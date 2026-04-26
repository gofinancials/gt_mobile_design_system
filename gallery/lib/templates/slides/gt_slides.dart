import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_ui/widgets/templates/slides/gt_welcome_slides.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

List<GtSlideData> getPersonalAppSlides(BuildContext context) {
  final palette = context.palette;
  return [
    GtSlideData(
      title: "And more...",
      subtitle: "Buy, sell, save or schedule with peace of mind",
      image: AppImageData(imageData: GtVectorIllustrations.date),
      backgroundColor: palette.success.darker,
      textColor: palette.staticColors.white,
    ),
    GtSlideData(
      title: "BLAZING FAST",
      subtitle: "Pay someone, buy something, or sort your bills",
      image: AppImageData(imageData: GtVectorIllustrations.bolt),
      backgroundColor: palette.primary.base,
      textColor: palette.staticColors.white,
    ),
    GtSlideData(
      title: "we’ve got deals!",
      subtitle: "Saving big on everything, stress, subscriptions etc",
      image: AppImageData(imageData: GtVectorIllustrations.celebration),
      backgroundColor: palette.away.base,
      textColor: palette.staticColors.white,
    ),
    GtSlideData(
      title: "SEND MONEY",
      subtitle: "Pay someone, buy something, or sort your bills",
      image: AppImageData(imageData: GtVectorIllustrations.date),
      backgroundColor: palette.feature.base,
      textColor: palette.staticColors.white,
    ),
  ];
}

@widgetbook.UseCase(name: 'GtWelcomeSlides', type: GtWelcomeSlides)
Widget buildGtWelcomeSlidesUsecase(BuildContext context) {
  List<GtSlideData>? slides = getPersonalAppSlides(context);
  return GtWelcomeSlides(
    slides: slides,
    showLogo: context.knobs.boolean(label: "Show Logo", initialValue: true),
    iconColor: context.knobs.colorOrNull(label: "Icon Color"),
    activeDotColor: context.knobs.colorOrNull(label: "Active dot color"),
    inActiveDotColor: context.knobs.colorOrNull(label: "Inactive dot color"),
  );
}
