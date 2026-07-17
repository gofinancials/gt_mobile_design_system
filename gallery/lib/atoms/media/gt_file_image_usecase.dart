import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtFileImage', type: GtFileImage)
Widget playgroundGtFileImageUseCase(BuildContext context) {
  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 120.0,
    min: 48.0,
    max: 200.0,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 120.0,
    min: 48.0,
    max: 200.0,
  );

  final codeSnippet =
      '''
GtFileImage(
  "/path/to/imageFile", // File object or null
  width: $width,
  height: $height,
)''';

  return GtWidgetDocPage(
    title: 'GtFileImage',
    description: '''
<b>GtFileImage</b> renders images stored in local device files.
If the file is null or invalid, it falls back to a placeholder sized box.

<b>Related:</b>
• <b>GtNetworkImage:</b> For remote URLs
• <b>GtAssetImage:</b> For bundled assets''',
    code: codeSnippet,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.palette.stroke.strong),
      ),
      child: GtFileImage(null, width: width, height: height),
    ),
  );
}
