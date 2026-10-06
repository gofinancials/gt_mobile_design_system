import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtGlassSurface', type: GtGlassSurface)
Widget playgroundGtGlassSurfaceUseCase(BuildContext context) {
  final isCircle = context.knobs.boolean(label: 'Circle', initialValue: false);
  final width = context.knobs.double.slider(
    label: 'Width',
    min: 36,
    max: 240,
    divisions: 51,
    initialValue: 120,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    min: 36,
    max: 120,
    divisions: 21,
    initialValue: 36,
  );

  final boxHeight = isCircle ? width : height;
  final shapeCode = isCircle ? 'CircleBorder' : 'StadiumBorder';
  final codeSnippet =
      '''
GtGlassSurface(
  shape: const $shapeCode(),
  child: ColoredBox(
    color: context.palette.primary.alpha10,
    child: SizedBox(width: $width, height: $boxHeight),
  ),
)''';

  return GtWidgetDocPage(
    title: 'GtGlassSurface',
    description: '''
<b>GtGlassSurface</b> draws raised glass: a frosted backdrop clipped to a shape, with a light rim along the upper-left and lower-right edges.
It approximates Figma's Liquid Glass at a light angle of -45° and draws no fill of its own, so its child supplies the tint.

<b>When to use:</b> Glass chrome over imagery or gradients. For buttons, prefer <b>enableGlassEffect</b> on <b>GtIconButton</b> or <b>GtRaisedButton</b>.''',
    code: codeSnippet,
    child: GalleryGlassBackdrop(
      child: Center(
        child: GtGlassSurface(
          shape: isCircle ? const CircleBorder() : const StadiumBorder(),
          child: ColoredBox(
            color: context.palette.primary.alpha10,
            child: SizedBox(width: width, height: boxHeight),
          ),
        ),
      ),
    ),
  );
}
