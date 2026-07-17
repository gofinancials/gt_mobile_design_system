import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive Preview',
  type: GtPopScope,
)
Widget playgroundGtPopScopeUseCase(BuildContext context) {
  final canPop = context.knobs.boolean(label: 'canPop', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtPopScope',
    description:
        'Intercept back navigation. When canPop is false, the back gesture fires onPopRequest instead.',
    child: Column(
      mainAxisSize: .min,
      children: [
        GtCard(
          variant: canPop ? .success : .warning,
          child: Padding(
            padding: context.insets.allDp(24.px),
            child: Column(
              mainAxisSize: .min,
              children: [
                GtIcon(
                  canPop ? GtIcons.checkSolid : GtIcons.triangleWarning,
                  variant:               canPop ? .success : .warning,
                  size: 32,
                ),
                const GtGap.yMd(),
                GtText(
                  canPop ? 'Can Pop: Enabled' : 'Can Pop: Disabled',
                  style: context.textStyles.h4(),
                ),
                const GtGap.ySm(),
                GtText(
                  canPop
                      ? 'Back navigation works normally'
                      : 'Back navigation triggers onPopRequest',
                  style: context.textStyles.bodyM(
                    color: context.palette.text.sub,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const GtGap.yMd(),
        const GtGap.yLg(),
        GtText(
          'GtRootPopScope',
          style: context.textStyles.subHeadS(),
        ),
        const GtGap.ySm(),
        GtCard(
          variant: .primary,
          child: Padding(
            padding: context.insets.allDp(24.px),
            child: Column(
              mainAxisSize: .min,
              children: [
                GtIcon(GtIcons.circleInfo, variant: .featured, size: 32),
                const GtGap.yMd(),
                GtText(
                  'Auto-shows confirmation dialog on root back press',
                  style: context.textStyles.h4(),
                ),
                const GtGap.ySm(),
                GtText(
                  'Wrap your root scaffold with GtRootPopScope to automatically intercept and confirm back-navigation at the app root.',
                  style: context.textStyles.bodyM(
                    color: context.palette.text.sub,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
