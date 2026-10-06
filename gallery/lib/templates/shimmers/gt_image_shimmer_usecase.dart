import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtImageShimmer', type: GtImageShimmer)
Widget playgroundGtImageShimmerUseCase(BuildContext context) {
  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 160,
    min: 24,
    max: 320,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 120,
    min: 24,
    max: 320,
  );
  final shape = context.knobs.object.dropdown<BoxShape>(
    label: 'Shape',
    options: BoxShape.values,
    initialOption: BoxShape.rectangle,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtImageShimmer',
    description:
        'A shimmering block standing in for an image while it loads. GtNetworkImage draws one by default; inside a GtSkeleton it joins that skeleton\'s sweep.',
    code:
        '''
GtImageShimmer(
  width: ${width.toStringAsFixed(0)},
  height: ${height.toStringAsFixed(0)},
  shape: BoxShape.${shape.name},
)''',
    child: Center(
      child: GtImageShimmer(width: width, height: height, shape: shape),
    ),
  );
}
