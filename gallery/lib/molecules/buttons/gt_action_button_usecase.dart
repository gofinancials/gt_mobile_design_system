import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtActionButton', type: GtActionButton)
Widget playgroundGtActionButtonUseCase(BuildContext context) {
  final label = context.knobs.stringOrNull(
    label: 'Label',
    initialValue: 'Send money',
  );
  final icon = context.knobs.object.dropdown<({String label, IconData value})>(
    label: 'Icon',
    options: [
      (label: 'sendSolid', value: GtIcons.sendSolid),
      (label: 'transfer', value: GtIcons.transfer),
      (label: 'walletAlt', value: GtIcons.walletAlt),
      (label: 'airtime', value: GtIcons.airtime),
    ],
    initialOption: (label: 'sendSolid', value: GtIcons.sendSolid),
    labelBuilder: (option) => option.label,
  );
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: 56,
    min: GtActionButton.minTapTargetSize,
    max: 96,
    divisions: 13,
  );
  // Clamped because GtActionButton asserts iconSize <= size.
  final iconSize = context.knobs.double
      .slider(label: 'Icon size', initialValue: 24, min: 12, max: 96)
      .clamp(12.0, size)
      .toDouble();

  return GtWidgetDocPage(
    title: 'GtActionButton',
    description:
        'A stacked icon action button — a square icon tile with an optional '
        'caption underneath — used for quick-action strips on dashboards and '
        'account screens. Note that backgroundColor is currently unused by the '
        'widget, so iconColor is set here to keep the icon visible against the '
        'light preview surface.',
    code:
        '''
GtActionButton(
  icon: GtIcons.${icon.label},
  label: ${label == null ? 'null' : '"$label"'},
  size: $size,
  iconSize: $iconSize,
  backgroundColor: context.palette.primary.base,
  iconColor: context.palette.primary.base,
  onPressed: () {},
)''',
    accessibilityNotes: const [
      'The button is wrapped in a GtTapTarget, so its responsive area never '
          'falls below 44x44 even when size renders smaller on narrow screens.',
      'size is asserted to be at least 44 logical pixels; iconSize is asserted '
          'not to exceed it.',
      'When label is null the button is icon-only — supply an accessible name '
          'through the surrounding semantics so screen readers announce it.',
    ],
    child: Center(
      child: GtActionButton(
        icon: icon.value,
        label: label,
        size: size,
        iconSize: iconSize,
        backgroundColor: context.palette.raw.pink500,
        iconColor: context.palette.staticColors.white,
        onPressed: () => context.showToast('${label ?? 'Action'} tapped'),
      ),
    ),
  );
}
