import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTransactionListTile', type: GtTransactionListTile)
Widget playgroundGtTransactionListTileUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Name',
    initialValue: 'Transfer to Alex',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: '21 Jun 2026, 14:32 PM',
  );
  final amount = context.knobs.double.input(
    label: 'Amount',
    initialValue: 5000.0,
  );
  final isDebit = context.knobs.boolean(label: 'Is Debit', initialValue: true);
  final maskAmount = context.knobs.boolean(
    label: 'Mask Amount',
    initialValue: false,
  );
  final currency = context.knobs.string(
    label: 'Currency',
    initialValue: AppStrings.naira,
  );

  return GtWidgetDocPage(
    title: 'GtTransactionListTile',
    description:
        'A list tile tailored for displaying financial transactions (debits/credits) with currency amounts and masking support.',
    code:
        '''
GtTransactionListTile(
  "$name",
  subtitle: "$subtitle",
  amount: $amount,
  isDebit: $isDebit,
  currency: "$currency",
  maskAmount: $maskAmount,
  onTap: () {},
)''',
    child: GtTransactionListTile(
      name,
      subtitle: subtitle,
      amount: amount,
      isDebit: isDebit,
      currency: currency,
      maskAmount: maskAmount,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'GtPaymentListTile', type: GtPaymentListTile)
Widget playgroundGtPaymentListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Electricity Bill Payment',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'IKEDC Prepaid • 450123987',
  );
  final amount = context.knobs.double.input(
    label: 'Amount',
    initialValue: 15000.0,
  );
  final fees = context.knobs.string(
    label: 'Fees / Surcharge',
    initialValue: '+ ₦ 100.00 fee',
  );
  final showFees = context.knobs.boolean(
    label: 'Show Fees',
    initialValue: true,
  );
  final maskAmount = context.knobs.boolean(
    label: 'Mask Amount',
    initialValue: false,
  );
  final currency = context.knobs.string(
    label: 'Currency',
    initialValue: AppStrings.naira,
  );
  final showLeading = context.knobs.boolean(
    label: 'Show Leading Avatar',
    initialValue: true,
  );

  return GtWidgetDocPage(
    title: 'GtPaymentListTile',
    description:
        'A specialized list tile for displaying payment summaries, bill payments, and checkout items with optional fee text and amount formatting.',
    code:
        '''
GtPaymentListTile(
  "$title",
  subtitle: "$subtitle",
  amount: "$amount",
  fees: ${showFees && fees.isNotEmpty ? '"$fees"' : 'null'},
  currency: "$currency",
  maskAmount: $maskAmount,
  leading: ${showLeading ? 'const GtAvatar(avatar: AppImageData(GtNetworkImages.sampleAvatar1), size: 32)' : 'null'},
  onTap: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: .normal,
        child: GtPaymentListTile(
          title,
          subtitle: subtitle,
          amount: "$amount",
          fees: showFees && fees.isNotEmpty ? fees : null,
          currency: currency,
          maskAmount: maskAmount,
          leading: showLeading
              ? const GtAvatar(
                  avatar: AppImageData(GtNetworkImages.sampleAvatar1),
                  size: 32,
                )
              : null,
          onTap: () {
            GtToast.of(context).show("Payment tile tapped: $title");
          },
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtTransactionParticipantListTile',
  type: GtTransactionParticipantListTile,
)
Widget playgroundGtTransactionParticipantListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Alex Lobaloba',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Sterling Bank • 1029384756',
  );
  final superscript = context.knobs.string(
    label: 'Superscript',
    initialValue: 'TO',
  );

  return GtWidgetDocPage(
    title: 'GtTransactionParticipantListTile',
    description:
        'A specialized list tile for displaying transaction participants (senders or receivers).',
    code:
        '''
GtTransactionParticipantListTile(
  "$title",
  subtitle: "$subtitle",
  superscript: "$superscript",
  leading: GtAvatar(initials: "AL"),
  trailing: GtIcon(GtIcons.chevronRight),
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtTransactionParticipantListTile(
          title,
          subtitle: subtitle.isEmpty ? null : subtitle,
          superscript: superscript.isEmpty ? null : superscript,
          leading: const GtAvatar(initials: "AL"),
          trailing: const GtIcon(GtIcons.chevronRight),
        ),
      ),
    ),
  );
}
