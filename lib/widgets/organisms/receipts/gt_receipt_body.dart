import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtReceiptBody extends GtStatelessWidget {
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final List<GtReceiptAction> actions;
  final GtReceiptParticipant from;
  final GtReceiptParticipant to;
  final GtReceiptStatusData status;
  final String amount;
  final GtReceiptDetails details;
  final Widget? footer;

  const GtReceiptBody({
    super.key,
    this.controller,
    this.physics,
    this.actions = const [],
    required this.from,
    required this.to,
    required this.amount,
    required this.status,
    required this.details,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = context.insets.allDp(12.px);
    final sectionMargin = context.insets.symmetricDp(horizontal: 16.px);
    final cardRadius = context.borderRadiusXl;

    return ListView(
      physics: physics ?? const ClampingScrollPhysics(),
      controller: controller,
      padding: context.insets.symmetricDp(vertical: 16.px),
      children: [
        Padding(
          padding: sectionMargin,
          child: GtReceiptStatusPill(
            status: status,
            key: const Key('receipt-status-pill'),
          ),
        ),
        const GtGap.yBase(),
        Padding(
          padding: sectionMargin,
          child: FittedBox(
            fit: .scaleDown,
            alignment: .centerLeft,
            child: GtText(
              amount,
              style: context.textStyles.h3(heightPx: 40),
              key: const Key('receipt-amount'),
            ),
          ),
        ),
        if (actions.hasValue) ...[
          const GtGap.yLg(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: sectionMargin,
            child: Row(
              spacing: context.spacingBase,
              children: [
                for (final (index, action) in actions.indexed)
                  _ReceiptAction(
                    action: action,
                    key: Key('receipt-action-$index'),
                  ),
              ],
            ),
          ),
          const GtGap.yLg(),
        ] else
          const GtGap.yLg(),
        GtCard(
          key: const Key('receipt-participants'),
          padding: cardPadding,
          margin: sectionMargin,
          borderRadius: cardRadius,
          child: Column(
            spacing: context.spacingLg,
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              _ReceiptParticipant(from, key: const Key('receipt-from')),
              _ReceiptParticipant(
                to,
                key: const Key('receipt-to'),
                isFrom: false,
              ),
            ],
          ),
        ),
        const GtGap.yBase(),
        if (details.message case GtReceiptMessageData message) ...[
          GtCard(
            padding: cardPadding,
            margin: sectionMargin,
            borderRadius: cardRadius,
            child: _ReceiptMessage(
              message,
              key: const Key('recipient-message-tile'),
            ),
          ),
          const GtGap.yBase(),
        ],
        if (details.category case GtReceiptTileData data) ...[
          GtCard(
            padding: cardPadding,
            margin: sectionMargin,
            borderRadius: cardRadius,
            child: _ReceiptCategory(
              data,
              key: const Key('recipient-category-tile'),
            ),
          ),
          const GtGap.yBase(),
        ],
        if (details.tiles.hasValue) ...[
          GtCard(
            padding: cardPadding,
            margin: sectionMargin,
            borderRadius: cardRadius,
            child: Column(
              spacing: context.spacingLg,
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                for (final (index, tile) in details.tiles.indexed)
                  GtReceiptDetailTile(tile, key: Key('recipient-tile-$index')),
              ],
            ),
          ),
          const GtGap.yBase(),
        ],
        ?footer,
        const GtGap.ySection4xl(),
      ],
    );
  }
}

class _ReceiptMessage extends GtStatelessWidget {
  final GtReceiptMessageData message;

  const _ReceiptMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.subHeadXs(color: context.palette.text.sub);
    final subStyle = context.textStyles.subHeadS();
    return Column(
      spacing: context.spacingBase,
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        GtText(message.displayTitle, style: style),
        GtText(message.message, style: message.style ?? subStyle),
      ],
    );
  }
}

class _ReceiptCategory extends GtStatelessWidget {
  final GtReceiptTileData data;

  const _ReceiptCategory(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.dp(36.px);
    final image = switch (data.image) {
      AppImageData img => GtImage(
        image: img,
        width: size,
        height: size,
        isDecorative: true,
      ),
      _ => null,
    };
    final child = GtDoubleColumnListTile(
      data.label,
      value: data.value,
      valueSuffix: image,
    );

    if (data.onTap != null) {
      return GtInkWell(
        role: .button,
        onTap: data.onTap,
        borderRadius: context.borderRadiusSm,
        child: child,
      );
    }
    return child;
  }
}

class _ReceiptAction extends GtStatelessWidget {
  final GtReceiptAction action;

  const _ReceiptAction({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return GtRaisedButton(
      onPressed: action.onTap,
      text: action.label,
      variant: action.style.variant,
      alignment: .center,
      size: .small,
      leading: action.icon,
      contentPadding: context.insets.symmetricDp(horizontal: 12.px),
      textColor: action.textColor(context.palette),
      color: action.color(context.palette),
    );
  }
}

class _ReceiptParticipant extends GtStatelessWidget {
  final GtReceiptParticipant data;
  final bool isFrom;

  const _ReceiptParticipant(this.data, {super.key, this.isFrom = true});

  @override
  Widget build(BuildContext context) {
    final defaultLabel = isFrom ? 'from'.ctr() : 'to'.ctr();
    final imageSize = context.dp(36.px);

    final tag = data.tag != null
        ? GtImage(image: data.tag!, isDecorative: true)
        : null;

    Widget child = GtTransactionParticipantListTile(
      data.title.upper,
      titleStyle: context.textStyles.button2s(heightPx: 16),
      superscript: data.label ?? defaultLabel,
      leading: switch (data.imageType) {
        .image => GtImage(
          image: data.image,
          width: imageSize,
          height: imageSize,
          isDecorative: true,
        ),
        _ => GtAvatar(
          avatar: data.image,
          size: imageSize,
          initials: data.title.initials,
          tag: tag,
        ),
      },
      subtitle: data.subtitle,
      crossAxisAlignment: .center,
      subStyle: context.textStyles.subHead4xs(color: context.palette.text.soft),
      superscriptStyle: context.textStyles.subHead4xs(
        color: context.palette.text.soft,
      ),
      subSpacer: const SizedBox.shrink(),
      maxLines: 1,
    );

    if (data.transactions.hasValue) {
      child = GtExpansionTile(
        leading: child,
        expandIcon: GtIcons.chevronDownOutline,
        collapseIcon: GtIcons.chevronUpOutline,
        iconSize: context.dp(18.px),
        childrenPadding: context.insets.symmetricDp(vertical: 8.px),
        children: [
          for (final (index, transaction) in data.transactions.indexed) ...[
            _ReceiptTransactionItem(
              transaction,
              key: Key('receipt-transaction-$index'),
            ),
            if (index < data.transactions.length - 1) const GtGap.yBase(),
          ],
        ],
      );
    }

    return child;
  }
}

class _ReceiptTransactionItem extends GtStatelessWidget {
  final GtReceiptTransaction transaction;

  const _ReceiptTransactionItem(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    final tag = transaction.tag != null
        ? GtImage(image: transaction.tag!, isDecorative: true)
        : null;

    return GtPaymentListTile(
      transaction.title,
      subtitle: transaction.subtitle,
      leading: GtAvatar(
        avatar: transaction.image,
        initials: transaction.title.initials,
        size: context.dp(32.px),
        tag: tag,
      ),
      amount: transaction.value,
    );
  }
}
