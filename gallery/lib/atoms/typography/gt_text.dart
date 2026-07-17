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
)
''',
    child: GtText(
      text,
      style: style.$2,
      softWrap: softWrap,
      textDirection: direction,
      maxLines: maxLines,
      textAlign: alignment,
    ),
  );
}
