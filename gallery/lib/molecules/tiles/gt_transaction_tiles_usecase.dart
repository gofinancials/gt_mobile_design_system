import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
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

  return GtWidgetDocPage(
    title: 'GtTransactionListTile',
    description:
        'A list tile tailored for displaying financial transactions (debits/credits) with currency amounts.',
    code:
        '''
GtTransactionListTile(
  "$name",
  subtitle: "$subtitle",
  amount: $amount,
  isDebit: $isDebit,
  onTap: () {},
)''',
    child: GtTransactionListTile(
      name,
      subtitle: subtitle,
      amount: amount,
      isDebit: isDebit,
      onTap: () {},
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
