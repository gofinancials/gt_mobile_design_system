import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The scrollable content of a transfer detail screen.
///
/// Presents, from top to bottom:
/// - The [recipient]'s avatar, with an optional bank tag, above their name.
/// - The transfer [amount], rendered by a [GtBalanceText] without its
///   visibility icon: prefixed by [currency] and scaled down to fit on a
///   single line.
/// - An optional, centred row of [actions] such as "Send again" and
///   "View receipt".
/// - A card holding a [GtStatusTracker] in its
///   [GtStatusTrackerVariant.compact] layout, built from [steps].
/// - One card per [GtTransferDetailSection], filled with
///   [GtReceiptDetailTile] rows. Row images sit before the value, and rows
///   carrying an `onInfoTap` show an info icon beside their label.
/// - An optional [footer].
///
/// Of the [recipient], only the `title`, `image`, `tag` and `imageType` are
/// rendered.
///
/// Like [GtReceiptBody], it reserves trailing space for the floating bottom
/// bar of [GtTransferDetailScaffold]. The [amount] is formatted by
/// [GtBalanceText]; timestamps and row values are never formatted here, so
/// callers pass presentation-ready strings for those.
///
/// Example usage:
/// ```dart
/// GtTransferDetailBody(
///   amount: 20000,
///   recipient: const GtReceiptParticipant(
///     title: "Frances Nkatie",
///     image: AppImageData(avatarUrl),
///     imageType: GtReceiptImageType.avatar,
///     tag: AppImageData(bankLogoUrl),
///   ),
///   actions: [
///     GtReceiptAction.primary(
///       label: "Send again",
///       icon: GtIcons.arrowNorthEast,
///       onTap: () => sendAgain(),
///     ),
///   ],
///   steps: const [
///     GtStatusStepData(
///       label: "Processed",
///       state: GtStatusStepState.success,
///       subtitle: "Sep 10, 2025 11:03 AM",
///     ),
///     GtStatusStepData(label: "Sent", state: GtStatusStepState.active),
///     GtStatusStepData(label: "Delivered", state: GtStatusStepState.pending),
///   ],
///   sections: [
///     GtTransferDetailSection(
///       tiles: [
///         GtReceiptTileData(
///           label: "Fees (VAT Incl)",
///           value: "₦25",
///           onInfoTap: () => explainFees(),
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class GtTransferDetailBody extends GtStatelessWidget {
  /// An optional controller for the underlying scroll view.
  ///
  /// Supply the controller handed to you by a draggable sheet builder so the
  /// content and the sheet scroll as one.
  final ScrollController? controller;

  /// Optional scroll physics. Defaults to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The person or business the transfer was sent to.
  final GtReceiptParticipant recipient;

  /// The raw transfer amount, for example `20000`.
  ///
  /// Formatted with comma separators and two decimal places by
  /// [GtBalanceText], so `20000` renders as `20,000.00`.
  final num amount;

  /// The currency glyph drawn ahead of [amount] in a smaller type.
  ///
  /// Defaults to [AppStrings.naira] (`₦`).
  final String currency;

  /// Overrides the label announced for [amount].
  ///
  /// Defaults to the `transferAmountIs` translation, passed the formatted
  /// amount as `amount` and [currency] as `currency`.
  final String? amountSemanticsLabel;

  /// The actions rendered as a centred row beneath the amount.
  ///
  /// When empty, no row is rendered.
  final List<GtReceiptAction> actions;

  /// The ordered progress of the transfer, rendered as a compact
  /// [GtStatusTracker].
  ///
  /// When empty, the status card is omitted.
  final List<GtStatusStepData> steps;

  /// The groups of label/value rows rendered as cards beneath the status card.
  ///
  /// Every section must contain at least one tile. This is asserted at build
  /// time rather than in the constructor so callers can declare this widget
  /// and its sections as `const`.
  final List<GtTransferDetailSection> sections;

  /// An optional widget rendered beneath the final section.
  final Widget? footer;

  /// Creates a [GtTransferDetailBody].
  ///
  /// The [recipient], [amount] and [steps] parameters are required.
  const GtTransferDetailBody({
    super.key,
    this.controller,
    this.physics,
    this.currency = AppStrings.naira,
    this.amountSemanticsLabel,
    this.actions = const [],
    this.sections = const [],
    this.footer,
    required this.recipient,
    required this.amount,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    assert(
      sections.every((section) => section.tiles.hasValue),
      'Every GtTransferDetailSection requires at least one tile',
    );

    final cardRadius = context.borderRadiusXl;

    return ListView(
      physics: physics ?? const ClampingScrollPhysics(),
      controller: controller,
      padding: context.insets.allDp(16.px),
      children: [
        _TransferDetailHeader(
          recipient: recipient,
          amount: amount,
          currency: currency,
          amountSemanticsLabel: amountSemanticsLabel,
        ),
        if (actions.hasValue) ...[
          const GtGap.yLg(),
          Wrap(
            alignment: .center,
            spacing: context.spacingBase,
            runSpacing: context.spacingBase,
            runAlignment: .center,
            children: [
              for (final (index, action) in actions.indexed)
                GtReceiptActionButton(
                  action: action,
                  alignment: null,
                  key: Key('transfer-detail-action-$index'),
                ),
            ],
          ),
        ],
        const GtGap.yLg(),
        if (steps.hasValue) ...[
          GtCard(
            key: const Key('transfer-detail-status'),
            padding: context.insets.allDp(16.px),
            borderRadius: cardRadius,
            child: GtStatusTracker(steps: steps, variant: .compact),
          ),
          const GtGap.yLg(),
        ],
        for (final (index, section) in sections.indexed) ...[
          GtCard(
            key: Key('transfer-detail-section-$index'),
            padding: context.insets.allDp(12.px),
            borderRadius: cardRadius,
            child: Column(
              spacing: context.spacingXl,
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                for (final (position, tile) in section.tiles.indexed)
                  GtReceiptDetailTile(
                    tile,
                    highlightValue: true,
                    imagePosition: .leading,
                    key: Key('transfer-detail-section-$index-tile-$position'),
                  ),
              ],
            ),
          ),
          const GtGap.yLg(),
        ],
        ?footer,
        const GtGap.ySection4xl(),
      ],
    );
  }
}

