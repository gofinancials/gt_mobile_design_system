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
    data: "My Account"
  ),
  secondParticipant: GtTransferParticipantData(
    label: "to",
    image: AppImageData(GtNetworkImages.sampleAvatar1),
    validate: false,
    data: "Savings Account"
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
        data: "My Account"
      ),
      secondParticipant: GtTransferParticipantData(
        label: "to",
        image: AppImageData(GtNetworkImages.sampleAvatar1),
        validate: false,
        data: "Savings Account"
      ),
      noteHint: "What is this for?",
    ),
  );
}
