import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPaymentSourceCard', type: GtPaymentSourceCard)
Widget playgroundGtPaymentSourceCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Pay from');
  final accountDetail = context.knobs.string(
    label: 'Account Details',
    initialValue: 'SAVINGS • 1020293939',
  );
  final balance = context.knobs.string(
    label: 'Balance Text',
    initialValue: 'Balance ₦200,015.00',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtPaymentSourceCard',
    description:
        'A transaction card displaying account information, branding image, and current balances.',
    code:
        '''
GtPaymentSourceCard(
  title: "$title",
  accountDetail: "$accountDetail",
  balance: "$balance",
  variant: GtCardVariant.${variant.name},
  icon: GtNetworkImage(GtNetworkImages.savings),
)''',
    child: GtPaymentSourceCard(
      title: title,
      accountDetail: accountDetail,
      balance: balance,
      variant: variant,
      icon: GtNetworkImage(GtNetworkImages.savings),
    ),
  );
}
