import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtReceiptScaffold', type: GtReceiptScaffold)
Widget playgroundGtReceiptScaffoldUseCase(BuildContext context) {
  return const _ReceiptScaffoldPreview();
}

@widgetbook.UseCase(name: 'GtReceiptBody', type: GtReceiptBody)
Widget playgroundGtReceiptBodyUseCase(BuildContext context) {
  return const _ReceiptBodyInlinePreview();
}

const _sampleBreakdownTransactions = [
  GtReceiptTransaction(
    title: "Airtime Top-up",
    subtitle: "MTN • 08031234567",
    value: "₦ 5,000.00",
    image: AppImageData(GtNetworkImages.sampleAvatar1),
    tag: AppImageData(GtVectors.logo),
  ),
  GtReceiptTransaction(
    title: "Electricity Bill",
    subtitle: "IKEDC Prepaid • 450123987",
    value: "₦ 15,000.00",
    image: AppImageData(GtNetworkImages.sampleAvatar2),
  ),
];

List<GtReceiptAction> _getActions(String preset, BuildContext context) {
  return switch (preset) {
    'Three Actions (Primary + Secondary)' => [
      GtReceiptAction.primary(
        label: "SEND AGAIN",
        icon: GtIcons.arrowNorthEast,
        onTap: () {
          GtToast.of(context).show("Send Again tapped");
        },
      ),
      GtReceiptAction(
        label: "SPLIT",
        icon: GtIcons.split,
        onTap: () {
          GtToast.of(context).show("Split tapped");
        },
      ),
      GtReceiptAction(
        label: "VIEW RECEIPT",
        icon: GtIcons.eyeOutline,
        onTap: () {
          GtToast.of(context).show("View Receipt tapped");
        },
      ),
    ],
    'Single Action' => [
      GtReceiptAction.primary(
        label: "SEND AGAIN",
        icon: GtIcons.arrowNorthEast,
        onTap: () {
          GtToast.of(context).show("Send Again tapped");
        },
      ),
    ],
    _ => const [],
  };
}

List<GtReceiptTileData> _getDetailTiles(String config, BuildContext context) {
  return switch (config) {
    'Full Details (Interactive + Images)' => [
      const GtReceiptTileData(label: "Status", value: "Successful"),
      GtReceiptTileData(
        label: "Reference",
        value: "TRX24072983910527NGN",
        onTap: () {
          context.copyTextToClipboard("TRX24072983910527NGN");
          GtToast.of(context).show("Reference copied to clipboard");
        },
      ),
      GtReceiptTileData(
        label: "Session ID",
        value: "999001240813123456789012345678",
        onTap: () {
          context.copyTextToClipboard("999001240813123456789012345678");
          GtToast.of(context).show("Session ID copied to clipboard");
        },
      ),
      const GtReceiptTileData(label: "Fee", value: "₦ 25.00"),
      const GtReceiptTileData(
        label: "Payment Method",
        value: "Sterling Account (..4502)",
      ),
      const GtReceiptTileData(label: "Channel", value: "Mobile App"),
      const GtReceiptTileData(label: "Paid At", value: "13 Aug 2026, 08:45 PM"),
    ],
    'Minimal' => [
      GtReceiptTileData(
        label: "Reference",
        value: "TRX24072983910527NGN",
        onTap: () {
          context.copyTextToClipboard("TRX24072983910527NGN");
          GtToast.of(context).show("Reference copied to clipboard");
        },
      ),
      const GtReceiptTileData(label: "Fee", value: "₦ 0.00"),
    ],
    _ => const [
      GtReceiptTileData(label: "Status", value: "Processing"),
      GtReceiptTileData(label: "Reference", value: "TRX24072983910527NGN"),
      GtReceiptTileData(label: "Session ID", value: "TRX24072983910527NGN"),
      GtReceiptTileData(label: "Fee", value: "₦ 25.00"),
    ],
  };
}

Widget? _getFooter(String footerType, BuildContext context) {
  return switch (footerType) {
    'Security Badge' => GtCard(
      variant: GtCardVariant.normal,
      padding: context.insets.allDp(12.px),
      child: const GtSimpleInfoTile(
        leading: GtIcon(GtIcons.alert, size: 16),
        text: "Transactions are protected with 256-bit end-to-end encryption.",
      ),
    ),
    'Notice Card' => GtCard(
      variant: GtCardVariant.info,
      padding: context.insets.allDp(12.px),
      child: GtText(
        "Funds have been debited and will reflect in recipient account shortly.",
        style: context.textStyles.body2Xs(
          color: context.palette.information.dark,
        ),
      ),
    ),
    'Action Button' => GtRaisedButton(
      text: "Download Statement",
      variant: .secondary,
      size: .small,
      leading: GtIcons.download,
      onPressed: () {
        GtToast.of(context).show("Download statement tapped");
      },
    ),
    _ => null,
  };
}

