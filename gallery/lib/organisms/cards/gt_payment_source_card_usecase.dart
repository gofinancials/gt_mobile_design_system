import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPaymentSourceCard', type: GtPaymentSourceCard)
Widget playgroundGtPaymentSourceCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtPaymentSourceCard',
    description: 'Documentation for GtPaymentSourceCard',
    code: '''
GtPaymentSourceCard(
  title: "Sterling Bank",
  balance: "N 500,000.00",
  accountDetail: "0123456789",
  icon: GtIcon(GtIcons.bank),
  onTap: () {},
)
''',
    child: GtPaymentSourceCard(
      title: "Sterling Bank",
      balance: "N 500,000.00",
      accountDetail: "0123456789",
      icon: const GtIcon(GtIcons.bankCard),
      onTap: () {},
    ),
  );
}
