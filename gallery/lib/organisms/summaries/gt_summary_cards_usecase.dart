import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtSummaryRatesCard', type: GtSummaryRatesCard)
Widget playgroundGtSummaryRatesCardUseCase(BuildContext context) {
  return const _SummaryRatesCardPreview();
}

@widgetbook.UseCase(name: 'GtSummaryPaymentsCard', type: GtSummaryPaymentsCard)
Widget playgroundGtSummaryPaymentsCardUseCase(BuildContext context) {
  return const _SummaryPaymentsCardPreview();
}

@widgetbook.UseCase(name: 'GtSummaryTile', type: GtSummaryTile)
Widget playgroundGtSummaryTileUseCase(BuildContext context) {
  return const _SummaryTilePreview();
}

const _bankLogo = AppImageData(GtVectors.logo);
const _avatar = AppImageData(GtAssetImages.avatar);
const _categoryGlyph = AppImageData(GtNetworkImages.transfer);

const _payees = [
  (name: "Basit Samad", detail: "0123456789", fees: "Fees: ₦0"),
  (name: "Funmilola Malik", detail: "0123456789", fees: "Fees: ₦50"),
  (name: "Kenneth Osmosis", detail: "3011456789", fees: "Fees: ₦50"),
];

/// The success-rate card, as it appears at the foot of a transfer summary.
class _SummaryRatesCardPreview extends StatelessWidget {
  const _SummaryRatesCardPreview();

  @override
  Widget build(BuildContext context) {
    final description = context.knobs.string(
      label: 'Description',
      initialValue: 'Bank Transfer success rates in the last 30 minutes',
    );
    final bank = context.knobs.string(
      label: 'Bank Name',
      initialValue: 'Sterling Bank',
    );
    final rate = context.knobs.double.slider(
      label: 'Success Rate (0.0 - 1.0)',
      initialValue: .98,
      min: 0,
      max: 1,
    );
    final showLogo = context.knobs.boolean(
      label: 'Show Logo',
      initialValue: true,
    );
    final showAction = context.knobs.boolean(
      label: 'Show Action Row',
      initialValue: true,
    );
    final actionLabel = context.knobs.string(
      label: 'Action Label',
      initialValue: 'See all bank transfer rates',
    );

    return GtWidgetDocPage(
      title: 'GtSummaryRatesCard',
      description:
          'Surfaces the recipient bank\'s recent success rate at the point of '
          'decision, so a sender can reconsider before confirming rather than '
          'after a transfer stalls. Entries are GtSuccessRateData, the same '
          'type GtSuccessRateBody consumes, so the action typically opens the '
          'full sheet over the very same list. The dashed divider and action '
          'row appear only when both a label and a handler are supplied — a '
          'label alone would render a dead row.',
      code:
          '''
GtSummaryRatesCard(
  GtSummaryRatesSection(
    description: "$description",
    rates: const [
      GtSuccessRateData(
        name: "$bank",
        rate: $rate,
        ${showLogo ? 'logo: AppImageData(GtVectors.logo),' : ''}
      ),
    ],
    ${showAction ? 'actionLabel: "$actionLabel",\n    onAction: () => openAllRates(),' : ''}
  ),
)''',
      child: GtSummaryRatesCard(
        GtSummaryRatesSection(
          description: description,
          rates: [
            GtSuccessRateData(
              name: bank,
              rate: rate,
              logo: showLogo ? _bankLogo : null,
            ),
          ],
          actionLabel: showAction ? actionLabel : null,
          onAction: showAction
              ? () => GtToast.of(context).show("Opening all transfer rates")
              : null,
        ),
      ),
    );
  }
}

/// The payee card of a bulk-payment summary.
class _SummaryPaymentsCardPreview extends StatelessWidget {
  const _SummaryPaymentsCardPreview();

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.string(
      label: 'Title',
      initialValue: 'Payments',
    );
    final count = context.knobs.object.dropdown<int>(
      label: 'Payees',
      options: const [1, 2, 3],
      initialOption: 3,
      labelBuilder: (value) => '$value',
    );
    final showCount = context.knobs.boolean(
      label: 'Show Count',
      initialValue: true,
    );
    final showFees = context.knobs.boolean(
      label: 'Show Fees',
      initialValue: true,
    );
    final showAvatars = context.knobs.boolean(
      label: 'Show Avatars',
      initialValue: true,
    );
    final interactive = context.knobs.boolean(
      label: 'Interactive Rows',
      initialValue: false,
    );

