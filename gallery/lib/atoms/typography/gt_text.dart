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

  final styleName = context.knobs.list<String>(
    label: "Text Style",
    options: [
      'd1',
      'd2',
      'd3',
      'd4',
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'bodyXl',
      'bodyL',
      'bodyM',
      'bodyS',
      'bodyXs',
      'labelXl',
      'labelL',
      'labelM',
      'labelS',
      'labelXs',
    ],
    initialOption: 'bodyM',
  );

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

  TextStyle getStyle() {
    switch (styleName) {
      case 'd1':
        return context.textStyles.d1();
      case 'd2':
        return context.textStyles.d2();
      case 'd3':
        return context.textStyles.d3();
      case 'd4':
        return context.textStyles.d4();
      case 'h1':
        return context.textStyles.h1();
      case 'h2':
        return context.textStyles.h2();
      case 'h3':
        return context.textStyles.h3();
      case 'h4':
        return context.textStyles.h4();
      case 'h5':
        return context.textStyles.h5();
      case 'h6':
        return context.textStyles.h6();
      case 'bodyXl':
        return context.textStyles.bodyXl();
      case 'bodyL':
        return context.textStyles.bodyL();
      case 'bodyM':
        return context.textStyles.bodyM();
      case 'bodyS':
        return context.textStyles.bodyS();
      case 'bodyXs':
        return context.textStyles.bodyXs();
      case 'labelXl':
        return context.textStyles.labelXl();
      case 'labelL':
        return context.textStyles.labelL();
      case 'labelM':
        return context.textStyles.labelM();
      case 'labelS':
        return context.textStyles.labelS();
      case 'labelXs':
        return context.textStyles.labelXs();
      default:
        return context.textStyles.bodyM();
    }
  }

  return GtWidgetDocPage(
    title: 'GtText',
    description:
        'A standardized text widget that uses the design system typography.',
    code:
        '''
GtText(
  '$text',
  style: context.textStyles.$styleName(),
  softWrap: $softWrap,
  maxLines: $maxLines,
  textAlign: $alignment,
  textDirection: $direction,
)
''',
    child: GtText(
      text,
      style: getStyle(),
      softWrap: softWrap,
      textDirection: direction,
      maxLines: maxLines,
      textAlign: alignment,
    ),
  );
}
