import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtNetworkImage', type: GtNetworkImage)
Widget playgroundGtNetworkImageUseCase(BuildContext context) {
  final urlOption = context.knobs.object.dropdown(
    label: 'Image URL',
    options: [
      'Avatar',
      'Savings Illustration',
      'Debit Card Mockup',
      'Broken URL',
      'Broken SVG URL',
      'Malformed Data URI',
    ],
    initialOption: 'Avatar',
  );

  String getUrl() {
    switch (urlOption) {
      case 'Savings Illustration':
        return GtNetworkImages.savings;
      case 'Debit Card Mockup':
        return GtNetworkImages.debitCard;
      case 'Broken URL':
        return GalleryBrokenImages.url;
      case 'Broken SVG URL':
        return GalleryBrokenImages.svgUrl;
      case 'Malformed Data URI':
        return GalleryBrokenImages.dataUri;
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

  final passErrorWidget = context.knobs.boolean(
    label: 'Pass errorWidget',
    initialValue: false,
  );

  final codeSnippet =
      '''
GtNetworkImage(
  '$selectedUrl',
  width: $width,
  height: $height,
  fit: BoxFit.${fit.name},
  alignment: ${alignment.$2},${passErrorWidget ? '\n  errorWidget: const MyFallback(),' : ''}
)''';

  return GtWidgetDocPage(
    title: 'GtNetworkImage',
    description: '''
<b>GtNetworkImage</b> renders images from URLs with placeholder and error handling.
When an image fails it draws <b>errorWidget</b>, or an empty box of its size without one.

<b>Related:</b>
• <b>GtAssetImage:</b> For bundled assets
• <b>GtImage:</b> General-purpose image dispatcher''',
    code: codeSnippet,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.palette.stroke.soft),
      ),
      child: GtNetworkImage(
        selectedUrl,
        width: width,
        height: height,
        fit: fit,
        errorWidget: passErrorWidget
            ? GalleryErrorFallback(size: width < height ? width : height)
            : null,
      ),
    ),
  );
}
