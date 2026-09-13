import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPaymentSourceCard', type: GtPaymentSourceCard)
Widget playgroundGtPaymentSourceCardUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Pay from');
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'SAVINGS • 1020293939',
  );
  final subTitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Balance ₦200,015.00',
  );
  final trailing = context.knobs.object.dropdown<String>(
    label: 'Trailing',
    options: const ['Chevron (default)', 'Check'],
    initialOption: 'Chevron (default)',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );
  final custom = context.knobs.boolean(
    label: 'Custom styling',
    initialValue: false,
  );

  return GtWidgetDocPage(
    title: 'GtPaymentSourceCard',
    description:
        'A transaction card displaying account information, branding image, and current balances.',
    code:
        '''
GtPaymentSourceCard(
  // Set custom to false (or omit these inputs) for the original defaults.
  backgroundColor: $custom ? context.palette.primary.alpha16 : null,
  labelStyle: $custom ? context.textStyles.bodyS() : null,
  titleColor: $custom ? context.palette.primary.dark : null,
  titleStyle: $custom ? context.textStyles.subHeadM() : null,
  subtitleStyle: $custom ? context.textStyles.bodyS() : null,
  verticalSpacing: $custom ? 8 : null,
  balanceSpacing: $custom ? 4 : null,
  label: "$label",
  title: "$title",
  subTitle: "$subTitle",
  leading: GtNetworkImage(GtNetworkImages.savings),
  trailing: ${_getTrailingCode(trailing)},
  variant: GtCardVariant.${variant.name},
  onTap: () {},
)''',
    child: GtPaymentSourceCard(
      backgroundColor: custom ? context.palette.primary.alpha16 : null,
      labelStyle: custom ? context.textStyles.bodyS() : null,
      titleColor: custom ? context.palette.primary.dark : null,
      titleStyle: custom ? context.textStyles.subHeadM() : null,
      subtitleStyle: custom ? context.textStyles.bodyS() : null,
      verticalSpacing: custom ? 8 : null,
      subSpacing: custom ? 4 : null,
      label: label,
      title: title,
      subTitle: subTitle,
      leading: GtNetworkImage(GtNetworkImages.savings),
      trailing: _getTrailing(trailing),
      variant: variant,
      onTap: () {},
    ),
  );
}

Widget? _getTrailing(String preset) {
  return switch (preset) {
    'Check' => GtIcon(GtIcons.checkSolid, size: 16),
    _ => null,
  };
}

String _getTrailingCode(String preset) {
  return switch (preset) {
    'Check' => 'GtIcon(GtIcons.checkSolid, size: 16)',
    _ => 'null',
  };
}
