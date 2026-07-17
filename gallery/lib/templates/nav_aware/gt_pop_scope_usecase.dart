import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPopScope', type: GtPopScope)
Widget playgroundGtPopScopeUseCase(BuildContext context) {
  final canPop = context.knobs.boolean(label: 'Can Pop', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtPopScope',
    description: 'System back-navigation interception tool for preventing accidental page exits.',
    code: '''
GtPopScope(
  canPop: $canPop,
  onPopInvokedWithResult: (didPop, result) {
    if (!didPop) {
      // Handle navigation guarding
    }
  },
  child: const PageContent(),
)

// Root level confirmation:
GtRootPopScope(
  child: const ScaffoldContent(),
)''',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GtCard(
          variant: canPop ? GtCardVariant.success : GtCardVariant.warning,
          child: Padding(
            padding: context.insets.allDp(24.px),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GtIcon(
                  canPop ? GtIcons.checkSolid : GtIcons.triangleWarning,
                  variant: canPop ? GtIconVariant.success : GtIconVariant.warning,
                  size: 32,
                ),
                const GtGap.yMd(),
                GtText(
                  canPop ? 'Can Pop: Enabled' : 'Can Pop: Disabled',
                  style: context.textStyles.h6(),
                ),
                const GtGap.ySm(),
                GtText(
                  canPop
                      ? 'Back navigation works normally'
                      : 'Back navigation triggers onPopInvoked',
                  style: context.textStyles.bodyM(color: context.palette.text.sub),
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
