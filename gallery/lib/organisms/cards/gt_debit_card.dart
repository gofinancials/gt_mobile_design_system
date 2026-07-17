import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDebitCard', type: GtDebitCard)
Widget playgroundGtDebitCardUseCase(BuildContext context) {
  final holderName = context.knobs.string(label: 'Holder Name', initialValue: 'Fola Lobaloba');
  final alignment = context.knobs.object.dropdown<Alignment>(
    label: 'Card Alignment',
    options: [Alignment.center, Alignment.centerLeft, Alignment.centerRight],
    initialOption: Alignment.center,
  );

  return GtWidgetDocPage(
    title: 'GtDebitCard',
    description: 'Displays a virtual debit card with holder name and banking alignment configurations.',
    code: '''
GtDebitCard(
  alignment: Alignment.${alignment.toString().split('.').last},
  holderName: "$holderName",
  onPressed: () {},
)''',
    child: Center(
      child: GtDebitCard(
        alignment: alignment,
        holderName: holderName,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtPaymentCardSelectionCard', type: GtPaymentCardSelectionCard)
Widget playgroundGtPaymentCardSelectionCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Alex Johnson');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Debit Card');
  final feeLabel = context.knobs.string(label: 'Fee Label', initialValue: 'Fee ₦2000');

  return GtWidgetDocPage(
    title: 'GtPaymentCardSelectionCard',
    description: 'A selectable card showing card product details, branding image, and transaction fees.',
    code: '''
GtPaymentCardSelectionCard(
  title: "$title",
  subtitle: "$subtitle",
  feeLabel: "$feeLabel",
  image: AppImageData(GtNetworkImages.debitCard),
)''',
    child: Center(
      child: GtPaymentCardSelectionCard(
        title: title,
        subtitle: subtitle,
        feeLabel: feeLabel,
        image: AppImageData(GtNetworkImages.debitCard),
      ),
    ),
  );
}