GtReceiptBody _buildConfiguredReceiptBody({
  required BuildContext context,
  ScrollController? controller,
  required String amount,
  required GtReceiptStatus status,
  required bool customStatusTitle,
  required String statusTitleText,
  required bool interactiveStatusTap,
  required String actionsPreset,
  required String fromName,
  required String fromSubtitle,
  required GtReceiptImageType fromImageType,
  required bool fromHasTag,
  required String fromLabel,
  required bool fromHasTransactions,
  required String toName,
  required String toSubtitle,
  required GtReceiptImageType toImageType,
  required bool toHasTag,
  required String toLabel,
  required bool toHasTransactions,
  required bool showMessage,
  required String messageText,
  required String messageTitle,
  required bool showCategory,
  required String categoryLabel,
  required String categoryValue,
  required bool categoryHasImage,
  required bool categoryInteractiveTap,
  required bool showTiles,
  required String tilesConfig,
  required bool showFooter,
  required String footerType,
  required String physicsChoice,
}) {
  final statusData = GtReceiptStatusData(
    status: status,
    title: customStatusTitle ? statusTitleText : null,
    onPressed: interactiveStatusTap
        ? () => GtToast.of(context).show("Status pill tapped (${status.name})")
        : null,
  );

  final actions = _getActions(actionsPreset, context);

  final fromParticipant = GtReceiptParticipant(
    title: fromName,
    subtitle: fromSubtitle.hasValue ? fromSubtitle : null,
    label: fromLabel.hasValue ? fromLabel : null,
    image: const AppImageData(GtNetworkImages.savings),
    tag: fromHasTag ? const AppImageData(GtVectors.logo) : null,
    imageType: fromImageType,
    transactions: fromHasTransactions ? _sampleBreakdownTransactions : const [],
  );

  final toParticipant = GtReceiptParticipant(
    title: toName,
    subtitle: toSubtitle.hasValue ? toSubtitle : null,
    label: toLabel.hasValue ? toLabel : null,
    image: const AppImageData(GtNetworkImages.sampleAvatar1),
    tag: toHasTag ? const AppImageData(GtVectors.logo) : null,
    imageType: toImageType,
    transactions: toHasTransactions ? _sampleBreakdownTransactions : const [],
  );

  final details = GtReceiptDetails(
    message: showMessage
        ? GtReceiptMessageData(
            message: messageText,
            title: messageTitle.hasValue ? messageTitle : null,
          )
        : null,
    category: showCategory
        ? GtReceiptTileData(
            label: categoryLabel,
            value: categoryValue,
            image: categoryHasImage
                ? const AppImageData(GtNetworkImages.transfer)
                : null,
            onTap: categoryInteractiveTap
                ? () => GtToast.of(
                    context,
                  ).show("Category tapped: $categoryValue")
                : null,
          )
        : null,
    tiles: showTiles ? _getDetailTiles(tilesConfig, context) : const [],
  );

  final footer = showFooter ? _getFooter(footerType, context) : null;
  final physics = physicsChoice == 'Bouncing'
      ? const BouncingScrollPhysics()
      : const ClampingScrollPhysics();

  return GtReceiptBody(
    controller: controller,
    physics: physics,
    amount: amount,
    status: statusData,
    actions: actions,
    from: fromParticipant,
    to: toParticipant,
    details: details,
    footer: footer,
  );
}

class _ReceiptScaffoldPreview extends StatefulWidget {
  const _ReceiptScaffoldPreview();

  @override
  State<_ReceiptScaffoldPreview> createState() =>
      _ReceiptScaffoldPreviewState();
}

