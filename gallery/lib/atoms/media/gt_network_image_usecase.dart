import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtNetworkImage', type: GtNetworkImage)
Widget playgroundGtNetworkImageUseCase(BuildContext context) {
  final urlOption = context.knobs.object.dropdown(
    label: 'Image URL',
    options: ['Avatar', 'Savings Illustration', 'Debit Card Mockup'],
    initialOption: 'Avatar',
  );

  String getUrl() {
    switch (urlOption) {
      case 'Savings Illustration':
        return GtNetworkImages.savings;
      case 'Debit Card Mockup':
        return GtNetworkImages.debitCard;
      default:
        return GtNetworkImages.sampleAvatar1;
    }
  }

  final selectedUrl = getUrl();
  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 80.0,
    min: 48.0,
    max: 200.0,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 80.0,
    min: 48.0,
    max: 200.0,
  );
  final fit = context.knobs.object.dropdown(
    label: 'Box Fit',
    options: BoxFit.values,
    initialOption: BoxFit.contain,
    labelBuilder: (f) => f.name,
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

  final codeSnippet =
      '''
GtNetworkImage(
  '$selectedUrl',
  width: $width,
  height: $height,
  fit: BoxFit.${fit.name},
  alignment: ${alignment.$2}
)''';

  return GtWidgetDocPage(
    title: 'GtNetworkImage',
    description: '''
<b>GtNetworkImage</b> renders images from URLs with placeholder and error handling.

<b>Related:</b>
• <b>GtAssetImage:</b> For bundled assets
• <b>GtImage:</b> General-purpose image dispatcher''',
    code: codeSnippet,
    child: GtNetworkImage(selectedUrl, width: width, height: height, fit: fit),
  );
}
