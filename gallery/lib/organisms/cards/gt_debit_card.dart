import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtDebitCard', type: GtDebitCard)
Widget playgroundGtDebitCardUseCase(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Fola Lobaloba',
  );
  final type = context.knobs.object.dropdown(
    label: 'Card Type',
    options: GtDebitCardType.values,
    initialOption: GtDebitCardType.classic,
    labelBuilder: (v) => v.name.capitalise(),
  );
  final issuer = context.knobs.object.dropdown(
    label: 'Card Issuer',
    options: GtDebitCardIssuer.values,
    initialOption: GtDebitCardIssuer.mastercard,
    labelBuilder: (v) => v.name.capitalise(),
  );
  final dimension = context.knobs.object.dropdown(
    label: 'Dimension',
    options: GtDebitCardDimension.values,
    initialOption: GtDebitCardDimension.regular,
    labelBuilder: (v) => v.name.capitalise(),
  );
  final isFrozen = context.knobs.boolean(
    label: 'Is Frozen',
    initialValue: false,
  );
  final alignment = context.knobs.object.dropdown<Alignment>(
    label: 'Card Alignment',
    options: [Alignment.center, Alignment.centerLeft, Alignment.centerRight],
    initialOption: Alignment.center,
    labelBuilder: (v) => v.toString().split('.').last,
  );

  return GtWidgetDocPage(
    title: 'GtDebitCard',
    description:
        'Displays physical and virtual debit cards with multi-tier styling (Classic, Business, Prime, World, Virtual, Kid), issuer branding, dimension presets (Regular vs Compact), and frozen overlay states.',
    code:
        '''
GtDebitCard(
  label: "$label",
  type: GtDebitCardType.${type.name},
  issuer: GtDebitCardIssuer.${issuer.name},
  dimension: GtDebitCardDimension.${dimension.name},
  isFrozen: $isFrozen,
  alignment: Alignment.${alignment.toString().split('.').last},
  onPressed: () {},
)''',
    child: Center(
      child: GtDebitCard(
        label: label,
        type: type,
        issuer: issuer,
        dimension: dimension,
        isFrozen: isFrozen,
        alignment: alignment,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'GtPaymentCardSelectionCard',
  type: GtPaymentCardSelectionCard,
)
Widget playgroundGtPaymentCardSelectionCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Alex Johnson',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Debit Card',
  );
  final feeLabel = context.knobs.string(
    label: 'Fee Label',
    initialValue: 'Fee ₦2000',
  );

  return GtWidgetDocPage(
    title: 'GtPaymentCardSelectionCard',
    description:
        'A selectable card showing card product details, branding image, and transaction fees.',
    code:
        '''
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
