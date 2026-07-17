import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtCheckBox', type: GtCheckBox)
Widget playgroundGtCheckBoxUseCase(BuildContext context) {
  final isActive = context.knobs.boolean(label: 'Active', initialValue: true);
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final shape = context.knobs.object.dropdown(
    label: 'Shape',
    options: GtCheckBoxShape.values,
    initialOption: GtCheckBoxShape.square,
    labelBuilder: (s) => s.name,
  );
  final activeColor = context.knobs.objectOrNull.dropdown<Color?>(
    label: 'Active Colour',
    options: [
      null,
      context.palette.primary.base,
      context.palette.success.base,
      context.palette.error.base,
      context.palette.warning.base,
    ],
    initialOption: null,
  );

  return GtWidgetDocPage(
    title: 'GtCheckBox',
    description:
        'Square and circle checkbox variants with active/disabled states.',
    code:
        '''
GtCheckBox<int>(
  value: 1,
  onChanged: (val) {},
  isActive: $isActive,
  disabled: $disabled,
  shape: .${shape.name},
)
''',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GtCheckBox<int>(
          value: 1,
          onChanged: (_) {},
          isActive: isActive,
          disabled: disabled,
          shape: shape,
          activeColor: activeColor,
        ),
        const GtGap.yMd(),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: context.spacingBase,
          children: [
            _LabeledCheckBox(
              label: 'Square',
              isActive: !disabled,
              shape: GtCheckBoxShape.square,
            ),
            _LabeledCheckBox(
              label: 'Circle',
              isActive: isActive,
              shape: GtCheckBoxShape.circle,
            ),
            _LabeledCheckBox(
              label: 'Disabled',
              isActive: false,
              disabled: true,
              shape: GtCheckBoxShape.square,
            ),
          ],
        ),
      ],
    ),
  );
}

class _LabeledCheckBox extends StatelessWidget {
  final String label;
  final bool isActive;
  final GtCheckBoxShape shape;
  final bool disabled;

  const _LabeledCheckBox({
    required this.label,
    required this.isActive,
    this.shape = GtCheckBoxShape.square,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GtCheckBox<int>(
          value: 1,
          onChanged: (_) {},
          isActive: isActive,
          disabled: disabled,
          shape: shape,
        ),
        const GtGap.yXs(),
        GtText(label, style: context.textStyles.bodyXs()),
      ],
    );
  }
}
