import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtTransferDetailScaffold',
  type: GtTransferDetailScaffold,
)
Widget playgroundGtTransferDetailScaffoldUseCase(BuildContext context) {
  return const _TransferDetailScaffoldPreview();
}

@widgetbook.UseCase(name: 'GtTransferDetailBody', type: GtTransferDetailBody)
Widget playgroundGtTransferDetailBodyUseCase(BuildContext context) {
  return const _TransferDetailBodyInlinePreview();
}

const _timestamp = 'Sep 10, 2025 11:03 AM';

List<GtStatusStepData> _getSteps(String scenario) {
  return switch (scenario) {
    'Sending' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Sending',
        state: GtStatusStepState.active,
        subtitle: _timestamp,
      ),
      GtStatusStepData(label: 'Delivered', state: GtStatusStepState.pending),
    ],
    'Completing' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Sent',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Completing',
        state: GtStatusStepState.active,
        subtitle: _timestamp,
      ),
    ],
    'Delivered' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Sent',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Delivered',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
    ],
    'Failed' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Failed',
        state: GtStatusStepState.failed,
        subtitle: _timestamp,
      ),
      GtStatusStepData(label: 'Delivered', state: GtStatusStepState.pending),
    ],
    'Failed, Then Reversed' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Failed',
        state: GtStatusStepState.failed,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Reversed',
        state: GtStatusStepState.reversed,
        subtitle: _timestamp,
      ),
    ],
    'Not Delivered' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Sent',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Not Delivered',
        state: GtStatusStepState.failed,
        subtitle: _timestamp,
      ),
    ],
    'Reversed' => const [
      GtStatusStepData(
        label: 'Processed',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Sent',
        state: GtStatusStepState.success,
        subtitle: _timestamp,
      ),
      GtStatusStepData(
        label: 'Reversed',
        state: GtStatusStepState.reversed,
        subtitle: _timestamp,
      ),
    ],
    _ => const [
      GtStatusStepData(
        label: 'Processing',
        state: GtStatusStepState.active,
        subtitle: _timestamp,
      ),
      GtStatusStepData(label: 'Sent', state: GtStatusStepState.pending),
      GtStatusStepData(label: 'Delivered', state: GtStatusStepState.pending),
    ],
  };
}

List<GtReceiptAction> _getActions(String preset, BuildContext context) {
  return switch (preset) {
    'Send Again + View Receipt' => [
      GtReceiptAction.primary(
        label: "Send again",
        icon: GtIcons.arrowNorthEast,
        onTap: () {
          GtToast.of(context).show("Send again tapped");
        },
      ),
      GtReceiptAction(
        label: "View receipt",
        icon: GtIcons.fileContent,
        style: GtReceiptActionStyle(variant: .secondary),
        onTap: () {
          GtToast.of(context).show("View receipt tapped");
        },
      ),
    ],
    'Single Action' => [
      GtReceiptAction.primary(
        label: "Send again",
        icon: GtIcons.arrowNorthEast,
        onTap: () {
          GtToast.of(context).show("Send again tapped");
        },
      ),
    ],
    _ => const [],
  };
}

List<GtTransferDetailSection> _getSections(
  bool showFeeInfo,
  BuildContext context,
) {
  return [
    const GtTransferDetailSection(
      tiles: [
        GtReceiptTileData(
          label: "Category",
          value: "Transfer",
          image: AppImageData(GtNetworkImages.transfer),
        ),
        GtReceiptTileData(
          label: "Source Account",
          value: "Savings · 1020293939",
        ),
        GtReceiptTileData(
          label: "Message",
          value: "House cleaning part payment",
        ),
      ],
    ),
    GtTransferDetailSection(
      tiles: [
        GtReceiptTileData(
          label: "Fees (VAT Incl)",
          value: "₦25",
          onInfoTap: showFeeInfo
              ? () => GtToast.of(context).show("Includes 7.5% VAT")
              : null,
        ),
        GtReceiptTileData(
          label: "Stamp duty",
          value: "₦50",
          onInfoTap: showFeeInfo
              ? () => GtToast.of(
                  context,
                ).show("Charged on transfers of ₦10,000 and above")
              : null,
        ),
      ],
    ),
    GtTransferDetailSection(
      tiles: [
        GtReceiptTileData(
          label: "Reference",
          value: "TRX24072983910527NGN",
          onTap: () {
            context.copyText("TRX24072983910527NGN");
            GtToast.of(context).show("Reference copied to clipboard");
          },
        ),
        GtReceiptTileData(
          label: "Transaction ID",
          value: "TRX24072983910527NGN",
          onTap: () {
            context.copyText("TRX24072983910527NGN");
            GtToast.of(context).show("Transaction ID copied to clipboard");
          },
        ),
        GtReceiptTileData(
          label: "Session ID",
          value: "999001240813123456789012345678",
          onTap: () {
            context.copyText("999001240813123456789012345678");
            GtToast.of(context).show("Session ID copied to clipboard");
          },
        ),
      ],
    ),
  ];
}

