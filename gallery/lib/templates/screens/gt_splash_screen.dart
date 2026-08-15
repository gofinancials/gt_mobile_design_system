import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// --- GtSplashScreen Usecases ---

@widgetbook.UseCase(name: 'GtSplashScreen', type: GtSplashScreen)
Widget buildGtSplashScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtSplashScreen',
    description:
        'A template for display at application launch that executes asynchronous initialization tasks.',
    code: '''
GtSplashScreen(
  task: () async => initializeApp(),
  backgroundImage: AssetImage("assets/pattern.png"),
  logo: AppImageData.asset(GtVectors.logo),
)''',
    child: GtEmptyStateCard(
      description:
          'Select "GtSplashScreen Gallery" in the sidebar to view the interactive splash screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtSplashScreen Gallery', type: GtSplashScreen)
Widget buildGtSplashScreenUsecase(BuildContext context) {
  final bgImage = context.knobs.object.dropdown<(String, ImageProvider?)>(
    label: "Background Image",
    options: const [
      ("None", null),
      ("Kids Pattern", NetworkImage(GtNetworkImages.kidsPattern)),
      ("Flex Pattern", NetworkImage(GtNetworkImages.flexPattern)),
    ],
    labelBuilder: (value) => value.$1,
  );
  return GtSplashScreen(
    task: () async {},
    backgroundImage: bgImage.$2,
    color: context.knobs.colorOrNull(label: "Background Color"),
    logo: context.knobs.object
        .dropdown(
          label: "Logo",
          initialOption: const ("None", null),
          options: const [
            ("None", null),
            ("Logo", AppImageData.asset(GtVectors.logo)),
            ("OneBankProLogo", AppImageData.asset(GtVectors.oneBankProLogo)),
            ("WhiteLogo", AppImageData.asset(GtVectors.whiteLogo)),
          ],
          labelBuilder: (value) => value.$1,
        )
        .$2,
  );
}

// --- GtWelcomeScreen Usecases ---

@widgetbook.UseCase(name: 'GtWelcomeScreen', type: GtWelcomeScreen)
Widget buildGtWelcomeScreenDoc(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtWelcomeScreen',
    description:
        'An onboarding/welcome landing screen template supporting logos, customized background images, and entry CTA buttons.',
    code: '''
GtWelcomeScreen(
  title: "Your everyday money app",
  backgroundImage: AssetImage("assets/hq.png"),
  primaryButton: GtRaisedButton(
    text: "Get Started",
    onPressed: () => handleGetStarted(),
  ),
  secondaryButton: GtOutlineButton(
    text: "Login",
    onPressed: () => handleLogin(),
  ),
)''',
    child: GtEmptyStateCard(
      description:
          'Select "GtWelcomeScreen Gallery" in the sidebar to view the interactive welcome screen in full screen.',
      icon: GtIcons.alarmClock,
    ),
  );
}

