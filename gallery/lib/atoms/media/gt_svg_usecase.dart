import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSvg', type: GtSvg)
Widget playgroundGtSvgUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtIconVariant.values,
    initialOption: GtIconVariant.strong,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.double.slider(
    label: 'Size',
    min: 24.0,
    max: 160.0,
    initialValue: 64.0,
  );

  final codeSnippet =
      '''
// Render SVG as a themed Icon
GtSvg.asIcon(
  GtVectors.logo,
  size: $size,
  variant: GtIconVariant.${variant.name},
)

// Render standard SVG illustration
GtSvg(
  GtVectorIllustrations.referral,
  width: $size,
  height: $size,
)''';

  return GtWidgetDocPage(
    title: 'GtSvg',
    description: '''
<b>GtSvg</b> renders SVG vector assets with theme-aware colouring.

<b>Asset sources:</b>
• <b>GtVectors:</b> Small vector icons (logo, moveMoney)
• <b>GtVectorIllustrations:</b> Large illustrations (referral, building, etc.)''',
    code: codeSnippet,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GtSvg.asIcon(GtVectors.tapRight, size: size, variant: variant),
            const SizedBox(width: 8),
            GtSvg(
              GtVectorIllustrations.announcement,
              width: size,
              height: size,
            ),
          ],
        ),
      ],
    ),
  );
}
