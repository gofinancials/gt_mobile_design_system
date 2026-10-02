import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _contentPresets = ['Profile card', 'Transactions', 'Form', 'Controls'];

@widgetbook.UseCase(name: 'GtSkeleton', type: GtSkeleton)
Widget playgroundGtSkeletonUseCase(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final preset = context.knobs.object.dropdown<String>(
    label: 'Content',
    options: _contentPresets,
    initialOption: _contentPresets.first,
    labelBuilder: (v) => v,
  );
  final semanticsLabel = context.knobs.string(
    label: 'Semantics Label',
    initialValue: 'Loading',
  );

  return GtWidgetDocPage(
    title: 'GtSkeleton',
    description:
        'Draws any subtree as a shimmering skeleton of itself. Text, icons, images and controls paint bones at their real laid-out size, so tiles, cards and forms become their own skeletons with nothing written by hand.',
    code:
        '''
GtSkeleton(
  enabled: $enabled,
  semanticsLabel: '$semanticsLabel',
  child: ${_getContentCode(preset)},
)''',
    child: Center(
      child: GtSkeleton(
        enabled: enabled,
        semanticsLabel: semanticsLabel,
        child: _getContent(preset, context),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtBone', type: GtBone)
Widget playgroundGtBoneUseCase(BuildContext context) {
  final enabled = context.knobs.boolean(
    label: 'Inside Enabled Skeleton',
    initialValue: true,
  );
  final shape = context.knobs.object.dropdown<BoxShape>(
    label: 'Shape',
    options: BoxShape.values,
    initialOption: BoxShape.rectangle,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtBone',
    description:
        'Paints a shimmering block over its child while an enabled GtSkeleton is above it. Use it to bone a custom widget the atoms do not cover.',
    code:
        '''
GtSkeleton(
  enabled: $enabled,
  child: GtBone(
    shape: BoxShape.${shape.name},
    child: CustomPaint(painter: MyChartPainter(), size: Size.square(96)),
  ),
)''',
    child: Center(
      child: GtSkeleton(
        enabled: enabled,
        child: GtBone(
          shape: shape,
          child: GtSquareBox(
            size: 96,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: context.gradients.avatarGradient,
                shape: shape,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

String _getContentCode(String preset) {
  return switch (preset) {
    'Transactions' => 'Column(children: [GtTransactionListTile(...), ...])',
    'Form' => 'Column(children: [GtTextField(...), GtRaisedButton(...)])',
    'Controls' => 'Wrap(children: [GtSwitch(...), GtCheckBox(...), ...])',
    _ => 'GtCard(child: Row(children: [GtAvatar(...), ...]))',
  };
}

Widget _getContent(String preset, BuildContext context) {
  return switch (preset) {
    'Transactions' => Column(
      mainAxisSize: .min,
      children: [
        for (final (name, amount) in const [
          ('Transfer to Adaeze Okafor', 15500),
          ('Airtime top-up', 2000),
          ('Electricity bill', 8250),
        ])
          GtTransactionListTile(
            name,
            subtitle: '12 Sep, 10:42',
            amount: amount,
            isDebit: true,
            leading: const GtIcon(GtIcons.anchor),
          ),
      ],
    ),
    'Form' => Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        const GtTextField(label: 'Full name', hintText: 'Adaeze Okafor'),
        const GtGap.yMd(),
        const GtTextField(label: 'Email', hintText: 'ada@example.com'),
        const GtGap.yLg(),
        GtRaisedButton(text: 'Continue', onPressed: () {}),
      ],
    ),
    'Controls' => Wrap(
      spacing: context.spacingLg,
      runSpacing: context.spacingLg,
      crossAxisAlignment: .center,
      children: [
        GtSwitch(value: true, onChanged: (_) {}),
        GtCheckBox<bool>(value: true, isActive: true, onChanged: (_) {}),
        GtRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {}),
        const GtStatusPill(text: 'Verified', variant: GtPillVariant.success),
        const GtDots(1, length: 4),
        const GtSizedBox(width: 160, child: GtProgress(value: .6)),
      ],
    ),
    _ => GtCard(
      padding: context.insets.allDp(16.px),
      child: Row(
        children: [
          const GtAvatar(initials: 'AO', size: 48),
          const GtGap.sMd(),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                GtText('Adaeze Okafor', style: context.textStyles.subHeadS()),
                const GtGap.ySm(),
                GtText(
                  'ada@example.com',
                  style: context.textStyles.bodyXs(
                    color: context.palette.text.sub,
                  ),
                ),
              ],
            ),
          ),
          const GtIcon(GtIcons.chevronRight),
        ],
      ),
    ),
  };
}