@widgetbook.UseCase(name: 'GtWelcomeScreen Gallery', type: GtWelcomeScreen)
Widget buildtGWelcomeScreenUsecase(BuildContext context) {
  final bgImage = context.knobs.object.dropdown<(String, ImageProvider?)>(
    label: "Background Image",
    options: const [
      ("None", null),
      ("Kids Pattern", NetworkImage(GtNetworkImages.kidsPattern)),
      ("Flex Pattern", NetworkImage(GtNetworkImages.flexPattern)),
      ("Head Quarters", NetworkImage(GtNetworkImages.hq)),
    ],
    labelBuilder: (value) => value.$1,
  );
  return GtWelcomeScreen(
    logo: context.knobs.object
        .dropdown(
          label: "Logo",
          initialOption: const ("None", null),
          options: [
            ("None", null),
            (
              "On Pro",
              GtImage(
                image: AppImageData.asset(GtVectors.oneBankProWordMark),
                height: 36,
              ),
            ),
          ],
          labelBuilder: (value) => value.$1,
        )
        .$2,
    decorationImageStyle: context.knobs.object
        .dropdown<(String, GtDecorationImageStyle?)>(
          label: "Decoration Image Style",
          options: [("None", null), ("Pro", GtDecorationImageStyle.pro)],
          initialOption: const ("None", null),
          labelBuilder: (value) => value.$1,
        )
        .$2,
    title: context.knobs.string(
      label: "Title",
      initialValue: "Your everyday money app",
    ),
    backgroundImage: bgImage.$2,
    titleAlignment: context.knobs.object.dropdown<Alignment>(
      label: "Title Alignment",
      options: const [Alignment.topLeft, Alignment.bottomLeft],
      initialOption: Alignment.bottomLeft,
      labelBuilder: (value) => value.toString(),
    ),
    showLogo: context.knobs.boolean(label: "Show Logo", initialValue: true),
    titleColor: context.knobs.object
        .dropdown<(String, Color)>(
          label: "Title Color",
          options: [
            ("White", context.palette.staticColors.white),
            ("Black", context.palette.staticColors.black),
            ("Feature", context.palette.feature.dark),
          ],
          labelBuilder: (value) => value.$1,
        )
        .$2,
    primaryButton: GtRaisedButton(
      variant: GtButtonVariant.white,
      text: context.knobs.string(
        label: "Primary Button Text",
        initialValue: "Get Started",
      ),
      onPressed: () {},
    ),
    secondaryButton: context.knobs.object
        .dropdown(
          label: "Secondary Button",
          options: [
            (
              "Outline Button",
              GtOutlineButton(
                text: "Login",
                onPressed: () {},
                variant: GtButtonVariant.white,
              ),
            ),
            (
              "Filled Button",
              GtRaisedButton(text: "Get Started", onPressed: () {}),
            ),
          ],
          labelBuilder: (value) => value.$1,
        )
        .$2,
  );
}

@widgetbook.UseCase(
  name: 'GtWelcomeScreen.withTitleWidget Gallery',
  type: GtWelcomeScreen,
)
Widget buildGtWelcomeScreenTitleUsecase(BuildContext context) {
  final bgImage = context.knobs.object.dropdown<(String, ImageProvider?)>(
    label: "Background Image",
    options: const [
      ("None", null),
      ("Kids Pattern", NetworkImage(GtNetworkImages.kidsPattern)),
      ("Flex Pattern", NetworkImage(GtNetworkImages.flexPattern)),
    ],
    labelBuilder: (value) => value.$1,
  );
  final titleColor = context.knobs.object.dropdown<(String, Color)>(
    label: "Title Color",
    options: [
      ("White", context.palette.staticColors.white),
      ("Black", context.palette.staticColors.black),
      ("Feature", context.palette.feature.dark),
    ],
    labelBuilder: (value) => value.$1,
  );
  final titleStyle = context.textStyles.title(color: titleColor.$2);
  return GtWelcomeScreen.withTitleWidget(
    title: context.knobs.object.dropdown<Widget>(
      label: "Title",
      initialOption: GtText(
        "OneBank",
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      options: [
        GtText("OneBank", textAlign: TextAlign.center, style: titleStyle),
        GtNetworkImage(
          GtNetworkImages.avatar3d1,
          height: context.fractionalLongest(.4),
          width: context.fractionalShortest(.6),
          fit: BoxFit.fitHeight,
          alignment: Alignment.topCenter,
        ),
      ],
    ),
    backgroundImage: bgImage.$2,
    titleAlignment: context.knobs.object.dropdown<Alignment>(
      label: "Title Alignment",
      options: const [
        Alignment.topLeft,
        Alignment.topCenter,
        Alignment.bottomLeft,
        Alignment.bottomCenter,
      ],
      initialOption: Alignment.topCenter,
      labelBuilder: (value) => value.toString(),
    ),
    showLogo: context.knobs.boolean(label: "Show Logo", initialValue: false),
    primaryButton: GtRaisedButton(
      variant: GtButtonVariant.white,
      text: context.knobs.string(
        label: "Primary Button Text",
        initialValue: "Get Started",
      ),
      onPressed: () {},
    ),
    secondaryButton: context.knobs.object
        .dropdown(
          label: "Secondary Button",
          options: [
            (
              "Outline Button",
              GtOutlineButton(
                text: "Login",
                onPressed: () {},
                variant: GtButtonVariant.white,
              ),
            ),
            (
              "Filled Button",
              GtRaisedButton(text: "Get Started", onPressed: () {}),
            ),
          ],
          labelBuilder: (value) => value.$1,
        )
        .$2,
  );
}
