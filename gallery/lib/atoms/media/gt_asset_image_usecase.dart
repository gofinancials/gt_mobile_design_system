import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAssetImage', type: GtAssetImage)
Widget playgroundGtAssetImageUseCase(BuildContext context) {
  final assetOption = context.knobs.object.dropdown(
    label: 'Asset Image',
    options: ['Avatar Logo'],
    initialOption: 'Avatar Logo',
  );

  String getAssetPath() {
    switch (assetOption) {
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

  final codeSnippet = '''
GtAssetImage(
  '$selectedAsset',
  width: $width,
  height: $height,
  fit: BoxFit.${fit.name},
)''';

  return GtWidgetDocPage(
    title: 'GtAssetImage',
    description: '''
<b>GtAssetImage</b> renders local asset images from the asset bundle.
It dynamically handles SVG file extensions using <b>GtSvg</b> internally.

<b>Related:</b>
• <b>GtNetworkImage:</b> For remote URLs
• <b>GtImage:</b> Universal image handler''',
    code: codeSnippet,
    child: GtAssetImage(
      selectedAsset,
      width: width,
      height: height,
      fit: fit,
    ),
  );
}
