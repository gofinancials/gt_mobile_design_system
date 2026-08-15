import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The scrollable content of a transaction confirmation screen.
///
/// Presents, from top to bottom:
/// - A [GtReceiptStatusPill] with an optional trailing [stamp] image.
/// - The transaction [amount], scaled down to fit on a single line.
/// - The [date] and [time] the transaction was completed.
/// - One card per [GtConfirmationSection], each headed by a [GtSectionHeader]
///   and filled with [GtReceiptDetailTile] rows.
/// - An optional [footer] carrying fine print, a closing note and a trailing
///   image such as a QR code.
///
/// Unlike [GtReceiptBody], which models a fixed sender/recipient/details shape,
/// this body is section-driven: callers supply arbitrary titled groups of
/// label/value rows. It carries no action buttons and expects no bottom
/// navigation bar, so it does not reserve trailing space for one.
///
/// Dates are never formatted here. Callers pass presentation-ready strings, in
/// keeping with the rest of the design system.
///
/// Example usage:
/// ```dart
/// GtConfirmationBody(
///   amount: "20,000.00",
///   date: "September 29, 2025",
///   time: "02:45 PM",
///   status: const GtReceiptStatusData(
///     status: GtReceiptStatus.success,
///     title: "Delivered",
///   ),
///   sections: const [
///     GtConfirmationSection(
///       title: "Account Details",
///       tiles: [
///         GtReceiptTileData(label: "Name", value: "OLOWOFALA ALAO"),
///         GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
///       ],
///     ),
///   ],
///   footer: const GtConfirmationFooter(
///     disclaimer: "Your transfer has been processed successfully...",
///     note: "Please reach out to support for more information.",
///     trailing: AppImageData(GtVectors.qrCode),
///   ),
/// )
/// ```
class GtConfirmationBody extends GtStatelessWidget {
  /// An optional controller for the underlying scroll view.
  ///
  /// Supply the controller handed to you by a draggable sheet builder so the
  /// content and the sheet scroll as one.
  final ScrollController? controller;

  /// Optional scroll physics. Defaults to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The transaction status rendered as the leading pill.
  final GtReceiptStatusData status;

  /// An optional seal or stamp image displayed opposite the status pill.
  final AppImageData? stamp;

  /// The formatted transaction amount, for example `"20,000.00"`.
  final String amount;

  /// The formatted transaction date, for example `"September 29, 2025"`.
  final String date;

  /// The formatted transaction time, for example `"02:45 PM"`.
  final String time;

  /// The titled groups of label/value rows rendered as cards.
  ///
  /// Must contain at least one section, and every section must contain at least
  /// one tile. Both are asserted at build time rather than in the constructor,
  /// because `List.length` is not const-evaluable and asserting on it would
  /// prevent callers from declaring this widget and its sections as `const`.
  final List<GtConfirmationSection> sections;

  /// Optional fine print rendered beneath the final section.
  ///
  /// Typed rather than a free widget slot so legal copy is styled consistently
  /// across every screen that uses this body.
  ///
  /// Retained as a shorthand for the common case of a footer that carries
  /// nothing but a disclaimer. When [footer] is supplied it wins, because a
  /// footer models the same block in full.
  final String? disclaimer;

  /// Optional closing block rendered beneath the final section.
  ///
  /// Carries the fine print, an optional trailing image such as a QR code, and
  /// a short closing note. Typed rather than a free widget slot so the block is
  /// styled consistently across every screen that uses this body.
  ///
  /// When null, a footer is derived from [disclaimer] if one was supplied.
  final GtConfirmationFooter? footer;

