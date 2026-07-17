import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtAnimatedSwitcher',
  type: GtAnimatedSwitcher,
)
Widget playgroundGtAnimatedSwitcherUseCase(BuildContext context) {
  final showAlt = context.knobs.boolean(label: 'Toggle State', initialValue: false);

  return GtWidgetDocPage(
    title: 'GtAnimatedSwitcher',
    description:
        'Animates between widget states. Toggle the knob above to see the transition.',
    child: Column(
      mainAxisSize: .min,
      children: [
        GtAnimatedSwitcher(
          duration: 400,
          child: showAlt
              ? GtCard(
                  key: const ValueKey('alt'),
                  variant: .success,
                  child: Padding(
              padding: context.insets.allDp(24.px),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        GtIcon(GtIcons.checkSolid, variant: .success, size: 24),
                        const SizedBox(width: 8),
                        GtText('Success!', style: context.textStyles.h4()),
                      ],
                    ),
                  ),
                )
              : GtRaisedButton(
                  key: const ValueKey('default'),
                  text: 'SHOW SUCCESS',
                  onPressed: () {},
                  size: .large,
                ),
        ),
        const GtGap.yMd(),
        GtText(
          'Child widgets must have unique keys for the animation to trigger.',
          style: context.textStyles.bodyS(color: context.palette.text.sub),
        ),
      ],
    ),
  );
}
