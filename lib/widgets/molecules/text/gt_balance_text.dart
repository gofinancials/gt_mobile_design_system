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

  /// A semantic label to use when the balance is hidden.
  final String? hiddenSemanticsLabel;

  /// An overriding semantic label to use when the balance is visible.
  final String? semanticsLabel;

  /// Whether visible amount changes use an odometer-style transition.
  ///
  /// Masked balances remain static so motion cannot reveal value changes.
  final bool animateChanges;

  /// Duration of the amount change animation.
  final Duration animationDuration;

  /// Curve of the amount change animation.
  final Curve animationCurve;

  /// Optional text style for the currency symbol.
  final TextStyle? currencyStyle;

  /// Optional text style for the amount.
  final TextStyle? amountStyle;

  final OnPressed? onVisibilityIconTap;

  /// Creates a [GtBalanceText].
  const GtBalanceText({
    super.key,
    required this.amount,
    this.currencySymbol = AppStrings.naira,
    this.hidden = false,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
    this.hiddenSemanticsLabel,
    this.semanticsLabel,
    this.animateChanges = false,
    this.animationDuration = GtMotion.normal,
    this.animationCurve = GtSpringCurves.bouncy,
    this.currencyStyle,
    this.amountStyle,
    this.onVisibilityIconTap,
  });

  String get amtDisplay {
    if (hidden) return "********";
    return AppTextFormatter.formatCurrency(amount, symbol: '');
  }

  String get semanticLabel {
    if (hidden) {
      return hiddenSemanticsLabel ?? 'Balance is hidden';
    }
    return semanticsLabel ?? 'Balance is $amtDisplay $currencySymbol';
  }

  IconData get _viibilityIcon {
    if (!hidden) {
      return GtIcons.eyeClosed;
    }
    return GtIcons.eyeOpen;
  }

  @override
  Widget build(BuildContext context) {
    final symbolStyle = currencyStyle ?? context.textStyles.title3();
    final amtStyle = amountStyle ?? context.textStyles.h3();

    if (amount == null) {
      return GtText(
        '—',
        style: amtStyle,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    final trailing = WidgetSpan(
      alignment: .middle,
      child: GtAnimatedSwitcher(
        child: GtIcon(
          _viibilityIcon,
          key: ValueKey(hidden),
          size: context.dp(16.px),
          variant: .sub,
        ),
      ),
    );

    Widget child = Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: .middle,
            child: GtText('$currencySymbol ', style: symbolStyle),
          ),
          TextSpan(text: amtDisplay),
          const WidgetSpan(child: GtGap.hSm()),
          trailing,
        ],
      ),
      textAlign: textAlign,
      style: amtStyle,
      maxLines: maxLines,
    );

    if (animateChanges && !hidden) {
      child = _GtAnimatedBalanceText(
        amount: amount!,
        computedSymbol: currencySymbol,
        currencyStyle: symbolStyle,
        amountStyle: amtStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        duration: animationDuration,
        curve: animationCurve,
        trailing: trailing,
      );
    }

    return GtTapTarget(
      child: GtInkWell(
        onTap: onVisibilityIconTap,
        child: FittedBox(
          fit: .scaleDown,
          child: Semantics(label: semanticLabel, child: child),
        ),
      ),
    );
  }
}

class _GtAnimatedBalanceText extends GtStatelessWidget {
  final num amount;
  final String computedSymbol;
  final TextStyle currencyStyle;
  final TextStyle amountStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final Duration duration;
  final Curve curve;
  final InlineSpan trailing;

  const _GtAnimatedBalanceText({
    required this.amount,
    required this.computedSymbol,
    required this.currencyStyle,
    required this.amountStyle,
    required this.textAlign,
    required this.maxLines,
    required this.duration,
    required this.curve,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: .middle,
            child: GtText('$computedSymbol ', style: currencyStyle),
          ),
          WidgetSpan(
            alignment: .middle,
            child: GtAnimatedCounter(
              value: amount,
              formatter: (value) =>
                  AppTextFormatter.formatCurrency(value, ignoreSymbol: true),
              style: amountStyle,
              textAlign: textAlign,
              duration: duration,
              curve: curve,
            ),
          ),
          const WidgetSpan(child: GtGap.hSm()),
          trailing,
        ],
      ),
      textAlign: textAlign,
      style: amountStyle,
      maxLines: maxLines,
    );
  }
}
