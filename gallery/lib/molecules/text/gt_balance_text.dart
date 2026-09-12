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
  final sign = context.knobs.stringOrNull(
    label: 'Sign (e.g. +)',
    initialValue: null,
  );
  final animateChanges = context.knobs.boolean(
    label: 'Animate changes',
    initialValue: true,
  );
  final showVisibilityIcon = context.knobs.boolean(
    label: 'Show visibility icon',
    initialValue: true,
  );

  final signLine = sign.hasValue ? '\n  sign: "$sign",' : '';

  final codeSnippet =
      '''
GtBalanceText(
  amount: $amount,
  hidden: $hidden,
  currencySymbol: "$currencySymbol",$signLine
  animateChanges: $animateChanges,
  showVisibilityIcon: $showVisibilityIcon,
)''';

  return _GtBalanceTextPlayground(
    amount: amount,
    hidden: hidden,
    currencySymbol: currencySymbol,
    sign: sign.hasValue ? sign : null,
    animateChanges: animateChanges,
    showVisibilityIcon: showVisibilityIcon,
    codeSnippet: codeSnippet,
  );
}

class _GtBalanceTextPlayground extends GtStatelessWidget {
  final double amount;
  final bool hidden;
  final String currencySymbol;
  final String? sign;
  final bool animateChanges;
  final bool showVisibilityIcon;
  final String codeSnippet;

  const _GtBalanceTextPlayground({
    required this.amount,
    required this.hidden,
    required this.currencySymbol,
    required this.sign,
    required this.animateChanges,
    required this.showVisibilityIcon,
    required this.codeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    return GtWidgetDocPage(
      title: "GtBalanceText",
      description:
          "Displays a formatted balance with optional masking and animated value changes. Turn off the visibility icon for amounts that are not meant to be toggled.",
      code: codeSnippet,
      child: Center(
        child: GtBalanceText(
          amount: amount,
          hidden: hidden,
          currencySymbol: currencySymbol,
          sign: sign,
          textAlign: TextAlign.center,
          animateChanges: animateChanges,
          showVisibilityIcon: showVisibilityIcon,
        ),
      ),
    );
  }
}
