import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtSelectableCard',
  type: GtSelectableCard,
)
Widget playgroundGtSelectableCardUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: .primary,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtSelectableCard',
    description: 'Card wrapper with selection state and coloured border accent.',
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GtSelectableCard<String>(
                value: 'a',
                selected: true,
                onSelect: (_) {},
                variant: variant,
                child: Padding(
                  padding: context.insets.allDp(24.px),
                  child: Column(
                    children: [
                      GtIcon(GtIcons.gemSparkle, variant: .featured, size: 32),
                      const GtGap.ySm(),
                      GtText('Selected', style: context.textStyles.h4()),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GtSelectableCard<String>(
                value: 'b',
                selected: false,
                onSelect: (_) {},
                variant: variant,
                child: Padding(
                  padding: context.insets.allDp(24.px),
                  child: Column(
                    children: [
                      GtIcon(GtIcons.moneyBillCoin, variant: .sub, size: 32),
                      const GtGap.ySm(),
                      GtText('Unselected', style: context.textStyles.h4()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const GtGap.yMd(),
        GtText(
          'Also see: GtAvatarSelectionCard for avatar-specific selection',
          style: context.textStyles.bodyS(color: context.palette.text.sub),
        ),
      ],
    ),
  );
}
