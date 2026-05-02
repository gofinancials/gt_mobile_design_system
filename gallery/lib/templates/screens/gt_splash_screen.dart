import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSplashScreen', type: GtSplashScreen)
Widget buildGtSplashScreenUsecase(BuildContext context) {
  final bgImage = context.knobs.object.dropdown<(String, ImageProvider?)>(
    label: "Background Image",
    options: [
      ("None", null),
      ("Kids Pattern", NetworkImage(GtNetworkImages.kidsPattern)),
      ("Flex Pattern", NetworkImage(GtNetworkImages.flexPattern)),
    ],
  );
  return GtSplashScreen(task: () async {}, backgroundImage: bgImage.$2);
}

@widgetbook.UseCase(name: 'GtWelcomeScreen', type: GtWelcomeScreen)
Widget buildtGWelcomeScreenUsecase(BuildContext context) {
  final bgImage = context.knobs.object.dropdown<(String, ImageProvider?)>(
    label: "Background Image",
    options: [
      ("None", null),
      ("Kids Pattern", NetworkImage(GtNetworkImages.kidsPattern)),
      ("Flex Pattern", NetworkImage(GtNetworkImages.flexPattern)),
    ],
  );
  return GtWelcomeScreen(
    title: context.knobs.string(
      label: "Title",
      initialValue: "Your everyday money app",
    ),
    backgroundImage: bgImage.$2,
    titleAlignment: context.knobs.object.dropdown<Alignment>(
      label: "Title Alignment",
      options: [Alignment.topLeft, Alignment.bottomLeft],
      initialOption: .bottomLeft,
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
      variant: .white,
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
              GtOutlineButton(text: "Login", onPressed: () {}, variant: .white),
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
  name: 'GtWelcomeScreen.withTitleWidget',
  type: GtWelcomeScreen,
)
Widget buildGtWelcomeScreenTitleUsecase(BuildContext context) {
  final bgImage = context.knobs.object.dropdown<(String, ImageProvider?)>(
    label: "Background Image",
    options: [
      ("None", null),
      ("Kids Pattern", NetworkImage(GtNetworkImages.kidsPattern)),
      ("Flex Pattern", NetworkImage(GtNetworkImages.flexPattern)),
    ],
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
    title: context.knobs.object.dropdown<GtText>(
      label: "Title",
      initialOption: GtText("OneBank", textAlign: .center, style: titleStyle),
      options: [
        GtText("OneBank", textAlign: .center, style: titleStyle),
        GtText("OneBank Kids", textAlign: .center, style: titleStyle),
        GtText("OneBank Flex", textAlign: .center, style: titleStyle),
        GtText("OneBank Pro", textAlign: .center, style: titleStyle),
        GtText("GoTech", textAlign: .center, style: titleStyle),
      ],
      labelBuilder: (value) => value.data ?? "",
    ),
    backgroundImage: bgImage.$2,
    titleAlignment: context.knobs.object.dropdown<Alignment>(
      label: "Title Alignment",
      options: [.topLeft, .topCenter, .bottomLeft, .bottomCenter],
      initialOption: .topCenter,
    ),
    showLogo: context.knobs.boolean(label: "Show Logo", initialValue: false),
    primaryButton: GtRaisedButton(
      variant: .white,
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
              GtOutlineButton(text: "Login", onPressed: () {}, variant: .white),
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
