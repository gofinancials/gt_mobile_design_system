import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTransferField', type: GtTransferField)
Widget playgroundGtTransferFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtTransferField',
    description: 'Documentation for GtTransferField',
    code: '''
GtTransferField(
  amountController: GtInputController(),
  noteController: GtInputController(),
  firstParticipant: GtTransferParticipantData(
    label: "from",
    image: AppImageData(GtNetworkImages.savings),
    validate: true,
    name: "My Account",
  ),
  secondParticipant: GtTransferParticipantData(
    label: "to",
    image: AppImageData(GtNetworkImages.sampleAvatar1),
    validate: false,
    name: "Savings Account",
  ),
  noteHint: "What is this for?",
)
''',
    child: GtTransferField(
      amountController: GtInputController(),
      noteController: GtInputController(),
      firstParticipant: GtTransferParticipantData(
        label: "from",
        image: AppImageData(GtNetworkImages.savings),
        validate: true,
        name: "My Account",
      ),
      secondParticipant: GtTransferParticipantData(
        label: "to",
        image: AppImageData(GtNetworkImages.sampleAvatar1),
        validate: false,
        name: "Savings Account",
      ),
      noteHint: "What is this for?",
    ),
  );
}

GtInputController source = GtInputController();
GtInputController target = GtInputController();

@widgetbook.UseCase(name: 'GtFxTransferField', type: GtFxTransferField)
Widget playgroundGtFxTransferFieldUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtFxTransferField',
    description: 'Documentation for GtFxTransferField',
    code:
        '''
GtFxTransferField(
  sourceAmountController: source,
  targetAmountController: target,
  onSourceAmountChanged: (value) {
    AppDebouncer(300.milliseconds).run(() {
      if (!value.hasValue) {
        target.clear();
        return;
      }

      final amount = (value.asAmount ?? 0) * 1350;
      target.text = amount.formattedNumberLong;
    });
  },
  onTargetAmountChanged: (value) {
    AppDebouncer(300.milliseconds).run(() {
      if (!value.hasValue) {
        source.clear();
        return;
      }

      final amount = (value.asAmount ?? 0) / 1350;
      source.text = amount.formattedNumberLong;
    });
  },
  noteController: GtInputController(),
  firstParticipant: GtTransferParticipantData(
    label: "from",
    image: AppImageData(GtNetworkImages.business),
    imageType: .image,
    validate: true,
    name: "usd account · 1020293939",
    balance: 200015,
    currency: AppStrings.dollar,
  ),
  secondParticipant: GtTransferParticipantData(
    label: "to",
    image: AppImageData(GtNetworkImages.sampleAvatar1),
    validate: false,
    name: "Dubai Trip",
    balance: 1000000000,
    currency: AppStrings.naira,
  ),
  noteHint: "Add a note (optional)",
  child: Text.rich(
    TextSpan(
      text: "Live exchange rate: ",
      children: [
        TextSpan(
          text: "\$1 = ${1350.asCurrency()}",
          style: context.textStyles.subHeadXs(
            color: context.palette.primary.dark,
          ),
        ),
      ],
    ),
    style: context.textStyles.subHeadXs(),
  ),
)
''',
    child: GtFxTransferField(
      sourceAmountController: source,
      targetAmountController: target,
      onSourceAmountChanged: (value) {
        AppDebouncer(300.milliseconds).run(() {
          if (!value.hasValue) {
            target.clear();
            return;
          }

          final amount = (value.asAmount ?? 0) * 1350;
          target.text = amount.formattedNumberLong;
        });
      },
      onTargetAmountChanged: (value) {
        AppDebouncer(300.milliseconds).run(() {
          if (!value.hasValue) {
            source.clear();
            return;
          }

          final amount = (value.asAmount ?? 0) / 1350;
          source.text = amount.formattedNumberLong;
        });
      },
      noteController: GtInputController(),
      firstParticipant: GtTransferParticipantData(
        label: "from",
        image: AppImageData(GtNetworkImages.business),
        imageType: .image,
        validate: true,
        name: "usd account · 1020293939",
        balance: 200015,
        currency: AppStrings.dollar,
      ),
      secondParticipant: GtTransferParticipantData(
        label: "to",
        image: AppImageData(GtNetworkImages.sampleAvatar1),
        validate: false,
        name: "Dubai Trip",
        balance: 1000000000,
        currency: AppStrings.naira,
      ),
      noteHint: "Add a note (optional)",
      child: Text.rich(
        TextSpan(
          text: "Live exchange rate: ",
          children: [
            TextSpan(
              text: "\$1 = ${1350.asCurrency()}",
              style: context.textStyles.subHeadXs(
                color: context.palette.primary.dark,
              ),
            ),
          ],
        ),
        style: context.textStyles.subHeadXs(),
      ),
    ),
  );
}
