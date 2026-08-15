import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The scrollable content of a pre-transaction summary screen.
///
/// Presents, from top to bottom:
/// - An optional [title], rendered as a large left-aligned heading. Supply it
///   only for the headline layout, where the app bar carries nothing but a back
///   chevron; when the app bar carries the title instead, leave it null.
/// - An optional [description] paragraph.
/// - The [amount], placed according to [amountStyle]: either left-aligned at
///   the head of the first card, or centred above the cards with an optional
///   [amountCaption] beneath.
/// - One card per entry in [sections]. The [GtSummaryCard] hierarchy is sealed,
///   so a screen mixes row cards, payee lists and success rates in any order.
///
/// Where [GtConfirmationBody] reports on a transaction that already happened —
/// leading with a status pill and a completion timestamp — this body precedes
/// one. It carries no status, and the caller is expected to pair it with a
/// confirming action, which [GtSummaryScaffold] supplies.
///
/// Amounts, dates and composite values such as `"Savings • 0123456789"` are
/// never formatted here. Callers pass presentation-ready strings, in keeping
/// with the rest of the design system.
///
/// Example usage:
/// ```dart
/// GtSummaryBody(
///   amount: "₦20,000.00",
///   description: "Check the details below before you send.",
///   sections: const [
///     GtSummarySection(
///       tiles: [
///         GtSummaryTileData(label: "Transaction Fee", value: "No Fees"),
///         GtSummaryTileData(label: "From", value: "Savings • 0123456789"),
///       ],
///     ),
///     GtSummarySection(
///       tiles: [
///         GtSummaryTileData(label: "Account Number", value: "0123456789"),
///         GtSummaryTileData(label: "Account Name", value: "KENNETH OSMOSIS"),
///       ],
///     ),
///   ],
/// )
/// ```
class GtSummaryBody extends GtStatelessWidget {
  /// An optional controller for the underlying scroll view.
  ///
  /// Supply one to observe or drive the scroll position, for example to return
  /// to the top after the caller edits a detail further down.
  final ScrollController? controller;

  /// Optional scroll physics. Defaults to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The formatted amount, for example `"₦20,000.00"`.
  ///
  /// Scaled down to fit on a single line rather than wrapped, so a long total
  /// never pushes the rows beneath it out of place.
  final String amount;

  /// Where the [amount] is placed. Defaults to [GtSummaryAmountStyle.leading].
  final GtSummaryAmountStyle amountStyle;

  /// Optional copy beneath a [GtSummaryAmountStyle.featured] amount, for
  /// example `"Bulk payment total"`.
  ///
  /// Ignored by [GtSummaryAmountStyle.leading], which has the first card's rows
  /// directly beneath the amount and no room for a caption.
  final String? amountCaption;

  /// An optional heading rendered above the [description].
  ///
  /// Uppercased. Supply this only for the headline layout; see the class docs.
  final String? title;

  /// Optional supporting copy rendered above the cards.
  final String? description;

  /// The cards rendered beneath the header.
  ///
  /// Must contain at least one card, and no card may be empty. Both are
  /// asserted at build time rather than in the constructor, because
  /// `List.length` is not const-evaluable and asserting on it would prevent
  /// callers from declaring this widget and its cards as `const`.
  final List<GtSummaryCard> sections;

  /// Creates a [GtSummaryBody].
  ///
  /// The [amount] and [sections] parameters are required, and [sections] must
  /// not be empty.
  const GtSummaryBody({
    super.key,
    required this.amount,
    required this.sections,
    this.controller,
    this.physics,
    this.amountStyle = .leading,
    this.amountCaption,
    this.title,
    this.description,
  });

  /// Whether [amount] is rendered above the cards rather than inside the first.
  bool get _isFeatured => amountStyle == GtSummaryAmountStyle.featured;