/// A private widget that renders the head of a [GtTransferDetailBody]: the
/// recipient's avatar and name above the transfer amount.
class _TransferDetailHeader extends GtStatelessWidget {
  /// The recipient whose avatar and name are shown.
  final GtReceiptParticipant recipient;

  /// The raw transfer amount, formatted by [GtBalanceText].
  final num amount;

  /// The currency glyph drawn ahead of [amount].
  final String currency;

  /// Overrides the label announced for [amount]. See [amountLabel].
  final String? amountSemanticsLabel;

  /// Creates a [_TransferDetailHeader].
  const _TransferDetailHeader({
    required this.recipient,
    required this.amount,
    required this.currency,
    this.amountSemanticsLabel,
  });

  /// The label announced for [amount]: [amountSemanticsLabel] when supplied,
  /// otherwise the `transferAmountIs` translation.
  String get amountLabel {
    final display = AppTextFormatter.formatCurrency(amount, symbol: '');
    return amountSemanticsLabel ??
        'transferAmountIs'.tr({'amount': display, 'currency': currency});
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = context.dp(60.24.px);
    final tag = recipient.tag != null
        ? GtImage(image: recipient.tag!, isDecorative: true)
        : null;

    final avatar = switch (recipient.imageType) {
      .image => GtImage(
        image: recipient.image,
        width: imageSize,
        height: imageSize,
        isDecorative: true,
        useDefaultSize: false,
      ),
      _ => GtAvatar(
        avatar: recipient.image,
        size: imageSize,
        initials: recipient.title.initials,
        tag: tag,
        showBorder: true,
      ),
    };

    return Column(
      mainAxisSize: .min,
      spacing: context.spacingBase,
      children: [
        KeyedSubtree(key: const Key('transfer-detail-avatar'), child: avatar),
        Column(
          mainAxisSize: .min,
          spacing: context.spacingSm,
          children: [
            GtText(
              recipient.title,
              style: context.textStyles.subHeadS(),
              textAlign: .center,
              key: const Key('transfer-detail-recipient'),
            ),
            GtBalanceText(
              key: const Key('transfer-detail-amount'),
              amount: amount,
              currencySymbol: currency,
              showVisibilityIcon: false,
              amountStyle: context.textStyles.h3(heightPx: 40),
              semanticsLabel: amountLabel,
            ),
          ],
        ),
      ],
    );
  }
}
