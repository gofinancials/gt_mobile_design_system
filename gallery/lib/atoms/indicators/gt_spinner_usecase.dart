import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSpinner', type: GtSpinner)
Widget playgroundGtSpinnerUseCase(BuildContext context) {
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: 32.0,
    min: 16.0,
    max: 64.0,
  );
  final isDeterminate = context.knobs.boolean(
    label: 'Determinate Mode',
    initialValue: false,
  );
  final value = isDeterminate
      ? context.knobs.double.slider(
          label: 'Progress Value',
          initialValue: 0.5,
          min: 0.0,
          max: 1.0,
        )
      : null;

  final colorOption = context.knobs.object.dropdown(
    label: 'Color Variant',
    options: ['Default (Theme)', 'Feature', 'Success', 'Error'],
    initialOption: 'Default (Theme)',
  );

  Color? selectColor() {
    switch (colorOption) {
      case 'Feature':
        return context.palette.feature.base;
      case 'Success':
        return context.palette.success.base;
      case 'Error':
        return context.palette.error.base;
      default:
        return null;
    }
  }

  final selectedColor = selectColor();
  final computedColor = selectedColor ?? context.palette.stroke.strong;

  final codeSnippet =
      '''
GtSpinner(
  size: $size,
  color: Color(0x${computedColor.toARGB32().toRadixString(16)}),${value != null ? '\n  value: $value,' : ''}
)''';

  return GtWidgetDocPage(
    title: 'GtSpinner',
    description: '''
<b>GtSpinner</b> is a circular loading indicator with two modes:
• <b>Indeterminate:</b> Continuously animating spinner (omit <e>value</e>)
• <b>Determinate:</b> Pie-chart style progress with <e>value</e> (0.0 to 1.0)''',
    code: codeSnippet,
    child: GtSpinner(size: size, color: selectedColor, value: value),
  );
}