  /// Creates a [GtConfirmationBody].
  ///
  /// The [amount], [date], [time], [status] and [sections] parameters are
  /// required, and [sections] must not be empty.
  const GtConfirmationBody({
    super.key,
    this.controller,
    this.physics,
    this.stamp,
    this.disclaimer,
    this.footer,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    assert(
      sections.hasValue,
      'GtConfirmationBody requires at least one section',
    );
    assert(
      sections.every((section) => section.tiles.hasValue),
      'Every GtConfirmationSection requires at least one tile',
    );

    final cardPadding = context.insets.allDp(12.px);
    final cardRadius = context.borderRadiusXl;
    final stampSize = context.dp(32.px);
    final resolvedFooter = switch ((footer, disclaimer)) {
      (GtConfirmationFooter footer, _) => footer,
      (_, String disclaimer) when disclaimer.hasValue => GtConfirmationFooter(
        disclaimer: disclaimer,
      ),
      _ => null,
    };

    return ListView(
      physics: physics ?? const ClampingScrollPhysics(),
      controller: controller,
      padding: context.insets.symmetricDp(vertical: 24.px, horizontal: 16.px),
      children: [
        Row(
          children: [
            GtReceiptStatusPill(
              status: status,
              key: const Key('confirmation-status-pill'),
            ),
            const Spacer(),
            if (stamp case AppImageData image)
              GtImage(
                image: image,
                width: stampSize,
                height: stampSize,
                key: const Key('confirmation-stamp'),
                isDecorative: true,
              ),
          ],
        ),
        const GtGap.yMd(),
        FittedBox(
          fit: .scaleDown,
          alignment: .centerLeft,
          child: GtText(
            amount,
            style: context.textStyles.h3(heightPx: 40),
            key: const Key('confirmation-amount'),
          ),
        ),
        const GtGap.ySm(),
        Text.rich(
          TextSpan(
            text: date,
            children: [
              const WidgetSpan(child: GtGap.hBase()),
              TextSpan(
                text: time,
                style: context.textStyles.body2Xs(
                  color: context.palette.text.soft,
                ),
              ),
            ],
            style: context.textStyles.body2Xs(),
          ),
          key: const Key('confirmation-timestamp'),
        ),
        const GtGap.yLg(),
        for (final (index, section) in sections.indexed) ...[
          GtCard(
            key: Key('confirmation-section-$index'),
            padding: cardPadding,
            borderRadius: cardRadius,
            child: Column(
              spacing: context.spacingLg,
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                GtSectionHeader(section.title),
                for (final (position, tile) in section.tiles.indexed)
                  GtReceiptDetailTile(
                    tile,
                    key: Key('confirmation-section-$index-tile-$position'),
                  ),
              ],
            ),
          ),
          const GtGap.yBase(),
        ],
        if (resolvedFooter case GtConfirmationFooter footer
            when footer.hasContent) ...[
          const GtGap.yLg(),
          _ConfirmationFooter(footer, key: const Key('confirmation-footer')),
        ],
        const GtGap.yLg(),
      ],
    );
  }
}

/// The closing block of a [GtConfirmationBody].
///
/// Lays the [GtConfirmationFooter.disclaimer] out beside
/// [GtConfirmationFooter.trailing] — typically a QR code — and stacks
/// [GtConfirmationFooter.note] beneath the pair. Any of the three may be
/// absent, in which case the remaining content closes up around it.
class _ConfirmationFooter extends GtStatelessWidget {
  final GtConfirmationFooter footer;

  const _ConfirmationFooter(this.footer, {super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.body3Xs(color: context.palette.text.soft);
    final trailingSize = context.dp(36.px);

    final hasFullLeading = footer.disclaimer.hasValue && footer.note.hasValue;

    return Row(
      spacing: context.spacingSectionMd,
      crossAxisAlignment: hasFullLeading ? .start : .center,
      children: [
        if ((footer.disclaimer, footer.note) case (
          String? footer,
          String? note,
        ) when (footer.hasValue || note.hasValue))
          Expanded(
            child: Column(
              spacing: context.spacingLg,
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                if (footer.hasValue)
                  GtText(
                    footer,
                    style: style,
                    key: const Key('confirmation-disclaimer'),
                  ),
                if (note.hasValue)
                  GtText(
                    note,
                    style: context.textStyles.body3Xs(),
                    key: const Key('confirmation-footer-note'),
                  ),
              ],
            ),
          ),
        if (footer.trailing case AppImageData image)
          GtImage(
            image: image,
            width: trailingSize,
            height: trailingSize,
            semanticsLabel: footer.displayTrailingLabel,
            key: const Key('confirmation-footer-trailing'),
          ),
      ],
    );
  }
}
