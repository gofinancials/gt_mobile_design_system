import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDots', type: GtDots)
Widget gtDotsUseCase(BuildContext context) {
  final totalDots = context.knobs.int.slider(
    label: 'Total Dots',
    initialValue: 5,
    min: 0,
    max: 10,
  );
  final currentIndex = context.knobs.int.slider(
    label: 'Current Index',
    initialValue: 2,
    min: 0,
    max: totalDots,
  );

  return GtWidgetDocPage(
    title: "Dot Indicators",
    description:
        "Dots used for indicating current position in a list or sequence.",
    code:
        '''
GtDots($currentIndex, length: $totalDots),

GtScaledDots($currentIndex, length: $totalDots),

GtInputDots(inputValue: "${'0' * currentIndex}", maxLength: $totalDots),
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtDots"),
        GtDots(currentIndex - 1, length: totalDots),
        const GtGap.ySectionSm(),

        GalleryPageSectionHeader(title: "GtScaledDots"),
        GtScaledDots(currentIndex - 1, length: totalDots),
        const GtGap.ySectionSm(),

        GalleryPageSectionHeader(title: "GtInputDots"),
        GtInputDots(inputValue: '0' * currentIndex, maxLength: totalDots),
      ],
    ),
  );
}
