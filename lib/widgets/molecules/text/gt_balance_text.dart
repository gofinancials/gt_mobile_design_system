import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Default currency label (short **N** for Naira in product copy).
///
/// [gt_mobile_foundation] exposes [AppTextFormatter.formatCurrency] and
/// [num.asCurrency] with a configurable `symbol`; this default matches common
/// in-app Naira shorthand.

/// Balance line: **currency** and **amount** use distinct [TextStyle]s in a
/// [Wrap] so the amount can flow to the next line on smaller widths.
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

  /// Creates a [GtBalanceText].
  const GtBalanceText({
    super.key,
    required this.amount,
    this.currencySymbol = "N",
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
    );
    final amtStyle = context.textStyles.d3();

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

    return Wrap(
      alignment: _textAlign(textAlign),
      crossAxisAlignment: .start,
      children: [
        GtText('$currencySymbol ', style: currencyStyle),
        GtText(
          amtDisplay,
          style: amtStyle,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

WrapAlignment _textAlign(TextAlign align) {
  switch (align) {
    case TextAlign.center:
      return WrapAlignment.center;
    case TextAlign.end:
    case TextAlign.right:
      return WrapAlignment.end;
    case TextAlign.start:
    case TextAlign.left:
    case TextAlign.justify:
      return WrapAlignment.start;
  }
}
