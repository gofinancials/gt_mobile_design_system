// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'GtText', type: GtText)
Widget playgroundGtTextUseCase(BuildContext context) {
  final text = context.knobs.string(
    label: "Text Content",
    initialValue: "The quick brown fox jumps over the lazy dog.",
  );

  final style = context.knobs.list(
    label: "Text Style",
    options: context.textStyles.all,
    initialOption: context.textStyles.all.first,
    labelBuilder: (value) => value.$1,
  );

  final pattern = RegExp(r"(?<name>.+)\s+(\((?<args>.*)\))?$");
  final match = pattern.firstMatch(style.$1);
  final args = match?.namedGroup("args");

  final softWrap = context.knobs.boolean(
    label: "Soft wrap text",
    initialValue: true,
  );

  final direction = context.knobs.listOrNull<TextDirection?>(
    label: "Text Direction",
    initialOption: null,
    options: [null, TextDirection.ltr, TextDirection.rtl],
    labelBuilder: (val) => val == null ? 'Default' : val.name,
  );

  final maxLines = context.knobs.listOrNull<int?>(
    label: "Max Lines",
    initialOption: null,
    options: [null, 1, 2, 3],
    labelBuilder: (val) => val == null ? 'None' : val.toString(),
  );

  final middleEllipsis = context.knobs.boolean(
    label: "Middle ellipsis",
    initialValue: false,
  );

  final alignment = context.knobs.listOrNull<TextAlign?>(
    label: "Text Alignment",
    initialOption: null,
    options: [
      null,
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
      TextAlign.justify,
    ],
    labelBuilder: (val) => val == null ? 'Default' : val.name,
  );

  return GtWidgetDocPage(
    title: 'GtText',
    description:
        'A standardized text widget that uses the design system typography.',
    code:
        '''
GtText(
  '$text',
  style: $args(),
  softWrap: $softWrap,
  maxLines: $maxLines,
  textAlign: $alignment,
  textDirection: $direction,
  middleEllipsis: $middleEllipsis,
)
''',
    child: GtText(
      text,
      style: style.$2,
      softWrap: softWrap,
      textDirection: direction,
      maxLines: maxLines,
      textAlign: alignment,
      middleEllipsis: middleEllipsis,
    ),
  );
}

@widgetbook.UseCase(name: 'Middle ellipsis', type: GtText)
Widget playgroundGtTextMiddleEllipsisUseCase(BuildContext context) {
  final width = context.knobs.double.slider(
    label: "Width",
    initialValue: 180,
    min: 60,
    max: 360,
  );
  final maxLines = context.knobs.object.dropdown<int>(
    label: "Max Lines",
    options: [1, 2],
    initialOption: 1,
    labelBuilder: (value) => value.toString(),
  );
  final value = context.knobs.string(
    label: "Custom Value",
    initialValue: "Domiciliary Account • 3456789012",
  );

  final samples = [
    value,
    "GB29NWBK60161331926819",
    "TRX24072983910527NGN",
    "usd account · 1020293939",
  ];
  final palette = context.palette;
  final caption = context.textStyles.bodyXs(color: palette.text.sub);
  final style = context.textStyles.labelS(weight: .w500);

  Widget row(String label, String text, bool middle) {
    return Row(
      spacing: context.spacingMd,
      children: [
        SizedBox(width: 48, child: GtText(label, style: caption)),
        Container(
          width: width,
          color: palette.bg.weak,
          child: GtText(
            text,
            style: style,
            maxLines: maxLines,
            overflow: .ellipsis,
            middleEllipsis: middle,
          ),
        ),
      ],
    );
  }

  return GtWidgetDocPage(
    title: 'Middle ellipsis',
    description:
        'Each value drawn in the same width with the default end ellipsis and '
        'with middleEllipsis. Drag "Width" to watch the cut move: the end '
        'ellipsis loses the account number or reference that tells values '
        'apart, the middle ellipsis keeps it. Screen readers hear the whole '
        'value either way.',
    code:
        '''
GtText(
  "$value",
  maxLines: $maxLines,
  middleEllipsis: true,
)

GtSummaryTileData(label: "From", value: "...", middleEllipsis: true)
GtAppBar(title: "...", titleMiddleEllipsis: true)
''',
    child: Column(
      crossAxisAlignment: .start,
      spacing: context.spacingLg,
      children: [
        for (final sample in samples)
          Column(
            crossAxisAlignment: .start,
            spacing: context.spacingXs,
            children: [row("End", sample, false), row("Middle", sample, true)],
          ),
        for (final middle in [false, true])
          SizedBox(
            width: width + 48 + context.spacingMd,
            child: GtSummaryCardShell(
              child: GtSummaryTile(
                GtSummaryTileData(
                  label: middle ? "Middle" : "End",
                  value: value,
                  middleEllipsis: middle,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
