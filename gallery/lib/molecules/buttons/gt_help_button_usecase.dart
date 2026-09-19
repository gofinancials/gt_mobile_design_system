import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHelpButton', type: GtHelpButton)
Widget playgroundGtHelpButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.secondary,
    labelBuilder: (v) => v.name,
  );
  final customBg = context.knobs.boolean(
    label: 'Custom Background Color',
    initialValue: false,
  );
  final customText = context.knobs.boolean(
    label: 'Custom Text Color',
    initialValue: false,
  );
  final iconSize = context.knobs.doubleOrNull.slider(
    label: 'Icon Size',
    min: 12,
    max: 28,
    divisions: 16,
    initialValue: 20,
    defaultToNull: true,
  );
  final iconSpacing = context.knobs.doubleOrNull.slider(
    label: 'Icon Spacing',
    min: 0,
    max: 16,
    divisions: 16,
    initialValue: 6,
    defaultToNull: true,
  );
  final horizontalPadding = context.knobs.doubleOrNull.slider(
    label: 'Horizontal Padding',
    min: 0,
    max: 24,
    divisions: 24,
    initialValue: 6,
    defaultToNull: true,
  );

  final bgColor = customBg ? context.palette.primary.alpha16 : null;
  final textColor = customText ? context.palette.primary.dark : null;

  EdgeInsets? contentPadding;
  if (horizontalPadding case double padding) {
    contentPadding = EdgeInsets.symmetric(horizontal: padding);
  }

  final codeArgs = [
    'variant: GtButtonVariant.${variant.name},',
    if (customBg) 'backgroundColor: context.palette.primary.alpha16,',
    if (customText) 'textColor: context.palette.primary.dark,',
    if (iconSize case double size) 'iconSize: $size,',
    if (iconSpacing case double spacing) 'iconSpacing: $spacing,',
    if (horizontalPadding case double padding)
      'contentPadding: EdgeInsets.symmetric(horizontal: $padding),',
    'onPressed: () {},',
  ];
  final codeSnippet = 'GtHelpButton(\n  ${codeArgs.join('\n  ')}\n)';

  return GtWidgetDocPage(
    title: 'GtHelpButton',
    description: '''
<b>GtHelpButton</b> is a standardized help action button used across app bars and screens.
It renders a compact <b>GtRaisedButton</b> configured with a spark icon and localized help text.''',
    code: codeSnippet,
    child: GtHelpButton(
      variant: variant,
      backgroundColor: bgColor,
      textColor: textColor,
      iconSize: iconSize,
      iconSpacing: iconSpacing,
      contentPadding: contentPadding,
      onPressed: () {},
    ),
  );
}
