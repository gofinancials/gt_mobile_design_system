import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtLottie', type: GtLottie)
Widget playgroundGtLottieUseCase(BuildContext context) {
  double height = context.knobs.double.slider(
    label: "Lottie Height",
    max: 200,
    min: 30,
    initialValue: 100,
  );
  double width = context.knobs.double.slider(
    label: "Lottie Width",
    initialValue: 100,
    max: 200,
    min: 30,
  );
  String lottieUrl = context.knobs.object.dropdown(
    label: "Test Lottie Urls",
    options: [
      'https://storage.googleapis.com/dump-storage-jesse/Saving%20the%20Money.json',
      'https://storage.googleapis.com/dump-storage-jesse/Money.json',
      GtNetworkLotties.waveForm,
    ],
    initialOption:
        "https://storage.googleapis.com/dump-storage-jesse/Saving%20the%20Money.json",
  );
  final alignment = context.knobs.object.dropdown<(String, Alignment)>(
    label: "Image Alignment",
    initialOption: ("Center", Alignment.center),
    options: [
      ("Center", Alignment.center),
      ("Center Left", Alignment.centerLeft),
      ("Center Right", Alignment.centerRight),
    ],
    labelBuilder: (value) => value.$1,
  );
  final fit = context.knobs.object.dropdown<(String, BoxFit)>(
    label: "Image Fit",
    initialOption: ("Contain", BoxFit.contain),
    options: [
      ("Contain", BoxFit.contain),
      ("Cover", BoxFit.cover),
      ("Fill", BoxFit.fill),
      ("Fit Height", BoxFit.fitHeight),
      ("Fit Width", BoxFit.fitWidth),
      ("None", BoxFit.none),
      ("Scale Down", BoxFit.scaleDown),
    ],
    labelBuilder: (value) => value.$1,
  );

  return GtWidgetDocPage(
    title: 'GtLottie',
    description:
        'Lottie animation renderer. Displays available animations from the design system.',
    code:
        '''
GtLottie(
  "$lottieUrl",
  width: $width,
  height: $height,
  alignment: ${alignment.$2}
)
''',
    child: GtLottie(
      lottieUrl,
      height: height,
      width: width,
      alignment: alignment.$2,
      fit: fit.$2,
    ),
  );
}
