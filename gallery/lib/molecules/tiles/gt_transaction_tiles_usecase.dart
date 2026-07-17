import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTransactionTiles', type: GtTransactionListTile)
Widget gtTransactionTilesUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Transaction Tiles",
    description: "List tiles designed for displaying transaction details.",
    code: '''
GtTransactionListTile(
  'Netflix Subscription',
  subtitle: 'Oct 24, 2023 - 10:30 AM',
  amount: 4500.0,
  isDebit: true,
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtTransactionListTile"),
        GtTransactionListTile(
          context.knobs.string(label: 'Transaction Name', initialValue: 'Netflix Subscription'),
          subtitle: context.knobs.string(label: 'Transaction Date', initialValue: 'Oct 24, 2023 - 10:30 AM'),
          amount: 4500.0,
          isDebit: context.knobs.boolean(label: 'Is Debit', initialValue: true),
        ),
        const GtGap.yLg(),
        
        GalleryPageSectionHeader(title: "GtTransactionParticipantListTile"),
        GtTransactionParticipantListTile(
          context.knobs.string(label: 'Participant Name', initialValue: 'Jane Doe'),
          subtitle: context.knobs.string(label: 'Bank Details', initialValue: 'GTBank - 0123456789'),
          superscript: 'TO',
          leading: GtAvatar(initials: 'JD'),
        ),
      ],
    ),
  );
}