    final entries = _payees
        .take(count)
        .mapList(
          (payee) => GtSummaryPaymentEntry(
            name: payee.name,
            detail: payee.detail,
            amount: "₦10,000.00",
            fees: showFees ? payee.fees : null,
            avatar: showAvatars ? _avatar : null,
            onTap: interactive
                ? () => GtToast.of(context).show("${payee.name} tapped")
                : null,
          ),
        );

    return GtWidgetDocPage(
      title: 'GtSummaryPaymentsCard',
      description:
          'Lists the payees of a bulk payment, headed by the title and — the '
          'one figure a sender checks before releasing a batch — the number of '
          'payees. Each row is a GtPaymentListTile: avatar, name, account '
          'number, and the amount with its fee beneath. Entries without an '
          'avatar fall back to the payee\'s initials.',
      code:
          '''
GtSummaryPaymentsCard(
  GtSummaryPaymentsSection(
    title: "$title",
    showCount: $showCount,
    entries: const [
      GtSummaryPaymentEntry(
        name: "Basit Samad",
        detail: "0123456789",
        amount: "₦10,000.00",
        ${showFees ? 'fees: "Fees: ₦0",' : ''}
      ),
    ],
  ),
)''',
      child: GtSummaryPaymentsCard(
        GtSummaryPaymentsSection(
          title: title,
          showCount: showCount,
          entries: entries,
        ),
      ),
    );
  }
}

/// A single summary row, in both of its layouts.
class _SummaryTilePreview extends StatelessWidget {
  const _SummaryTilePreview();

  @override
  Widget build(BuildContext context) {
    final layout = context.knobs.object.dropdown<GtSummaryTileLayout>(
      label: 'Layout',
      options: GtSummaryTileLayout.values,
      initialOption: GtSummaryTileLayout.columns,
      labelBuilder: (value) => value.name,
    );
    final label = context.knobs.string(
      label: 'Label',
      initialValue: 'Bank Name',
    );
    final value = context.knobs.string(
      label: 'Value',
      initialValue: 'Sterling Bank',
    );
    final showLeading = context.knobs.boolean(
      label: 'Leading Image (columns only)',
      initialValue: true,
    );
    final showTrailing = context.knobs.boolean(
      label: 'Trailing Image (columns only)',
      initialValue: false,
    );
    final tintValue = context.knobs.boolean(
      label: 'Tint Value',
      initialValue: false,
    );
    final interactive = context.knobs.boolean(
      label: 'Interactive',
      initialValue: false,
    );

    final tile = GtSummaryTileData(
      label: label,
      value: value,
      leading: showLeading ? _bankLogo : null,
      trailing: showTrailing ? _categoryGlyph : null,
      valueColor: tintValue ? context.palette.success.base : null,
      onTap: interactive
          ? () => GtToast.of(context).show("$label tapped")
          : null,
    );

    return GtWidgetDocPage(
      title: 'GtSummaryTile',
      description:
          'A single label/value row. The columns layout puts them side by '
          'side with the value emphasised — the inverse of GtReceiptDetailTile, '
          'which emphasises the label because a receipt is read label-first. '
          'Images bracket the value rather than following it, so a bank logo '
          'leads the name it belongs to while a category glyph trails it. The '
          'stacked layout puts the label above the value for values with no '
          'room in a right-hand column, and ignores both image slots.',
      code:
          '''
GtSummaryTile(
  GtSummaryTileData(
    label: "$label",
    value: "$value",
    ${showLeading ? 'leading: AppImageData(GtVectors.logo),' : ''}
    ${showTrailing ? 'trailing: AppImageData(GtNetworkImages.transfer),' : ''}
    ${tintValue ? 'valueColor: context.palette.success.base,' : ''}
  ),
  layout: GtSummaryTileLayout.${layout.name},
)''',
      child: GtSummaryCardShell(child: GtSummaryTile(tile, layout: layout)),
    );
  }
}