GtTransferDetailBody _buildConfiguredTransferDetailBody({
  required BuildContext context,
  ScrollController? controller,
  required double amount,
  required bool isCredit,
  required String recipientName,
  required bool recipientHasTag,
  required String scenario,
  required String actionsPreset,
  required bool showFeeInfo,
}) {
  final recipient = GtReceiptParticipant(
    title: recipientName,
    image: const AppImageData(GtNetworkImages.sampleAvatar1),
    tag: recipientHasTag ? const AppImageData(GtVectors.logo) : null,
    imageType: GtReceiptImageType.avatar,
  );

  return GtTransferDetailBody(
    controller: controller,
    amount: amount,
    isCredit: isCredit,
    recipient: recipient,
    actions: _getActions(actionsPreset, context),
    steps: _getSteps(scenario),
    sections: _getSections(showFeeInfo, context),
  );
}

class _TransferDetailScaffoldPreview extends StatefulWidget {
  const _TransferDetailScaffoldPreview();

  @override
  State<_TransferDetailScaffoldPreview> createState() =>
      _TransferDetailScaffoldPreviewState();
}

class _TransferDetailScaffoldPreviewState
    extends State<_TransferDetailScaffoldPreview>
    with GtBottomSheetMixin {
  void _openTransferDetailModal(
    BuildContext context, {
    required double amount,
    required bool isCredit,
    required String recipientName,
    required bool recipientHasTag,
    required String scenario,
    required String actionsPreset,
    required bool showFeeInfo,
    required bool showDownload,
  }) {
    showDraggableSheet(
      context,
      initialChildSize: .9,
      maxChildSize: 1,
      minChildSize: .5,
      useRootNavigator: false,
      builder: (controller) {
        return GtTransferDetailScaffold(
          onClose: () => GtRouter.forcePopView(),
          onReportProblem: () {
            GtToast.of(context).show("Report problem tapped");
          },
          onDownload: showDownload
              ? () => GtToast.of(context).show("Download tapped")
              : null,
          body: _buildConfiguredTransferDetailBody(
            context: context,
            controller: controller,
            amount: amount,
            isCredit: isCredit,
            recipientName: recipientName,
            recipientHasTag: recipientHasTag,
            scenario: scenario,
            actionsPreset: actionsPreset,
            showFeeInfo: showFeeInfo,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = context.knobs.double.input(
      label: 'Amount',
      initialValue: 20000,
    );
    final isCredit = context.knobs.boolean(
      label: 'Credit (money in)',
      initialValue: false,
    );

    final recipientName = context.knobs.string(
      label: 'Recipient: Name',
      initialValue: 'Frances Nkatie',
    );
    final recipientHasTag = context.knobs.boolean(
      label: 'Recipient: Has Tag',
      initialValue: true,
    );

    final scenario = context.knobs.object.dropdown<String>(
      label: 'Scenario',
      options: [
        'Processing',
        'Sending',
        'Completing',
        'Delivered',
        'Failed',
        'Failed, Then Reversed',
        'Not Delivered',
        'Reversed',
      ],
      initialOption: 'Processing',
    );

    final actionsPreset = context.knobs.object.dropdown<String>(
      label: 'Actions Preset',
      options: ['Send Again + View Receipt', 'Single Action', 'No Actions'],
      initialOption: 'Send Again + View Receipt',
    );

    final showFeeInfo = context.knobs.boolean(
      label: 'Details: Show Fee Info',
      initialValue: true,
    );

    final showDownload = context.knobs.boolean(
      label: 'Show Download Action',
      initialValue: false,
    );

    return GtWidgetDocPage(
      title: 'GtTransferDetailScaffold',
      description:
          'A scaffold template for transfer detail screens. It shares the layout of GtReceiptScaffold and is designed to be presented modally via GtBottomSheetMixin. Use the Scenario knob to walk through every transfer outcome in the design.',
      code:
          '''
showDraggableSheet(
  context,
  builder: (controller) {
    return GtTransferDetailScaffold(
      onClose: () => GtRouter.popView(),
      onReportProblem: () => handleReportProblem(),
      body: GtTransferDetailBody(
        controller: controller,
        amount: $amount,
        isCredit: $isCredit,
        recipient: const GtReceiptParticipant(
          title: "$recipientName",
          image: AppImageData(GtNetworkImages.sampleAvatar1),
          imageType: GtReceiptImageType.avatar,
        ),
        steps: const [
          GtStatusStepData(label: "Processed", state: GtStatusStepState.success),
          GtStatusStepData(label: "Sending", state: GtStatusStepState.active),
          GtStatusStepData(label: "Delivered", state: GtStatusStepState.pending),
        ],
        sections: const [
          GtTransferDetailSection(
            tiles: [GtReceiptTileData(label: "Stamp duty", value: "₦50")],
          ),
        ],
      ),
    );
  },
);''',
      child: GtRaisedButton(
        text: 'Present Transfer Detail Modal',
        onPressed: () => _openTransferDetailModal(
          context,
          amount: amount,
          isCredit: isCredit,
          recipientName: recipientName,
          recipientHasTag: recipientHasTag,
          scenario: scenario,
          actionsPreset: actionsPreset,
          showFeeInfo: showFeeInfo,
          showDownload: showDownload,
        ),
      ),
    );
  }
}

class _TransferDetailBodyInlinePreview extends StatelessWidget {
  const _TransferDetailBodyInlinePreview();

  @override
  Widget build(BuildContext context) {
    final amount = context.knobs.double.input(
      label: 'Amount',
      initialValue: 20000,
    );
    final isCredit = context.knobs.boolean(
      label: 'Credit (money in)',
      initialValue: false,
    );

    final recipientName = context.knobs.string(
      label: 'Recipient: Name',
      initialValue: 'Frances Nkatie',
    );
    final recipientHasTag = context.knobs.boolean(
      label: 'Recipient: Has Tag',
      initialValue: true,
    );

    final scenario = context.knobs.object.dropdown<String>(
      label: 'Scenario',
      options: [
        'Processing',
        'Sending',
        'Completing',
        'Delivered',
        'Failed',
        'Failed, Then Reversed',
        'Not Delivered',
        'Reversed',
      ],
      initialOption: 'Processing',
    );

    final actionsPreset = context.knobs.object.dropdown<String>(
      label: 'Actions Preset',
      options: ['Send Again + View Receipt', 'Single Action', 'No Actions'],
      initialOption: 'Send Again + View Receipt',
    );

    final showFeeInfo = context.knobs.boolean(
      label: 'Details: Show Fee Info',
      initialValue: true,
    );

    final transferDetailBody = _buildConfiguredTransferDetailBody(
      context: context,
      amount: amount,
      isCredit: isCredit,
      recipientName: recipientName,
      recipientHasTag: recipientHasTag,
      scenario: scenario,
      actionsPreset: actionsPreset,
      showFeeInfo: showFeeInfo,
    );

    return GtWidgetDocPage(
      title: 'GtTransferDetailBody',
      description:
          'Organism widget containing the recipient, amount, actions, a compact status tracker, and untitled cards of transfer details.',
      code:
          '''
GtTransferDetailBody(
  amount: $amount,
  isCredit: $isCredit,
  recipient: const GtReceiptParticipant(
    title: "$recipientName",
    image: AppImageData(GtNetworkImages.sampleAvatar1),
    imageType: GtReceiptImageType.avatar,
  ),
  actions: [
    GtReceiptAction.primary(
      label: "Send again",
      icon: GtIcons.arrowNorthEast,
      onTap: () {},
    ),
  ],
  steps: const [
    GtStatusStepData(label: "Processed", state: GtStatusStepState.success),
    GtStatusStepData(label: "Sending", state: GtStatusStepState.active),
    GtStatusStepData(label: "Delivered", state: GtStatusStepState.pending),
  ],
  sections: [
    GtTransferDetailSection(
      tiles: [
        GtReceiptTileData(
          label: "Fees (VAT Incl)",
          value: "₦25",
          onInfoTap: ${showFeeInfo ? '() => explainFees()' : 'null'},
        ),
        const GtReceiptTileData(label: "Stamp duty", value: "₦50"),
      ],
    ),
  ],
)''',
      child: GtSizedBox(height: 650, child: transferDetailBody),
    );
  }
}
