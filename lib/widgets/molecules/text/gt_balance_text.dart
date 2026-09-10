import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A balance line: a currency symbol, the amount, and a visibility toggle,
/// each styled independently.
///
/// The symbol and the amount are separate spans so they can carry different
/// type — [GtTextStyles.title3] and [GtTextStyles.h3] by default — and the
/// amount is formatted with [AppTextFormatter.formatCurrency] without a symbol
/// of its own, leaving [currencySymbol] to render the glyph.
///
/// Tapping anywhere on the line — not just the eye icon — fires
/// [onVisibilityIconTap]; the widget itself holds no state, so the caller flips
/// [hidden] in response. While [hidden] is `true` the amount is replaced by a
/// fixed run of asterisks and any [animateChanges] motion is suppressed, so
/// neither the width nor the movement of the line can leak the value.
///
/// Set [showVisibilityIcon] to `false` for amounts that are not meant to be
/// toggled, such as a transfer amount on a detail screen: the eye icon is
/// dropped and the line becomes inert.
///
/// The line is wrapped in a [FittedBox] set to [BoxFit.scaleDown]: a balance
/// too wide for its box shrinks rather than wrapping or ellipsizing, so give it
/// a bounded width and expect large amounts to render smaller than the
/// nominal type scale.
///
/// A `null` [amount] short-circuits all of this — see that field.
///
/// {@category molecules}
/// {@category text}
class GtBalanceText extends GtStatelessWidget {
  /// The raw balance, formatted for display by [amtDisplay].
  ///
  /// When `null` the widget renders a bare em dash in the amount style and
  /// nothing else: no currency symbol, no visibility icon, no tap target and no
  /// semantics label. Use it for "not loaded yet" or "unavailable", not for a
  /// zero balance — pass `0` for that.
  final num? amount;

  /// The currency glyph rendered ahead of the amount, in [currencyStyle].
  ///
  /// Defaults to [AppStrings.naira] (`₦`). It is drawn as its own text span
  /// rather than being passed to the formatter, which is what allows it to take
  /// a different style from the amount. It is also appended to the default
  /// semantics label.
  final String currencySymbol;

  /// Whether the amount is masked.
  ///
  /// When `true` the digits are replaced by a fixed eight asterisks — the mask
  /// is a constant width, so it reveals nothing about the magnitude of the
  /// balance — while [currencySymbol] stays visible. It also suppresses
  /// [animateChanges] and swaps the trailing icon to [hiddenIcon].
  ///
  /// This is a controlled property: the widget never flips it on its own. Pair
  /// it with [onVisibilityIconTap].
  final bool hidden;

  /// Horizontal alignment of the whole line.
  final TextAlign textAlign;

  /// Maximum lines for the whole balance line, symbol and icon included.
  ///
  /// Defaults to 1. Because the line is scaled down to fit rather than wrapped,
  /// this rarely comes into play; raising it only helps where the box is
  /// narrow enough that shrinking alone would render the balance illegible.
  final int? maxLines;

  /// Overrides the announced label while [hidden] is `true`.
  ///
  /// Defaults to `'Balance is hidden'`. Deliberately says nothing about the
  /// value — a masked balance must not be readable through the accessibility
  /// tree either.
  final String? hiddenSemanticsLabel;

  /// Overrides the announced label while the balance is visible.
  ///
  /// Defaults to the formatted amount followed by [currencySymbol]. Supply this
  /// where the surrounding context does not already name which balance this is
  /// ("Available balance is ₦12,400.00").
  final String? semanticsLabel;

  /// Whether visible amount changes use an odometer-style transition.
  ///
  /// Masked balances remain static so motion cannot reveal value changes.
  final bool animateChanges;

  /// Duration of the amount change animation.
  ///
  /// Only consulted when [animateChanges] is `true` and [hidden] is `false`.
  final Duration animationDuration;

  /// Curve of the amount change animation.
  ///
  /// Defaults to [GtSpringCurves.bouncy]. Only consulted when [animateChanges]
  /// is `true` and [hidden] is `false`.
  final Curve animationCurve;

  /// Overrides the style of [currencySymbol].
  ///
  /// Defaults to [GtTextStyles.title3], a step below the amount.
  final TextStyle? currencyStyle;

