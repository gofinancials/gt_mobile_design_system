import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtMemoryImage', type: GtMemoryImage)
Widget playgroundGtMemoryImageUseCase(BuildContext context) {
  // 1x1 transparent PNG base64
  final bytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
  );

  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 100.0,
    min: 48.0,
    max: 200.0,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 100.0,
    min: 48.0,
    max: 200.0,
  );

  final codeSnippet =
      '''
GtMemoryImage(
  bytesData, // Uint8List
  width: $width,
  height: $height,
)''';

  return GtWidgetDocPage(
    title: 'GtMemoryImage',
    description: '''
<b>GtMemoryImage</b> renders raw image bytes directly from memory.

<b>Related:</b>
• <b>GtNetworkImage:</b> For remote URLs
• <b>GtAssetImage:</b> For bundled assets''',
    code: codeSnippet,
    child: Container(
      color: Colors.amber, // so the transparent image stands out
      child: GtMemoryImage(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    ),
  );
}
