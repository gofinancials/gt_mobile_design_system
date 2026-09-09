import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

typedef _Action = ({
  String label,
  String icon,
  IconData value,
  String token,
  Color color,
});

/// Each action carries its own raw palette token so the bar reads as a set of
/// distinct affordances rather than one repeated tile. The token name is kept
/// alongside the resolved colour so the code sample can quote it.
List<_Action> _actions(BuildContext context) {
  final raw = context.palette.raw;
  return [
    (
      label: 'Send',
      icon: 'sendSolid',
      value: GtIcons.sendSolid,
      token: 'blue500',
      color: raw.blue500,
    ),
    (
      label: 'Transfer',
      icon: 'transfer',
      value: GtIcons.transfer,
      token: 'purple500',
      color: raw.purple500,
    ),
    (
      label: 'Wallet',
      icon: 'walletAlt',
      value: GtIcons.walletAlt,
      token: 'teal500',
      color: raw.teal500,
    ),
    (
      label: 'Airtime',
      icon: 'airtime',
      value: GtIcons.airtime,
      token: 'orange500',
      color: raw.orange500,
    ),
    (
      label: 'Bills',
      icon: 'landBill',
      value: GtIcons.landBill,
      token: 'pink500',
      color: raw.pink500,
    ),
    (
      label: 'Cards',
      icon: 'card',
      value: GtIcons.card,
      token: 'green500',
      color: raw.green500,
    ),
    (
      label: 'Save',
      icon: 'wallet',
      value: GtIcons.wallet,
      token: 'red500',
      color: raw.red500,
    ),
    (
      label: 'More',
      icon: 'plus',
      value: GtIcons.plus,
      token: 'yellow500',
      color: raw.yellow500,
    ),
  ];
}

@widgetbook.UseCase(name: 'GtActionButtonBar', type: GtActionButtonBar)
Widget playgroundGtActionButtonBarUseCase(BuildContext context) {
  final catalogue = _actions(context);
  final count = context.knobs.int.slider(
    label: 'Button count',
    initialValue: 4,
    min: 1,
    max: catalogue.length,
    divisions: catalogue.length - 1,
  );
  final showLabels = context.knobs.boolean(
    label: 'Show labels',
    initialValue: true,
  );
  final size = context.knobs.double.slider(
    label: 'Button size',
    initialValue: 56,
    min: GtActionButton.minTapTargetSize,
    max: 80,
    divisions: 9,
  );

  final actions = catalogue.take(count).toList();

  return GtWidgetDocPage(
    title: 'GtActionButtonBar',
    description:
        'A horizontal strip of GtActionButtons — the quick-action row under a '
        'balance card. The bar measures its own box: while the tiles fit within '
        '80% of that width it spreads them edge to edge with spaceBetween, and '
        'past that it becomes a horizontally scrolling strip. Narrow the '
        'Viewport addon to a phone frame, or raise the button count, to cross '
        'the threshold.',
    code:
        '''
GtActionButtonBar(
  buttons: [
${actions.map((a) => '''    GtActionButton(
      icon: GtIcons.${a.icon},
      label: ${showLabels ? '"${a.label}"' : 'null'},
      size: $size,
      backgroundColor: context.palette.raw.${a.token},
      iconColor: context.palette.staticColors.white,
      onPressed: () {},
    ),''').join('\n')}
  ],
)''',
    accessibilityNotes: const [
      'Each GtActionButton carries its own GtTapTarget, so the 44x44 minimum '
          'holds regardless of the button size chosen here.',
      'With labels hidden the buttons are icon-only — give each one an '
          'accessible name through the surrounding semantics.',
      'Captions are capped at a single line, so check the bar at larger text '
          'scales with the Accessibility addon.',
      'The tile colours here are illustrative; verify icon contrast against '
          'each background before reusing this palette in product.',
    ],
    child: GtCard(
      padding: context.insets.allDp(16.px),
      variant: GtCardVariant.normal,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Mirrors the estimate GtActionButtonBar makes in build(), against
          // the same box the bar itself is handed.
          final scrolling = size * actions.length > constraints.maxWidth * .8;

          return Column(
            crossAxisAlignment: .stretch,
            children: [
              GtText(
                '${scrolling ? 'Scrolling' : 'Fitted'} layout · '
                '${actions.length} buttons · '
                '${constraints.maxWidth.toStringAsFixed(0)}px available',
                style: context.textStyles.subHeadS(),
              ),
              const GtGap.yMd(),
              GtActionButtonBar(
                buttons: [
                  for (final action in actions)
                    GtActionButton(
                      icon: action.value,
                      label: showLabels ? action.label : null,
                      size: size,
                      backgroundColor: action.color,
                      iconColor: context.palette.staticColors.white,
                      onPressed: () =>
                          context.showToast('${action.label} tapped'),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
