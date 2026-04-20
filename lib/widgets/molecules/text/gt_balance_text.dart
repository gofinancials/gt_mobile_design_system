import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Default currency label (short **N** for Naira in product copy).
///
/// [gt_mobile_foundation] exposes [AppTextFormatter.formatCurrency] and
/// [num.asCurrency] with a configurable `symbol`; this default matches common
/// in-app Naira shorthand.
const String kGtDefaultCurrencySymbol = 'N';

/// Balance line: **currency** and **amount** use distinct [TextStyle]s in a
/// [Row] with [CrossAxisAlignment.center] so the currency and amount align
/// vertically.
///
/// The numeric portion uses [AppTextFormatter.formatCurrency] with
/// [ignoreSymbol] so the symbol is shown only in the leading cell (with a
/// trailing space).
///
/// When [hidden] is `true`, the amount uses [AppTextFormatter.maskedCurrency]
/// with an empty `symbol` (`*****` per foundation); the currency label stays
/// visible.
///
/// The default currency **N** uses a double strikethrough ([TextDecorationStyle.double]
/// with [TextDecoration.lineThrough]) per design.
class GtBalanceText extends GtStatelessWidget {
  /// Raw balance; when `null`, an em dash is shown instead of the row.
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

  /// Creates a [GtBalanceText].
  const GtBalanceText({
    super.key,
    required this.amount,
    this.currencySymbol = kGtDefaultCurrencySymbol,
    this.hidden = false,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Double strikethrough on the currency glyph (e.g. "N").
    final currencyStyle = context.textStyles.h4(
      color: context.palette.text.strong,
      decoration: TextDecoration.lineThrough,
      decorationStyle: TextDecorationStyle.double,
      decorationColor: context.palette.text.strong,
    );
    final amtStyle = context.textStyles.d3(color: context.palette.text.strong);

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
        : AppTextFormatter.formatCurrency(
            amount,
            symbol: currencySymbol,
            ignoreSymbol: true,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GtText('$currencySymbol ', style: currencyStyle),
        Expanded(
          child: GtText(
            amtDisplay,
            style: amtStyle,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}