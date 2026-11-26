import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _footerText =
    "By continuing, you certify you are over the age of 18 and agree to the <a href='https://www.google.com'>Terms of Service</a> and <a href='https://www.google.com'>Privacy Policy</a>.";

@widgetbook.UseCase(name: 'GtPhotoWelcomeScreen', type: GtPhotoWelcomeScreen)
Widget playgroundGtPhotoWelcomeScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtPhotoWelcomeScreen',
    description:
        'A welcome screen with a full-bleed photograph under the OneBank by Sterling lockup, a mixed-case headline and description, and the open-account and log-in buttons. Further slides are swiped to; it never advances on its own.',
    code: '''
GtPhotoWelcomeScreen(
  slides: [
    GtPhotoWelcomeSlideData(
      title: "Banking for every day",
      description: "Send money, pay bills and save for what matters.",
      image: welcomePhoto,
    ),
  ],
  footerText: termsRichText,
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
          'Select "GtPhotoWelcomeScreen Gallery" in the sidebar to view the welcome screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtPhotoWelcomeScreen Gallery',
  type: GtPhotoWelcomeScreen,
)
Widget playgroundGtPhotoWelcomeScreenUseCase(BuildContext context) {
  final showStash = context.knobs.boolean(
    label: 'Stash slide',
    initialValue: true,
  );

  return GtPhotoWelcomeScreen(
    slides: [
      GtPhotoWelcomeSlideData(
        title: "Banking for every day",
        description: "Send money, pay bills and save for what matters.",
        image: NetworkImage(GtNetworkImages.personalSlide1Bg),
      ),
      if (showStash)
        GtPhotoWelcomeSlideData(
          title: "Save for what matters",
          description: "Set money aside in a Stash and watch it grow.",
          image: NetworkImage(GtNetworkImages.personalSlide3Bg),
        ),
    ],
    footerText: _footerText,
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