  /// Overrides the style of the amount, the mask and the `null` em dash.
  ///
  /// Defaults to [GtTextStyles.h3].
  final TextStyle? amountStyle;

  /// Invoked when the balance line is tapped.
  ///
  /// The whole line is the tap target, not just the icon, so the gesture stays
  /// comfortable at any type scale. Typically flips [hidden] in the caller.
  ///
  /// When `null` the line is inert — but the icon is still drawn, so pass a
  /// callback wherever the eye is shown, or set [showVisibilityIcon] to
  /// `false`. Ignored while [showVisibilityIcon] is `false`.
  final OnPressed? onVisibilityIconTap;

  /// Whether the trailing visibility icon is drawn.
  ///
  /// Defaults to `true`. When `false` the icon and its leading gap are
  /// omitted, and the line is no longer a tap target, so
  /// [onVisibilityIconTap] is ignored. [hidden] still masks the amount.
  final bool showVisibilityIcon;

  /// The trailing icon shown while [hidden] is `true`.
  ///
  /// Defaults to [GtIcons.eyeOpen]. The icon names the action available rather
  /// than the current state: a masked balance offers "reveal", so it shows an
  /// **open** eye. Reads inverted at a glance; it is not.
  final IconData hiddenIcon;

  /// The trailing icon shown while [hidden] is `false`.
  ///
  /// Defaults to [GtIcons.eyeClosed] — the action is "hide". See [hiddenIcon]
  /// for why the pair looks swapped.
  final IconData visibleIcon;

  /// Size of the trailing icon, in logical pixels.
  ///
  /// Defaults to 16dp.
  final double? iconSize;

  /// Colour of the trailing icon.
  ///
  /// Defaults to [GtPalette.icon.sub].
  final Color? iconColor;

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
    this.showVisibilityIcon = true,
    this.hiddenIcon = GtIcons.eyeOpen,
    this.visibleIcon = GtIcons.eyeClosed,
    this.iconSize,
    this.iconColor,
  });

  /// The amount as rendered: eight asterisks while [hidden], otherwise
  /// [amount] formatted without a currency symbol.
  ///
  /// Exposed so callers can measure or reuse the exact string on screen.
  String get amtDisplay {
    if (hidden) return "********";
    return AppTextFormatter.formatCurrency(amount, symbol: '');
  }

  /// The label handed to the accessibility tree.
  ///
  /// Resolves [hiddenSemanticsLabel] or [semanticsLabel] according to [hidden],
  /// falling back to the defaults documented on each.
  String get semanticLabel {
    if (hidden) {
      return hiddenSemanticsLabel ?? 'Balance is hidden';
    }
    return semanticsLabel ?? 'Balance is $amtDisplay $currencySymbol';
  }

  IconData get _viibilityIcon {
    return hidden ? hiddenIcon : visibleIcon;
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

    WidgetSpan? trailing;

    if (showVisibilityIcon) {
      trailing = WidgetSpan(
        alignment: .middle,
        child: GtAnimatedSwitcher(
          child: GtIcon.withColor(
            _viibilityIcon,
            key: ValueKey(hidden),
            size: iconSize ?? context.dp(16.px),
            color: iconColor ?? context.palette.icon.sub,
          ),
        ),
      );
    }

    Widget child = Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: .middle,
            child: GtText('$currencySymbol ', style: symbolStyle),
          ),
          TextSpan(text: amtDisplay),
          if (trailing case WidgetSpan widget) ...[
            const WidgetSpan(child: GtGap.hSm()),
            widget,
          ],
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

    child = FittedBox(
      fit: .scaleDown,
      child: Semantics(label: semanticLabel, child: child),
    );

    if (showVisibilityIcon) {
      child = GtTapTarget(
        child: GtInkWell(onTap: onVisibilityIconTap, child: child),
      );
    }

    return child;
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
  final WidgetSpan? trailing;

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
          if (trailing case WidgetSpan widget) ...[
            const WidgetSpan(child: GtGap.hSm()),
            widget,
          ],
        ],
      ),
      textAlign: textAlign,
      style: amountStyle,
      maxLines: maxLines,
    );
  }
}
