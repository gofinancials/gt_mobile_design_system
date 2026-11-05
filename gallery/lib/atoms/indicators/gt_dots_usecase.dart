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
    max: 40,
  );
  final currentIndex = context.knobs.int.slider(
    label: 'Current Index',
    initialValue: 2,
    min: 0,
    max: totalDots,
  );
  final capDots = context.knobs.boolean(label: 'Cap Dots', initialValue: false);
  final maxVisible = context.knobs.int.slider(
    label: 'Max Visible',
    initialValue: 7,
    min: 1,
    max: 15,
  );
  final dotsMaxVisible = capDots ? maxVisible : null;
  final dotsLabel = 'Card $currentIndex of $totalDots';

  return GtWidgetDocPage(
    title: "Dot Indicators",
    description:
        "Dots used for indicating current position in a list or sequence. "
        "GtDots and GtScaledDots draw a dot for every page by default, "
        "wrapping onto more rows on a long list. Set maxVisible to cap them: "
        "past that many pages they show a window of maxVisible dots on one "
        "row, with the active dot in the middle except near either end of the "
        "list, and the window slides over 300ms as the index changes. "
        "GtScaledDots shrinks dots with their distance from the active one; "
        "GtDots keeps them full size but halves an edge dot with more pages "
        "beyond it. Raise Total Dots, turn on Cap Dots and move Current Index "
        "to try it. "
        "semanticsLabel should still give the real position.",
    code:
        '''
GtDots(
  $currentIndex,
  length: $totalDots,${dotsMaxVisible == null ? '' : '\n  maxVisible: $dotsMaxVisible,'}
  semanticsLabel: '$dotsLabel',
),

GtScaledDots(
  $currentIndex,
  length: $totalDots,${dotsMaxVisible == null ? '' : '\n  maxVisible: $dotsMaxVisible,'}
  semanticsLabel: '$dotsLabel',
),

GtInputDots(inputValue: "${'0' * currentIndex}", maxLength: $totalDots),
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtDots"),
        GtDots(
          currentIndex - 1,
          length: totalDots,
          maxVisible: dotsMaxVisible,
          semanticsLabel: dotsLabel,
        ),
        const GtGap.ySectionSm(),

        GalleryPageSectionHeader(title: "GtScaledDots"),
        GtScaledDots(
          currentIndex - 1,
          length: totalDots,
          maxVisible: dotsMaxVisible,
          semanticsLabel: dotsLabel,
        ),
        const GtGap.ySectionSm(),

        GalleryPageSectionHeader(title: "GtInputDots"),
        GtInputDots(inputValue: '0' * currentIndex, maxLength: totalDots),
      ],
    ),
  );
}
