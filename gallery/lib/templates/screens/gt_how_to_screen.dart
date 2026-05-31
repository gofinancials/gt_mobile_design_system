import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHowToLearnScreen', type: GtHowToLearnScreen)
Widget buildGtHowToLearnScreenUsecase(BuildContext context) {
  return GtHowToLearnScreen(
    title: context.knobs.string(label: "Title", initialValue: "how to learn"),
    description: context.knobs.string(
      label: "Description",
      initialValue:
          "You can use these gestures to control how you move between lessons",
    ),
    instructions: [
      GtHowToLearnTile(
        leading: AppImageData.asset(GtVectors.tapLeft),
        instruction: "Tap left to go backward",
      ),
      GtHowToLearnTile(
        leading: AppImageData.asset(GtVectors.tapRight),
        instruction: "Tap right to go forward",
      ),
    ],
    continueText: "Tap to continue",
    onContinue: () {
      context.showToast("Tapped Continue", type: .info);
    },
  );
}
