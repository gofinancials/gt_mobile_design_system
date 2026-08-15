import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Where a [GtSummaryBody] places its amount.
enum GtSummaryAmountStyle {
  /// Left-aligned at the head of the first card, with the rows beneath it.
  ///
  /// The transfer summaries use this: the amount belongs to the card that
  /// breaks it down into fee and source account.
  leading,

  /// Centred above the cards, with an optional caption beneath.
  ///
  /// The bulk-payment summary uses this: the total belongs to no single card,
  /// so it is lifted out and headlined.
  featured,
}

/// How a [GtSummarySection] arranges each of its rows.
enum GtSummaryTileLayout {
  /// Label on the left, value on the right.
  columns,

  /// Label above the value, both left-aligned.
  ///
  /// Used for values too long or too prominent to sit in a right-hand column,
  /// such as the name of a bulk payment.
  stacked,
}

/// A single label/value row within a [GtSummarySection].
///
/// Distinct from [GtReceiptTileData] in three ways the summary designs require:
/// an image may sit on either side of the value, and the value may be tinted.
/// A receipt tile only ever suffixes its image and never recolours the value.
class GtSummaryTileData extends AppEquatable {
  /// The field name.
  final String label;

  /// The field value.
  ///
  /// Values are presentation-ready strings. Composite values such as
  /// `"Savings • 0123456789"` are formatted by the caller, in keeping with the
  /// rest of the design system.
  final String value;

  /// An optional image rendered immediately before the [value].
  ///
  /// Used for bank logos and recipient avatars, which the designs place to the
  /// left of the name they belong to. Ignored by
  /// [GtSummaryTileLayout.stacked].
  final AppImageData? leading;

  /// An optional image rendered immediately after the [value].
  ///
  /// Used for category glyphs, which the designs place to the right. Ignored by
  /// [GtSummaryTileLayout.stacked].
  final AppImageData? trailing;

  /// An optional colour override for the [value] text.
  ///
  /// Used by category rows, which tint the value to match their glyph.
  final Color? valueColor;

  /// An optional tap handler. When supplied the row becomes interactive.
  final OnPressed? onTap;

  /// Creates a [GtSummaryTileData].
  const GtSummaryTileData({
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
    this.valueColor,
    this.onTap,
  });

  @override
  List<Object?> get props => [label, value, leading, trailing, valueColor];
}

/// One payee within a [GtSummaryPaymentsSection].
class GtSummaryPaymentEntry extends AppEquatable {
  /// The payee's name.
  final String name;

  /// Supporting detail beneath the name, typically an account number.
  final String detail;

  /// The formatted amount, for example `"₦10,000.00"`.
  final String amount;

  /// Optional fee copy beneath the amount, for example `"Fees: ₦50"`.
  final String? fees;

  /// An optional avatar. Falls back to the payee's initials when absent.
  final AppImageData? avatar;

  /// An optional tap handler. When supplied the row becomes interactive.
  final OnPressed? onTap;

  /// Creates a [GtSummaryPaymentEntry].
  const GtSummaryPaymentEntry({
    required this.name,
    required this.detail,
    required this.amount,
    this.fees,
    this.avatar,
    this.onTap,
  });

  @override
  List<Object?> get props => [name, detail, amount, fees, avatar];
}

/// One card in a [GtSummaryBody].
///
/// Sealed so the body can switch over the kinds exhaustively while callers stay
/// free to order them however a screen needs: the bulk-payment design puts its
/// payee list between two row cards, and the transfer designs use row cards
/// throughout.
sealed class GtSummaryCard extends AppEquatable {
  const GtSummaryCard();
}

/// A card of label/value rows.
class GtSummarySection extends GtSummaryCard {
  /// An optional heading rendered above the rows.
  ///
  /// The summary designs use untitled cards throughout; the slot exists so the
  /// section model stays usable on screens that do group their rows by name.
  final String? title;

  /// How each row is arranged. Defaults to [GtSummaryTileLayout.columns].
  final GtSummaryTileLayout layout;

  /// The rows in this section.
  ///
  /// Must contain at least one entry. This is asserted by [GtSummaryBody] at
  /// build time rather than here, because `List.length` is not const-evaluable
  /// and asserting on it would prevent callers from declaring sections `const`.
  final List<GtSummaryTileData> tiles;

  /// Creates a [GtSummarySection].
  const GtSummarySection({
    required this.tiles,
    this.title,
    this.layout = .columns,
  });

  @override
  List<Object?> get props => [title, layout, tiles];
}

/// A card listing the payees of a bulk payment.
class GtSummaryPaymentsSection extends GtSummaryCard {
  /// The heading rendered above the entries, for example `"Payments"`.
  final String title;

  /// The payees.
  ///
  /// Must contain at least one entry, asserted by [GtSummaryBody] at build time
  /// for the reason given on [GtSummarySection.tiles].
  final List<GtSummaryPaymentEntry> entries;

  /// Whether the entry count is rendered beside the [title]. Defaults to true.
  final bool showCount;

  /// Creates a [GtSummaryPaymentsSection].
  const GtSummaryPaymentsSection({
    required this.title,
    required this.entries,
    this.showCount = true,
  });

  @override
  List<Object?> get props => [title, entries, showCount];
}

/// A card surfacing recent transfer success rates.
///
/// Reuses [GtSuccessRateData] so a screen can hand the same entries to this
/// inline card and to the full [GtSuccessRateBody] sheet behind [onAction].
class GtSummaryRatesSection extends GtSummaryCard {
  /// Supporting copy rendered above the rates, for example
  /// `"Bank Transfer success rates in the last 30 minutes"`.
  final String description;

  /// The institutions and their rates, typically just the recipient's bank.
  final List<GtSuccessRateData> rates;

  /// An optional label for the navigation row beneath the rates.
  ///
  /// The row is rendered only when both this and [onAction] are supplied.
  final String? actionLabel;

  /// An optional handler for the navigation row beneath the rates.
  final OnPressed? onAction;

  /// Creates a [GtSummaryRatesSection].
  const GtSummaryRatesSection({
    required this.description,
    required this.rates,
    this.actionLabel,
    this.onAction,
  });

  /// Whether the navigation row should be rendered.
  bool get hasAction => actionLabel.hasValue && onAction != null;

  @override
  List<Object?> get props => [description, rates, actionLabel];
}