  @override
  Widget build(BuildContext context) {
    assert(sections.hasValue, 'GtSummaryBody requires at least one card');
    assert(sections.every(_isPopulated), 'Every summary card requires content');

    return ListView(
      physics: physics ?? const ClampingScrollPhysics(),
      controller: controller,
      padding: context.insets.allDp(16.px),
      children: [
        if (title case String heading when heading.hasValue) ...[
          GtText(
            heading.upper,
            key: const Key('summary-title'),
            style: context.textStyles.h5(),
            maxLines: 1,
          ),
          const GtGap.ySm(),
        ],
        if (description case String copy when copy.hasValue) ...[
          GtText(
            copy,
            key: const Key('summary-description'),
            style: context.textStyles.bodyS(color: context.palette.text.sub),
          ),
          const GtGap.yLg(),
        ],
        if (_isFeatured) ...[
          _SummaryFeaturedAmount(amount: amount, caption: amountCaption),
          const GtGap.ySectionMd(),
        ],
        for (final (index, section) in sections.indexed) ...[
          if (index > 0) const GtGap.yXl(),
          switch (section) {
            GtSummarySection() => _SummarySectionCard(
              section,
              key: Key('summary-section-$index'),
              index: index,
              // Only the first card carries a leading amount; the rest are
              // plain groups of rows.
              amount: index == 0 && !_isFeatured ? amount : null,
            ),
            GtSummaryPaymentsSection() => GtSummaryPaymentsCard(
              section,
              key: Key('summary-section-$index'),
            ),
            GtSummaryRatesSection() => GtSummaryRatesCard(
              section,
              key: Key('summary-section-$index'),
            ),
          },
        ],
        const GtGap.ySectionMd(),
      ],
    );
  }

  /// Whether a card carries at least one row.
  static bool _isPopulated(GtSummaryCard card) {
    return switch (card) {
      GtSummarySection(:final tiles) => tiles.hasValue,
      GtSummaryPaymentsSection(:final entries) => entries.hasValue,
      GtSummaryRatesSection(:final rates) => rates.hasValue,
    };
  }
}

/// The centred amount block used by [GtSummaryAmountStyle.featured].
class _SummaryFeaturedAmount extends GtStatelessWidget {
  final String amount;
  final String? caption;

  const _SummaryFeaturedAmount({required this.amount, this.caption});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      children: [
        FittedBox(
          fit: .scaleDown,
          child: GtText(
            amount,
            key: const Key('summary-amount'),
            style: context.textStyles.h4(),
            textAlign: .center,
          ),
        ),
        if (caption case String copy) ...[
          const GtGap.ySm(),
          GtText(
            copy,
            key: const Key('summary-amount-caption'),
            style: context.textStyles.bodyXs(color: context.palette.text.sub),
            textAlign: .center,
          ),
        ],
      ],
    );
  }
}

/// One card of label/value rows, optionally led by the amount.
class _SummarySectionCard extends GtStatelessWidget {
  final GtSummarySection section;
  final String? amount;
  final int index;

  const _SummarySectionCard(
    this.section, {
    super.key,
    required this.index,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    // Stacked rows carry their own vertical padding, so they need far less
    // breathing room between them than the column rows do.
    final rowGap = switch (section.layout) {
      .columns => const GtGap.ySectionLg(),
      .stacked => const GtGap.yMd(),
    };

    return GtSummaryCardShell(
      // Gaps are placed one by one rather than through the column's `spacing`,
      // because the amount and the heading hug what follows them (16dp) while
      // the rows sit further apart from each other.
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          if (amount case String value) ...[
            FittedBox(
              fit: .scaleDown,
              alignment: .centerLeft,
              child: GtText(
                value,
                key: const Key('summary-amount'),
                style: context.textStyles.h4(),
              ),
            ),
            const GtGap.yXl(),
          ],
          if (section.title case String heading) ...[
            GtSectionHeader(heading),
            const GtGap.yXl(),
          ],
          for (final (position, tile) in section.tiles.indexed) ...[
            if (position > 0) rowGap,
            GtSummaryTile(
              tile,
              layout: section.layout,
              key: Key('summary-section-$index-tile-$position'),
            ),
          ],
        ],
      ),
    );
  }
}
