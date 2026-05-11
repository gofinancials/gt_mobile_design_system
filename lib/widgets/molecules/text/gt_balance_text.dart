import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Default currency label (short **N** for Naira in product copy).
///
/// [gt_mobile_foundation] exposes [AppTextFormatter.formatCurrency] and
/// [num.asCurrency] with a configurable `symbol`; this default matches common
/// in-app Naira shorthand.

/// Balance line displaying a currency symbol and an amount with distinct styles.
///
/// The numeric portion uses [AppTextFormatter.formatCurrency] with
/// `ignoreSymbol: true` so the symbol can be styled separately.
///
/// When [hidden] is `true`, the amount is replaced by a masked representation
/// (e.g., `*****`) while the currency label remains visible.
///
/// For Naira, the symbol "N" is rendered with a double strikethrough decoration
/// per the design system's specifications.
///
/// {@category molecules}
/// {@category text}
class GtBalanceText extends GtStatelessWidget {
  /// Raw balance; when `null`, an em dash is shown instead of the balance line.
  final num? amount;

  /// Currency symbol passed through to [AppTextFormatter.formatCurrency].
  ///
  /// Defaults to [kGtDefaultCurrencySymbol].
  final String currencySymbol;

  /// When `true`, the formatted amount is replaced by [AppTextFormatter.maskedCurrency].
  final bool hidden;

  /// Horizontal alignment of the whole line.
  final TextAlign textAlign;

  /// Maximum lines for the amount [GtText].
  final int? maxLines;

  /// Returns `true` if the [currencySymbol] represents Naira.
  bool get isNaira {
    bool isNaira = currencySymbol == AppStrings.naira;
    bool isN = currencySymbol.equals("N");
    return isNaira || isN;
  }

  /// The normalized currency symbol to display.
  ///
  /// Forces "N" for Naira symbols to ensure consistent styling.
  String get computedSymbol => switch (isNaira) {
    true => "N",
    false => currencySymbol,
  };

  /// Creates a [GtBalanceText].
  const GtBalanceText({
    super.key,
    required this.amount,
    this.currencySymbol = AppStrings.naira,
    this.hidden = false,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Double strikethrough on the currency glyph (e.g. "N").
    final currencyStyle = context.textStyles.h4(
      color: context.palette.text.strong,
      decoration: isNaira ? TextDecoration.lineThrough : null,
      decorationStyle: isNaira ? TextDecorationStyle.double : null,
    );
    final amtStyle = switch (context.isAndroid) {
      true => context.textStyles.h2(),
      _ => context.textStyles.h3(),
    };

    if (amount == null) {
      return GtText(
        '—',
        style: amtStyle,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    final String amtDisplay = hidden
        ? AppTextFormatter.maskedCurrency(amount, symbol: '')
        : AppTextFormatter.formatCurrency(amount, ignoreSymbol: true);

    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: GtText('$computedSymbol ', style: currencyStyle),
            alignment: .middle,
          ),
          TextSpan(text: amtDisplay),
        ],
      ),
      textAlign: textAlign,
      style: amtStyle,
    );
  }
}
