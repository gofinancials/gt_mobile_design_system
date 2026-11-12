import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAssetImage', type: GtAssetImage)
Widget playgroundGtAssetImageUseCase(BuildContext context) {
  final assetOption = context.knobs.object.dropdown(
    label: 'Asset Image',
    options: ['Avatar Logo', 'Missing Asset', 'Missing SVG Asset'],
    initialOption: 'Avatar Logo',
  );

  String getAssetPath() {
    switch (assetOption) {
      case 'Missing Asset':
        return GalleryBrokenImages.asset;
      case 'Missing SVG Asset':
        return GalleryBrokenImages.svgAsset;
      default:
        return GtAssetImages.avatar;
    }
  }

  final selectedAsset = getAssetPath();
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

  final passErrorWidget = context.knobs.boolean(
    label: 'Pass errorWidget',
    initialValue: false,
  );

  final codeSnippet =
      '''
GtAssetImage(
  '$selectedAsset',
  width: $width,
  height: $height,
  fit: BoxFit.${fit.name},${passErrorWidget ? '\n  errorWidget: const MyFallback(),' : ''}
)''';

  return GtWidgetDocPage(
    title: 'GtAssetImage',
    description: '''
<b>GtAssetImage</b> renders local asset images from the asset bundle.
It dynamically handles SVG file extensions using <b>GtSvg</b> internally.
A missing asset draws <b>errorWidget</b>, or an empty box of its size without one.

<b>Related:</b>
• <b>GtNetworkImage:</b> For remote URLs
• <b>GtImage:</b> Universal image handler''',
    code: codeSnippet,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.palette.stroke.soft),
      ),
      child: GtAssetImage(
        selectedAsset,
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
