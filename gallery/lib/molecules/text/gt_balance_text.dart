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
  final animateChanges = context.knobs.boolean(
    label: 'Animate changes',
    initialValue: true,
  );

  final codeSnippet =
      '''
GtBalanceText(
  amount: $amount,
  hidden: $hidden,
  currencySymbol: "$currencySymbol",
  animateChanges: $animateChanges,
)''';

  return _GtBalanceTextPlayground(
    amount: amount,
    hidden: hidden,
    currencySymbol: currencySymbol,
    animateChanges: animateChanges,
    codeSnippet: codeSnippet,
  );
}

class _GtBalanceTextPlayground extends GtStatelessWidget {
  final double amount;
  final bool hidden;
  final String currencySymbol;
  final bool animateChanges;
  final String codeSnippet;

  const _GtBalanceTextPlayground({
    required this.amount,
    required this.hidden,
    required this.currencySymbol,
    required this.animateChanges,
    required this.codeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    return GtWidgetDocPage(
      title: "GtBalanceText",
      description:
          "Displays a formatted balance with optional masking and animated value changes.",
      code: codeSnippet,
      child: Center(
        child: GtBalanceText(
          amount: amount,
          hidden: hidden,
          currencySymbol: currencySymbol,
          textAlign: TextAlign.center,
          animateChanges: animateChanges,
        ),
      ),
    );
  }
}
