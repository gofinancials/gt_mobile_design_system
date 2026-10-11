import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTransferField', type: GtTransferField)
Widget playgroundGtTransferFieldUseCase(BuildContext context) {
  final imageType = context.knobs.object.dropdown(
    label: 'Source drawn as',
    options: GtTransferParticipantImageType.values,
    initialOption: GtTransferParticipantImageType.image,
    labelBuilder: (value) => value.name,
  );
  final imageFails = context.knobs.boolean(
    label: 'Source image fails',
    initialValue: false,
  );
  final passErrorImage = context.knobs.boolean(
    label: 'Pass errorImage',
    initialValue: true,
  );

  final sourceImage = imageFails
      ? GalleryBrokenImages.url
      : GtNetworkImages.savings;
  final sourceImageCode = imageFails
      ? "'${GalleryBrokenImages.url}'"
      : 'GtNetworkImages.savings';

  return GtWidgetDocPage(
    title: 'GtTransferField',
    description:
        'Moves money between two participants. When a participant\'s image '
        'fails, its leg draws errorImage at the same size. Without one, an '
        'avatar leg falls back to the initials and an image leg to an empty '
        'space. Turn on "Source image fails" to see this.',
    code:
        '''
GtTransferField(
  amountController: GtInputController(),
  noteController: GtInputController(),
  firstParticipant: GtTransferParticipantData(
    label: "from",
    image: AppImageData($sourceImageCode),
    imageType: .${imageType.name},${passErrorImage ? '\n    errorImage: AppImageData(GtAssetImages.avatar),' : ''}
    validate: true,
    name: "Holiday Stash",
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
        image: AppImageData(sourceImage),
        imageType: imageType,
        errorImage: passErrorImage
            ? const AppImageData(GtAssetImages.avatar)
            : null,
        validate: true,
        name: "Holiday Stash",
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
