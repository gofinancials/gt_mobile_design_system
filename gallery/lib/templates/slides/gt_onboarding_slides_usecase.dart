import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

List<GtOnboardingSlideData> getPersonalOnboardingSlides(BuildContext context) {
  return [
    GtOnboardingSlideData(
      title: "banking,\neveryday",
      image: NetworkImage(GtNetworkImages.personalSlide1Bg),
      contentImage: AppImageData(GtVectors.whiteLogo),
      contentImageWidth: 40,
      contentImageSpacer: const GtGap.yLg(),
    ),
    GtOnboardingSlideData(
      title: "Everything a bank account should do.",
      titleTextAlign: .start,
      image: NetworkImage(GtNetworkImages.personalSlide2Bg),
    ),
    GtOnboardingSlideData(
      title: "Earn 3.9% p.a. Just by banking with us.",
      titleTextAlign: .start,
      image: NetworkImage(GtNetworkImages.personalSlide3Bg),
    ),
    GtOnboardingSlideData(
      title: "SEND & receive payments from abroad.",
      titleTextAlign: .start,
      image: NetworkImage(GtNetworkImages.personalSlide4Bg),
      contentImage: AppImageData(GtVectorIllustrations.fx),
      contentImageSpacer: const GtGap.ySection4xl(),
    ),
  ];
}

@widgetbook.UseCase(name: 'GtOnboardingSlides', type: GtOnboardingSlides)
Widget playgroundGtOnboardingSlidesDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtOnboardingSlides',
    description:
        'An onboarding slides template with customizable logo, colors, and dot indicators.',
    code: '''
GtOnboardingSlides(
    slides: [],
    footerText:
        "By continuing, you certify you are over the age of 18 and agree to the <a href='https://www.google.com'>Terms of Service</a> and <a href='https://www.google.com'>Privacy Policy</a>.",
    primaryButton: GtRaisedButton(
      onPressed: () {},
      text: "Open an account",
      variant: .white,
    ),
    secondaryButton: GtOutlineButton(
      onPressed: () {},
      text: "Log In",
      variant: .white,
    ),
  )''',
    child: GtEmptyStateCard(
      description:
          'Select "GtOnboardingSlides Gallery" in the sidebar to view the interactive onboarding slides in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtOnboardingSlides Gallery',
  type: GtOnboardingSlides,
)
Widget playgroundGtWelcomeSlidesUseCase(BuildContext context) {
  return GtOnboardingSlides(
    slides: getPersonalOnboardingSlides(context),
    footerText:
        "By continuing, you certify you are over the age of 18 and agree to the <a href='https://www.google.com'>Terms of Service</a> and <a href='https://www.google.com'>Privacy Policy</a>.",
    primaryButton: GtRaisedButton(
      onPressed: () {},
      text: "Open an account",
      variant: .white,
    ),
    secondaryButton: GtOutlineButton(
      onPressed: () {},
      text: "Log In",
      variant: .white,
    ),
  );
}