class _ReceiptScaffoldPreviewState extends State<_ReceiptScaffoldPreview>
    with GtBottomSheetMixin {
  void _openReceiptModal(
    BuildContext context, {
    required String amount,
    required GtReceiptStatus status,
    required bool customStatusTitle,
    required String statusTitleText,
    required bool interactiveStatusTap,
    required String actionsPreset,
    required String fromName,
    required String fromSubtitle,
    required GtReceiptImageType fromImageType,
    required bool fromHasTag,
    required String fromLabel,
    required bool fromHasTransactions,
    required String toName,
    required String toSubtitle,
    required GtReceiptImageType toImageType,
    required bool toHasTag,
    required String toLabel,
    required bool toHasTransactions,
    required bool showMessage,
    required String messageText,
    required String messageTitle,
    required bool showCategory,
    required String categoryLabel,
    required String categoryValue,
    required bool categoryHasImage,
    required bool categoryInteractiveTap,
    required bool showTiles,
    required String tilesConfig,
    required bool showFooter,
    required String footerType,
    required String physicsChoice,
  }) {
    showDraggableSheet(
      context,
      initialChildSize: .9,
      maxChildSize: 1,
      minChildSize: .5,
      useRootNavigator: false,
      builder: (controller) {
        return GtReceiptScaffold(
          onClose: () => GtRouter.popView(),
          onReportProblem: () {
            GtToast.of(context).show("Report problem tapped");
          },
          body: _buildConfiguredReceiptBody(
            context: context,
            controller: controller,
            amount: amount,
            status: status,
            customStatusTitle: customStatusTitle,
            statusTitleText: statusTitleText,
            interactiveStatusTap: interactiveStatusTap,
            actionsPreset: actionsPreset,
            fromName: fromName,
            fromSubtitle: fromSubtitle,
            fromImageType: fromImageType,
            fromHasTag: fromHasTag,
            fromLabel: fromLabel,
            fromHasTransactions: fromHasTransactions,
            toName: toName,
            toSubtitle: toSubtitle,
            toImageType: toImageType,
            toHasTag: toHasTag,
            toLabel: toLabel,
            toHasTransactions: toHasTransactions,
            showMessage: showMessage,
            messageText: messageText,
            messageTitle: messageTitle,
            showCategory: showCategory,
            categoryLabel: categoryLabel,
            categoryValue: categoryValue,
            categoryHasImage: categoryHasImage,
            categoryInteractiveTap: categoryInteractiveTap,
            showTiles: showTiles,
            tilesConfig: tilesConfig,
            showFooter: showFooter,
            footerType: footerType,
            physicsChoice: physicsChoice,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = context.knobs.string(
      label: 'Amount',
      initialValue: '250,000.00',
    );
    final status = context.knobs.object.dropdown<GtReceiptStatus>(
      label: 'Status',
      options: GtReceiptStatus.values,
      initialOption: GtReceiptStatus.success,
      labelBuilder: (v) => v.name,
    );
    final customStatusTitle = context.knobs.boolean(
      label: 'Custom Status Title',
      initialValue: false,
    );
    final statusTitleText = context.knobs.string(
      label: 'Custom Status Text',
      initialValue: 'Under Verification',
    );
    final interactiveStatusTap = context.knobs.boolean(
      label: 'Interactive Status Tap',
      initialValue: true,
    );

    final actionsPreset = context.knobs.object.dropdown<String>(
      label: 'Actions Preset',
      options: [
        'Three Actions (Primary + Secondary)',
        'Single Action',
        'No Actions',
      ],
      initialOption: 'Three Actions (Primary + Secondary)',
    );

    final fromName = context.knobs.string(
      label: 'From: Name',
      initialValue: 'FLEX SAVINGS',
    );
    final fromSubtitle = context.knobs.string(
      label: 'From: Subtitle',
      initialValue: '0123456789',
    );
    final fromLabel = context.knobs.string(
      label: 'From: Label',
      initialValue: 'FROM',
    );
    final fromImageType = context.knobs.object.dropdown<GtReceiptImageType>(
      label: 'From: Image Type',
      options: GtReceiptImageType.values,
      initialOption: GtReceiptImageType.image,
      labelBuilder: (v) => v.name,
    );
    final fromHasTag = context.knobs.boolean(
      label: 'From: Has Tag',
      initialValue: true,
    );
    final fromHasTransactions = context.knobs.boolean(
      label: 'From: Has Breakdown Transactions',
      initialValue: false,
    );

    final toName = context.knobs.string(
      label: 'To: Name',
      initialValue: 'KENNETH OSMOSIS',
    );
    final toSubtitle = context.knobs.string(
      label: 'To: Subtitle',
      initialValue: 'Access Bank • 9876543210',
    );
    final toLabel = context.knobs.string(
      label: 'To: Label',
      initialValue: 'TO',
    );
    final toImageType = context.knobs.object.dropdown<GtReceiptImageType>(
      label: 'To: Image Type',
      options: GtReceiptImageType.values,
      initialOption: GtReceiptImageType.avatar,
      labelBuilder: (v) => v.name,
    );
    final toHasTag = context.knobs.boolean(
      label: 'To: Has Tag',
      initialValue: true,
    );
    final toHasTransactions = context.knobs.boolean(
      label: 'To: Has Breakdown Transactions',
      initialValue: true,
    );

    final showMessage = context.knobs.boolean(
      label: 'Details: Show Message',
      initialValue: true,
    );
    final messageText = context.knobs.string(
      label: 'Details: Message Text',
      initialValue: 'House cleaning part payment and maintenance fee',
    );
    final messageTitle = context.knobs.string(
      label: 'Details: Message Title',
      initialValue: 'Payment Note',
    );

    final showCategory = context.knobs.boolean(
      label: 'Details: Show Category',
      initialValue: true,
    );
    final categoryLabel = context.knobs.string(
      label: 'Category Label',
      initialValue: 'Category',
    );
    final categoryValue = context.knobs.string(
      label: 'Category Value',
      initialValue: 'Transfer',
    );
    final categoryHasImage = context.knobs.boolean(
      label: 'Category Has Image',
      initialValue: true,
    );
    final categoryInteractiveTap = context.knobs.boolean(
      label: 'Category Interactive Tap',
      initialValue: false,
    );

    final showTiles = context.knobs.boolean(
      label: 'Details: Show Tiles',
      initialValue: true,
    );
    final tilesConfig = context.knobs.object.dropdown<String>(
      label: 'Detail Tiles Configuration',
      options: ['Full Details (Interactive + Images)', 'Standard', 'Minimal'],
      initialOption: 'Full Details (Interactive + Images)',
    );

    final showFooter = context.knobs.boolean(
      label: 'Footer: Show Footer',
      initialValue: false,
    );
    final footerType = context.knobs.object.dropdown<String>(
      label: 'Footer Type',
      options: ['Security Badge', 'Notice Card', 'Action Button'],
      initialOption: 'Security Badge',
    );

    final physicsChoice = context.knobs.object.dropdown<String>(
      label: 'Scroll Physics',
      options: ['Clamping (Default)', 'Bouncing'],
      initialOption: 'Clamping (Default)',
    );

    return GtWidgetDocPage(
      title: 'GtReceiptScaffold',
      description:
          'A specialized scaffold template for displaying transaction receipts and confirmation summaries. Designed to be presented modally via GtBottomSheetMixin.',
      code:
          '''
showDraggableSheet(
  context,
  builder: (controller) {
    return GtReceiptScaffold(
      onClose: () => Navigator.of(context).pop(),
      onReportProblem: () => handleReportProblem(),
      body: GtReceiptBody(
        controller: controller,
        amount: "$amount",
        status: const GtReceiptStatusData(
          status: GtReceiptStatus.${status.name},
        ),
        actions: [
          GtReceiptAction.primary(
            label: "SEND AGAIN",
            icon: GtIcons.arrowNorthEast,
            onTap: () {},
          ),
          GtReceiptAction(
            label: "SPLIT",
            icon: GtIcons.split,
            onTap: () {},
          ),
        ],
        from: const GtReceiptParticipant(
          title: "$fromName",
          subtitle: "$fromSubtitle",
          image: AppImageData(GtNetworkImages.savings),
        ),
        to: const GtReceiptParticipant(
          title: "$toName",
          subtitle: "$toSubtitle",
          image: AppImageData(GtNetworkImages.sampleAvatar1),
        ),
        details: GtReceiptDetails(
          message: const GtReceiptMessageData(message: "$messageText"),
          category: const GtReceiptTileData(label: "$categoryLabel", value: "$categoryValue"),
          tiles: [
            GtReceiptTileData(label: "Reference", value: "TRX24072983910527NGN", onTap: () {}),
            const GtReceiptTileData(label: "Fee", value: "₦ 25.00"),
          ],
        ),
      ),
    );
  },
);''',
      child: GtRaisedButton(
        text: 'Present Receipt Modal',
        onPressed: () => _openReceiptModal(
          context,
          amount: amount,
          status: status,
          customStatusTitle: customStatusTitle,
          statusTitleText: statusTitleText,
          interactiveStatusTap: interactiveStatusTap,
          actionsPreset: actionsPreset,
          fromName: fromName,
          fromSubtitle: fromSubtitle,
          fromImageType: fromImageType,
          fromHasTag: fromHasTag,
          fromLabel: fromLabel,
          fromHasTransactions: fromHasTransactions,
          toName: toName,
          toSubtitle: toSubtitle,
          toImageType: toImageType,
          toHasTag: toHasTag,
          toLabel: toLabel,
          toHasTransactions: toHasTransactions,
          showMessage: showMessage,
          messageText: messageText,
          messageTitle: messageTitle,
          showCategory: showCategory,
          categoryLabel: categoryLabel,
          categoryValue: categoryValue,
          categoryHasImage: categoryHasImage,
          categoryInteractiveTap: categoryInteractiveTap,
          showTiles: showTiles,
          tilesConfig: tilesConfig,
          showFooter: showFooter,
          footerType: footerType,
          physicsChoice: physicsChoice,
        ),
      ),
    );
  }
}

class _ReceiptBodyInlinePreview extends StatelessWidget {
  const _ReceiptBodyInlinePreview();

  @override
  Widget build(BuildContext context) {
    final amount = context.knobs.string(
      label: 'Amount',
      initialValue: '250,000.00',
    );
    final status = context.knobs.object.dropdown<GtReceiptStatus>(
      label: 'Status',
      options: GtReceiptStatus.values,
      initialOption: GtReceiptStatus.success,
      labelBuilder: (v) => v.name,
    );
    final customStatusTitle = context.knobs.boolean(
      label: 'Custom Status Title',
      initialValue: false,
    );
    final statusTitleText = context.knobs.string(
      label: 'Custom Status Text',
      initialValue: 'Under Verification',
    );
    final interactiveStatusTap = context.knobs.boolean(
      label: 'Interactive Status Tap',
      initialValue: true,
    );

    final actionsPreset = context.knobs.object.dropdown<String>(
      label: 'Actions Preset',
      options: [
        'Three Actions (Primary + Secondary)',
        'Single Action',
        'No Actions',
      ],
      initialOption: 'Three Actions (Primary + Secondary)',
    );

    final fromName = context.knobs.string(
      label: 'From: Name',
      initialValue: 'FLEX SAVINGS',
    );
    final fromSubtitle = context.knobs.string(
      label: 'From: Subtitle',
      initialValue: '0123456789',
    );
    final fromLabel = context.knobs.string(
      label: 'From: Label',
      initialValue: 'FROM',
    );
    final fromImageType = context.knobs.object.dropdown<GtReceiptImageType>(
      label: 'From: Image Type',
      options: GtReceiptImageType.values,
      initialOption: GtReceiptImageType.image,
      labelBuilder: (v) => v.name,
    );
    final fromHasTag = context.knobs.boolean(
      label: 'From: Has Tag',
      initialValue: true,
    );
    final fromHasTransactions = context.knobs.boolean(
      label: 'From: Has Breakdown Transactions',
      initialValue: false,
    );

    final toName = context.knobs.string(
      label: 'To: Name',
      initialValue: 'KENNETH OSMOSIS',
    );
    final toSubtitle = context.knobs.string(
      label: 'To: Subtitle',
      initialValue: 'Access Bank • 9876543210',
    );
    final toLabel = context.knobs.string(
      label: 'To: Label',
      initialValue: 'TO',
    );
    final toImageType = context.knobs.object.dropdown<GtReceiptImageType>(
      label: 'To: Image Type',
      options: GtReceiptImageType.values,
      initialOption: GtReceiptImageType.avatar,
      labelBuilder: (v) => v.name,
    );
    final toHasTag = context.knobs.boolean(
      label: 'To: Has Tag',
      initialValue: true,
    );
    final toHasTransactions = context.knobs.boolean(
      label: 'To: Has Breakdown Transactions',
      initialValue: true,
    );

    final showMessage = context.knobs.boolean(
      label: 'Details: Show Message',
      initialValue: true,
    );
    final messageText = context.knobs.string(
      label: 'Details: Message Text',
      initialValue: 'House cleaning part payment and maintenance fee',
    );
    final messageTitle = context.knobs.string(
      label: 'Details: Message Title',
      initialValue: 'Payment Note',
    );

    final showCategory = context.knobs.boolean(
      label: 'Details: Show Category',
      initialValue: true,
    );
    final categoryLabel = context.knobs.string(
      label: 'Category Label',
      initialValue: 'Category',
    );
    final categoryValue = context.knobs.string(
      label: 'Category Value',
      initialValue: 'Transfer',
    );
    final categoryHasImage = context.knobs.boolean(
      label: 'Category Has Image',
      initialValue: true,
    );
    final categoryInteractiveTap = context.knobs.boolean(
      label: 'Category Interactive Tap',
      initialValue: false,
    );

    final showTiles = context.knobs.boolean(
      label: 'Details: Show Tiles',
      initialValue: true,
    );
    final tilesConfig = context.knobs.object.dropdown<String>(
      label: 'Detail Tiles Configuration',
      options: ['Full Details (Interactive + Images)', 'Standard', 'Minimal'],
      initialOption: 'Full Details (Interactive + Images)',
    );

    final showFooter = context.knobs.boolean(
      label: 'Footer: Show Footer',
      initialValue: false,
    );
    final footerType = context.knobs.object.dropdown<String>(
      label: 'Footer Type',
      options: ['Security Badge', 'Notice Card', 'Action Button'],
      initialOption: 'Security Badge',
    );

    final physicsChoice = context.knobs.object.dropdown<String>(
      label: 'Scroll Physics',
      options: ['Clamping (Default)', 'Bouncing'],
      initialOption: 'Clamping (Default)',
    );

    final receiptBody = _buildConfiguredReceiptBody(
      context: context,
      amount: amount,
      status: status,
      customStatusTitle: customStatusTitle,
      statusTitleText: statusTitleText,
      interactiveStatusTap: interactiveStatusTap,
      actionsPreset: actionsPreset,
      fromName: fromName,
      fromSubtitle: fromSubtitle,
      fromImageType: fromImageType,
      fromHasTag: fromHasTag,
      fromLabel: fromLabel,
      fromHasTransactions: fromHasTransactions,
      toName: toName,
      toSubtitle: toSubtitle,
      toImageType: toImageType,
      toHasTag: toHasTag,
      toLabel: toLabel,
      toHasTransactions: toHasTransactions,
      showMessage: showMessage,
      messageText: messageText,
      messageTitle: messageTitle,
      showCategory: showCategory,
      categoryLabel: categoryLabel,
      categoryValue: categoryValue,
      categoryHasImage: categoryHasImage,
      categoryInteractiveTap: categoryInteractiveTap,
      showTiles: showTiles,
      tilesConfig: tilesConfig,
      showFooter: showFooter,
      footerType: footerType,
      physicsChoice: physicsChoice,
    );

    return GtWidgetDocPage(
      title: 'GtReceiptBody',
      description:
          'Organism widget containing receipt status, amount, action items, participants, messages, categories, and transaction details list.',
      code:
          '''
GtReceiptBody(
  amount: "$amount",
  status: GtReceiptStatusData(
    status: GtReceiptStatus.${status.name},
    ${customStatusTitle ? 'title: "$statusTitleText",' : ''}
  ),
  actions: [
    GtReceiptAction.primary(
      label: "SEND AGAIN",
      icon: GtIcons.arrowNorthEast,
      onTap: () {},
    ),
    GtReceiptAction(
      label: "SPLIT",
      icon: GtIcons.split,
      onTap: () {},
    ),
  ],
  from: GtReceiptParticipant(
    title: "$fromName",
    subtitle: "$fromSubtitle",
    image: const AppImageData(GtNetworkImages.savings),
    imageType: GtReceiptImageType.${fromImageType.name},
  ),
  to: GtReceiptParticipant(
    title: "$toName",
    subtitle: "$toSubtitle",
    image: const AppImageData(GtNetworkImages.sampleAvatar1),
    imageType: GtReceiptImageType.${toImageType.name},
  ),
  details: GtReceiptDetails(
    message: ${showMessage ? 'const GtReceiptMessageData(message: "$messageText")' : 'null'},
    category: ${showCategory ? 'const GtReceiptTileData(label: "$categoryLabel", value: "$categoryValue")' : 'null'},
    tiles: [
      GtReceiptTileData(
        label: "Reference",
        value: "TRX24072983910527NGN",
        onTap: () => copyReference(),
      ),
      const GtReceiptTileData(label: "Fee", value: "₦ 25.00"),
    ],
  ),
)''',
      child: GtSizedBox(height: 650, child: receiptBody),
    );
  }
}
