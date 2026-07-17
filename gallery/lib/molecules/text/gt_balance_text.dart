import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Balance', type: GtBalanceText)
Widget playgroundGtBalanceTextUseCase(BuildContext context) {
  final amount = context.knobs.double.input(
    label: 'Amount',
    initialValue: 20250499.99,
  );
  final hidden = context.knobs.boolean(
    label: 'Hidden (mask amount)',
    initialValue: false,
  );
  final currencySymbol = context.knobs.string(
    label: 'Currency symbol',
    initialValue: AppStrings.naira,
  );

  final codeSnippet =
      '''
GtBalanceText(
  amount: $amount,
  hidden: $hidden,
  currencySymbol: "$currencySymbol",
)''';

  return GtWidgetDocPage(
    title: "GtBalanceText",
    description:
        "Displays a currency symbol and amount formatted properly, with optional double-strikethrough styling for Naira and amount masking.",
    code: codeSnippet,
    child: Center(
      child: GtBalanceText(
        amount: amount,
        hidden: hidden,
        currencySymbol: currencySymbol,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
