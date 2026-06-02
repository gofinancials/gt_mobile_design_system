import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
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
    GtSlideData(
      title: "we’ve got deals!",
      subtitle: "Saving big on everything, stress, subscriptions etc",
      image: AppImageData.asset(GtVectorIllustrations.celebration),
      backgroundColor: palette.away.base,
      textColor: palette.staticColors.white,
    ),
    GtSlideData(
      title: "SEND MONEY",
      subtitle: "Pay someone, buy something, or sort your bills",
      image: AppImageData.asset(GtVectorIllustrations.date),
      backgroundColor: palette.feature.base,
      textColor: palette.staticColors.white,
    ),
  ];
}

final _lessonsController = GtLessonslideController(
  slides: [
    GtLessonSlideData.withImage(
      color: GtColors.pink100.value,
      title: "LESSON 1",
      data: AppImageData(GtVectorIllustrations.vault),
      alignment: .center,
      header: GtLessonSlideHeader(
        title: "WHAT IS SAVING",
        subTitle:
            "Saving means keeping some of your money to use later instead of spending it all at once.",
      ),
    ),
    GtLessonSlideData.withImage(
      color: GtColors.purple100.value,
      title: "LESSON 2",
      data: AppImageData(GtVectorIllustrations.cash),
      alignment: .center,
      header: GtLessonSlideHeader(
        title: "why saving matters?".upper,
        subTitle:
            "Saving helps you plan ahead, buy things you really want, and handle unexpected needs.",
      ),
    ),
    GtLessonSlideData.withImage(
      color: GtColors.yellow100.value,
      title: "LESSON 3",
      data: AppImageData(GtVectorIllustrations.coins),
      alignment: .center,
      header: GtLessonSlideHeader(
        title: "WHAT IS SAVING",
        subTitle:
            "Saving means keeping some of your money to use later instead of spending it all at once.",
      ),
    ),
    GtLessonSlideData.withImage(
      alignment: .bottomRight,
      title: "LESSON 4",
      data: AppImageData(
        "https://storage.googleapis.com/dump-storage-jesse/enter_account_number.png",
      ),
      imageSize: null,
      header: GtLessonSlideHeader(
        title: "enter account number".upper,
        subTitle: "Enter account number in the field below or select contact",
      ),
    ),
    GtLessonSlideData.withImage(
      alignment: .bottomRight,
      title: "LESSON 5",
      data: AppImageData(
        "https://storage.googleapis.com/dump-storage-jesse/select_bank.png",
      ),
      imageSize: null,
      header: GtLessonSlideHeader(
        title: "select bank".upper,
        subTitle: "Select beneficiary’s bank from suggested or all banks list",
      ),
    ),
    GtLessonSlideData.withImage(
      alignment: .bottomRight,
      title: "LESSON 6",
      data: AppImageData(
        "https://storage.googleapis.com/dump-storage-jesse/enter_amount.png",
      ),
      imageSize: null,
      header: GtLessonSlideHeader(
        title: "enter amount".upper,
        subTitle: "Enter the amount you want to send to beneficary",
      ),
    ),
    GtLessonSlideData.withAV(
      title: "LESSON 7",
      header: GtLessonSlideHeader(
        title: "Zero Transfer Charges".upper,
        subTitle: "Learn how to use our Design System",
      ),
      data: AppAvData(document: "https://www.youtube.com/shorts/MXAn49kEcj4"),
    ),
    GtLessonSlideData.withAV(
      title: "LESSON 8",
      header: GtLessonSlideHeader(
        title: "GT Design System".upper,
        subTitle: "Learn how to use our Design System",
      ),
      data: AppAvData(
        document:
            "https://res.cloudinary.com/jesse-dirisu/video/upload/v1776117368/Screen_Recording_2026-04-13_at_22.42.31_brfzia.mov",
      ),
    ),
    GtLessonSlideData.withAV(
      title: "LESSON 9",
      header: GtLessonSlideHeader(
        title: "Interview with Forough Farrokhzad".upper,
        subTitle:
            "Iraj Gorgin talks about his experience with Forough Farrokhzad and her poetry",
      ),
      data: AppAvData(
        document:
            "https://res.cloudinary.com/jesse-dirisu/video/upload/v1768484372/Transcribr%20Audio%20Sources/Iraj_Gorgin_s_Interview_with_Forough_Farrokhzad.mp3",
      ),
    ),
  ],
);

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

@widgetbook.UseCase(name: 'GtLessonSlides', type: GtLessonSlides)
Widget buildGtLessonSlidesUsecase(BuildContext context) {
  return GtLessonSlides(
    controller: _lessonsController,
    indicatorColor: context.knobs.colorOrNull(label: "Indicator Color"),
    onCancel: () {},
    onCompleted: () {},
  );
}
