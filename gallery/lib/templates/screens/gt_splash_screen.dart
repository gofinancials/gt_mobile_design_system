import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSplashScreen', type: GtSplashScreen)
Widget buildGtHowToScreenUsecase(BuildContext context) {
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
