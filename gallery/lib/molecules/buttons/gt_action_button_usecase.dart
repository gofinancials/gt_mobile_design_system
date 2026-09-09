import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _description =
    'A stacked action button — a circular tile with an optional caption '
    'underneath — used for quick-action strips on dashboards and account '
    'screens.';

const _accessibilityNotes = [
  'The button is wrapped in a GtTapTarget, so its responsive area never falls '
      'below 44x44 even when size renders smaller on narrow screens.',
  'size is asserted to be at least 44 logical pixels; iconSize is asserted not '
      'to exceed it.',
  'When label is null the button is icon-only — supply an accessible name '
      'through the surrounding semantics so screen readers announce it.',
  'label is capped at one line and ellipsized, so verify short captions at '
      'larger text scales using the Accessibility addon.',
];

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
    description: '$_description The tile is filled with backgroundColor and '
        'the icon is tinted with iconColor.',
    code:
        '''
GtActionButton(
  icon: GtIcons.${icon.label},
  label: ${label == null ? 'null' : '"$label"'},
  size: $size,
  iconSize: $iconSize,
  backgroundColor: context.palette.raw.pink500,
  iconColor: context.palette.staticColors.white,
  onPressed: () {},
)''',
    accessibilityNotes: _accessibilityNotes,
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

@widgetbook.UseCase(name: 'GtActionButton.image', type: GtActionButton)
Widget playgroundGtActionButtonImageUseCase(BuildContext context) {
  final label = context.knobs.stringOrNull(
    label: 'Label',
    initialValue: 'Ada O.',
  );
  final image = context.knobs.object.dropdown<({String label, String value})>(
    label: 'Image',
    options: [
      (label: 'sampleAvatar1', value: GtNetworkImages.sampleAvatar1),
      (label: 'sampleAvatar2', value: GtNetworkImages.sampleAvatar2),
    ],
    initialOption: (
      label: 'sampleAvatar1',
      value: GtNetworkImages.sampleAvatar1,
    ),
    labelBuilder: (option) => option.label,
  );
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: 56,
    min: GtActionButton.minTapTargetSize,
    max: 96,
    divisions: 13,
  );
  final fit = context.knobs.object.dropdown<BoxFit>(
    label: 'Fit',
    options: const [BoxFit.cover, BoxFit.contain, BoxFit.fitWidth],
    initialOption: BoxFit.cover,
    labelBuilder: (value) => value.name,
  );

  return GtWidgetDocPage(
    title: 'GtActionButton.image',
    description: '$_description This variant paints a DecorationImage across '
        'the circle — a beneficiary avatar or merchant logo — with '
        'backgroundColor showing through while the image loads.',
    code:
        '''
GtActionButton.image(
  image: DecorationImage(
    image: NetworkImage(GtNetworkImages.${image.label}),
    fit: BoxFit.${fit.name},
  ),
  label: ${label == null ? 'null' : '"$label"'},
  size: $size,
  backgroundColor: context.palette.raw.pink500,
  onPressed: () {},
)''',
    accessibilityNotes: _accessibilityNotes,
    child: Center(
      child: GtActionButton.image(
        image: DecorationImage(image: NetworkImage(image.value), fit: fit),
        label: label,
        size: size,
        backgroundColor: context.palette.raw.pink500,
        onPressed: () => context.showToast('${label ?? 'Contact'} tapped'),
      ),
    ),
  );
}
