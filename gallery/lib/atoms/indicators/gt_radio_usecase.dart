import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtRadio', type: GtRadio)
Widget playgroundGtRadioUseCase(BuildContext context) {
  final style = context.knobs.object.dropdown(
    label: 'Style',
    options: GtRadioStyle.values,
    initialOption: GtRadioStyle.standard,
    labelBuilder: (s) => s.name,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final activeColor = context.knobs.objectOrNull.dropdown<Color?>(
    label: 'Active Colour',
    options: [
      null,
      context.palette.primary.base,
      context.palette.success.base,
      context.palette.error.base,
    ],
    initialOption: null,
  );

  return GtWidgetDocPage(
    title: 'GtRadio',
    description:
        'Radio button in standard and donut styles with active/disabled states.',
    code:
        '''
GtRadio<String>(
  value: 'selected',
  groupValue: 'selected',
  onChanged: (val) {},
  style: .${style.name},
  disabled: $disabled,
)
''',
    child: Column(
      mainAxisSize: .min,
      children: [
        GtRadio<String>(
          value: 'selected',
          groupValue: 'selected',
          onChanged: (_) {},
          style: style,
          disabled: disabled,
          activeColor: activeColor,
        ),
        const GtGap.yMd(),
        Row(
          mainAxisSize: .min,
          children: [
            _RadioVariant(label: 'Standard', style: .standard),
            const SizedBox(width: 8),
            _RadioVariant(label: 'Donut', style: .donut),
            const SizedBox(width: 8),
            _RadioVariant(label: 'Unselected', style: style, selected: false),
            const SizedBox(width: 8),
            _RadioVariant(label: 'Disabled', style: style, disabled: true),
          ],
        ),
      ],
    ),
  );
}

class _RadioVariant extends StatelessWidget {
  final String label;
  final GtRadioStyle style;
  final bool selected;
  final bool disabled;

  const _RadioVariant({
    required this.label,
    required this.style,
    this.selected = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GtRadio<String>(
          value: selected ? 'selected' : 'other',
          groupValue: 'selected',
          onChanged: (_) {},
          style: style,
          disabled: disabled,
        ),
        const GtGap.yXs(),
        GtText(label, style: context.textStyles.bodyXs()),
      ],
    );
  }
}
