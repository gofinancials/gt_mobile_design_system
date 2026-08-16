import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtConfirmationScaffold',
  type: GtConfirmationScaffold,
)
Widget playgroundGtConfirmationScaffoldUseCase(BuildContext context) {
  return const _ConfirmationScaffoldPreview();
}

@widgetbook.UseCase(name: 'GtConfirmationBody', type: GtConfirmationBody)
Widget playgroundGtConfirmationBodyUseCase(BuildContext context) {
  return const _ConfirmationBodyInlinePreview();
}

const _disclaimer =
    "Your transfer has been processed successfully and will be delivered. "
    "However, there may be interruptions or delays from third party services. "
    "Sterling Bank is therefore not liable for any failures not within our "
    "control. All transactions are also subject to verification.";

const _note = "Please reach out to support for more information.";

List<GtConfirmationSection> _getSections(String preset, BuildContext context) {
  final reference = GtReceiptTileData(
    label: "Reference",
    value: "TRX24072983910527NGN",
    onTap: () {
      context.copyTextToClipboard("TRX24072983910527NGN");
      GtToast.of(context).show("Reference copied to clipboard");
    },
  );

  return switch (preset) {
    'Single Section' => [
      GtConfirmationSection(
        title: "Transaction Details",
        tiles: [
          const GtReceiptTileData(label: "Status", value: "Delivered"),
          const GtReceiptTileData(label: "Transaction Type", value: "Transfer"),
          reference,
        ],
      ),
    ],
    'With Row Images' => [
      const GtConfirmationSection(
        title: "Account Details",
        tiles: [
          GtReceiptTileData(label: "Name", value: "OLOWOFALA ALAO"),
          GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
          GtReceiptTileData(
            label: "Sender Bank",
            value: "Sterling Bank",
            image: AppImageData(GtVectors.logo),
          ),
        ],
      ),
      GtConfirmationSection(
        title: "Transaction Details",
        tiles: [
          const GtReceiptTileData(label: "Status", value: "Delivered"),
          const GtReceiptTileData(label: "Transaction Type", value: "Transfer"),
          reference,
        ],
      ),
    ],
    _ => [
      const GtConfirmationSection(
        title: "Account Details",
        tiles: [
          GtReceiptTileData(label: "Name", value: "OLOWOFALA ALAO"),
          GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
          GtReceiptTileData(label: "Sender Bank", value: "Sterling Bank"),
        ],
      ),
      const GtConfirmationSection(
        title: "Recipient Details",
        tiles: [
          GtReceiptTileData(label: "Name", value: "KENNETH OSMOSIS"),
          GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
          GtReceiptTileData(label: "Bank", value: "Kuda Bank Limited"),
        ],
      ),
      GtConfirmationSection(
        title: "Transaction Details",
        tiles: [
          const GtReceiptTileData(label: "Status", value: "Delivered"),
          const GtReceiptTileData(label: "Transaction Type", value: "Transfer"),
          const GtReceiptTileData(
            label: "Message",
            value: "House cleaning part payment",
          ),
          reference,
        ],
      ),
    ],
  };
}

GtConfirmationBody _buildConfiguredConfirmationBody({
  required BuildContext context,
  ScrollController? controller,
  required String amount,
  required String date,
  required String time,
  required GtReceiptStatus status,
  required bool customStatusTitle,
  required String statusTitleText,
  required bool interactiveStatusTap,
  required bool showStamp,
  required String sectionsPreset,
  required bool showDisclaimer,
  required bool showFooterNote,
  required bool showFooterTrailing,
  required String physicsChoice,
}) {
  final statusData = GtReceiptStatusData(
    status: status,
    title: customStatusTitle ? statusTitleText : null,
    onPressed: interactiveStatusTap
        ? () => GtToast.of(context).show("Status pill tapped (${status.name})")
        : null,
  );

  final physics = physicsChoice == 'Bouncing'
      ? const BouncingScrollPhysics()
      : const ClampingScrollPhysics();

  return GtConfirmationBody(
    controller: controller,
    physics: physics,
    amount: amount,
    date: date,
    time: time,
    status: statusData,
    stamp: showStamp ? const AppImageData(GtVectors.logo) : null,
    sections: _getSections(sectionsPreset, context),
    footer: GtConfirmationFooter(
      disclaimer: showDisclaimer ? _disclaimer : null,
      note: showFooterNote ? _note : null,
      // The design system ships no QR asset, so the brand mark stands in for
      // the code a real receipt would carry.
      trailing: showFooterTrailing
          ? const AppImageData(
              "https://images.unsplash.com/vector-1784356508877-c80e59b18c24?q=80&w=2360&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            )
          : null,
      trailingLabel: "Receipt QR code",
    ),
  );
}

class _ConfirmationKnobs {
  final String title;
  final String amount;
  final String date;
  final String time;
  final GtReceiptStatus status;
  final bool customStatusTitle;
  final String statusTitleText;
  final bool interactiveStatusTap;
  final bool showStamp;
  final String sectionsPreset;
  final bool showDisclaimer;
  final bool showFooterNote;
  final bool showFooterTrailing;
  final bool showShare;
  final String physicsChoice;

  const _ConfirmationKnobs({
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
    required this.customStatusTitle,
    required this.statusTitleText,
    required this.interactiveStatusTap,
    required this.showStamp,
    required this.sectionsPreset,
    required this.showDisclaimer,
    required this.showFooterNote,
    required this.showFooterTrailing,
    required this.showShare,
    required this.physicsChoice,
  });

  factory _ConfirmationKnobs.of(BuildContext context) {
    return _ConfirmationKnobs(
      title: context.knobs.string(
        label: 'App Bar Title',
        initialValue: 'Transfer Confirmation',
      ),
      amount: context.knobs.string(label: 'Amount', initialValue: '20,000.00'),
      date: context.knobs.string(
        label: 'Date',
        initialValue: 'September 29, 2025',
      ),
      time: context.knobs.string(label: 'Time', initialValue: '02:45 PM'),
      status: context.knobs.object.dropdown<GtReceiptStatus>(
        label: 'Status',
        options: GtReceiptStatus.values,
        initialOption: GtReceiptStatus.success,
        labelBuilder: (v) => v.name,
      ),
      customStatusTitle: context.knobs.boolean(
        label: 'Custom Status Title',
        initialValue: true,
      ),
      statusTitleText: context.knobs.string(
        label: 'Custom Status Text',
        initialValue: 'Delivered',
      ),
      interactiveStatusTap: context.knobs.boolean(
        label: 'Interactive Status Tap',
        initialValue: false,
      ),
      showStamp: context.knobs.boolean(label: 'Show Stamp', initialValue: true),
      sectionsPreset: context.knobs.object.dropdown<String>(
        label: 'Sections Preset',
        options: [
          'Standard (Three Sections)',
          'With Row Images',
          'Single Section',
        ],
        initialOption: 'Standard (Three Sections)',
      ),
      showDisclaimer: context.knobs.boolean(
        label: 'Show Disclaimer',
        initialValue: true,
      ),
      showFooterNote: context.knobs.boolean(
        label: 'Show Footer Note',
        initialValue: true,
      ),
      showFooterTrailing: context.knobs.boolean(
        label: 'Show Footer QR',
        initialValue: true,
      ),
      showShare: context.knobs.boolean(
        label: 'Show Share Action',
        initialValue: true,
      ),
      physicsChoice: context.knobs.object.dropdown<String>(
        label: 'Scroll Physics',
        options: ['Clamping (Default)', 'Bouncing'],
        initialOption: 'Clamping (Default)',
      ),
    );
  }

  GtConfirmationBody buildBody(
    BuildContext context, [
    ScrollController? controller,
  ]) {
    return _buildConfiguredConfirmationBody(
      context: context,
      controller: controller,
      amount: amount,
      date: date,
      time: time,
      status: status,
      customStatusTitle: customStatusTitle,
      statusTitleText: statusTitleText,
      interactiveStatusTap: interactiveStatusTap,
      showStamp: showStamp,
      sectionsPreset: sectionsPreset,
      showDisclaimer: showDisclaimer,
      showFooterNote: showFooterNote,
      showFooterTrailing: showFooterTrailing,
      physicsChoice: physicsChoice,
    );
  }

  /// The same receipt, described as an exportable PDF document.
  ///
  /// The cards shown on screen map straight across through
  /// [GtPdfReceiptSection.fromConfirmation]. The amount, status and timestamp
  /// the body renders above those cards have no card of their own, so they are
  /// promoted into a leading summary section rather than being dropped from
  /// the export.
  GtPdfReceiptData buildReceiptData(BuildContext context) {
    final statusTitle = GtReceiptStatusData(
      status: status,
      title: customStatusTitle ? statusTitleText : null,
    ).displayTitle;

    return GtPdfReceiptData(
      title: title,
      issuedOn: date,
      issuedOnLabel: 'Issued on:',
      sections: [
        GtPdfReceiptSection(
          title: 'Transfer Summary',
          entries: [
            GtPdfReceiptEntry(label: 'Amount', value: amount),
            GtPdfReceiptEntry(label: 'Status', value: statusTitle),
            GtPdfReceiptEntry(label: 'Date', value: date),
            GtPdfReceiptEntry(label: 'Time', value: time),
          ],
        ),
        for (final section in _getSections(sectionsPreset, context))
          GtPdfReceiptSection.fromConfirmation(section),
      ],
      footer: GtPdfReceiptFooter(
        disclaimer: showDisclaimer ? _disclaimer : null,
        note: showFooterNote ? _note : null,
        qrData: showFooterTrailing
            ? 'https://sterling.ng/receipts/TRX24072983910527NGN'
            : null,
      ),
    );
  }
}

class _ConfirmationScaffoldPreview extends StatefulWidget {
  const _ConfirmationScaffoldPreview();

  @override
  State<_ConfirmationScaffoldPreview> createState() =>
      _ConfirmationScaffoldPreviewState();
}

class _ConfirmationScaffoldPreviewState
    extends State<_ConfirmationScaffoldPreview>
    with GtBottomSheetMixin {
  bool _sharing = false;

  /// Renders the receipt on screen as a PDF and hands it to the share sheet.
  ///
  /// [anchor] positions the share popover on iPad and macOS, so it is the
  /// context of the page the sheet was opened from rather than a root one.
  /// Export can fail — content outside the Latin-1 range the standard PDF
  /// fonts cover, for one — so the result is never assumed.
  Future<void> _shareReceipt(
    BuildContext anchor,
    _ConfirmationKnobs knobs,
  ) async {
    if (_sharing) return;
    _sharing = true;

    try {
      const exporter = GtPdfReceiptExporter();
      await exporter.share(anchor, knobs.buildReceiptData(anchor));
    } catch (error) {
      if (!anchor.mounted) return;
      GtToast.of(anchor).show("Share failed: $error");
    } finally {
      _sharing = false;
    }
  }

  void _openConfirmationModal(BuildContext context, _ConfirmationKnobs knobs) {
    showDraggableSheet(
      context,
      initialChildSize: .9,
      maxChildSize: 1,
      minChildSize: .5,
      useRootNavigator: false,
      builder: (controller) {
        return GtConfirmationScaffold(
          title: knobs.title,
          onClose: () => GtRouter.forcePopView(),
          onShare: knobs.showShare ? () => _shareReceipt(context, knobs) : null,
          body: knobs.buildBody(context, controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final knobs = _ConfirmationKnobs.of(context);

    return GtWidgetDocPage(
      title: 'GtConfirmationScaffold',
      description:
          'A scaffold template for transaction confirmation screens. A back '
          'chevron dismisses the sheet, the title is centred, and an optional '
          'share action sits on the right. Unlike GtReceiptScaffold it renders '
          'no bottom navigation bar. Designed to be presented modally via '
          'GtBottomSheetMixin. Here the share action exports the receipt on '
          'screen as a PDF through GtPdfReceiptExporter and hands it to the '
          'native share sheet, so the same sections drive both the screen and '
          'the file.',
      code:
          '''
showDraggableSheet(
  context,
  builder: (controller) {
    return GtConfirmationScaffold(
      title: "${knobs.title}",
      onClose: () => GtRouter.popView(),
      onShare: () => const GtPdfReceiptExporter().share(
        context,
        GtPdfReceiptData(
          title: "${knobs.title}",
          issuedOn: "${knobs.date}",
          sections: [
            for (final section in sections)
              GtPdfReceiptSection.fromConfirmation(section),
          ],
        ),
      ),
      body: GtConfirmationBody(
        controller: controller,
        amount: "${knobs.amount}",
        date: "${knobs.date}",
        time: "${knobs.time}",
        status: const GtReceiptStatusData(
          status: GtReceiptStatus.${knobs.status.name},
          ${knobs.customStatusTitle ? 'title: "${knobs.statusTitleText}",' : ''}
        ),
        sections: const [
          GtConfirmationSection(
            title: "Account Details",
            tiles: [
              GtReceiptTileData(label: "Name", value: "OLOWOFALA ALAO"),
              GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
            ],
          ),
        ],
        footer: const GtConfirmationFooter(
          disclaimer: "Your transfer has been processed successfully...",
          note: "Please reach out to support for more information.",
          trailing: AppImageData("https://images.unsplash.com/vector-1784356508877-c80e59b18c24?q=80&w=2360&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
        ),
      ),
    );
  },
);''',
      child: GtRaisedButton(
        text: 'Present Confirmation Modal',
        onPressed: () => _openConfirmationModal(context, knobs),
      ),
    );
  }
}

class _ConfirmationBodyInlinePreview extends StatelessWidget {
  const _ConfirmationBodyInlinePreview();

  @override
  Widget build(BuildContext context) {
    final knobs = _ConfirmationKnobs.of(context);

    return GtWidgetDocPage(
      title: 'GtConfirmationBody',
      description:
          'Organism widget containing a transaction status pill, an optional '
          'stamp, the amount, a date and time row, one card per titled section '
          'of label/value rows, and an optional footer carrying the fine '
          'print, a closing note and a trailing image such as a QR code. '
          'Requires at least one section.',
      code:
          '''
GtConfirmationBody(
  amount: "${knobs.amount}",
  date: "${knobs.date}",
  time: "${knobs.time}",
  status: const GtReceiptStatusData(
    status: GtReceiptStatus.${knobs.status.name},
    ${knobs.customStatusTitle ? 'title: "${knobs.statusTitleText}",' : ''}
  ),
  ${knobs.showStamp ? 'stamp: const AppImageData(GtVectors.logo),' : ''}
  sections: [
    const GtConfirmationSection(
      title: "Account Details",
      tiles: [
        GtReceiptTileData(label: "Name", value: "OLOWOFALA ALAO"),
        GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
        GtReceiptTileData(label: "Sender Bank", value: "Sterling Bank"),
      ],
    ),
    GtConfirmationSection(
      title: "Transaction Details",
      tiles: [
        const GtReceiptTileData(label: "Status", value: "Delivered"),
        GtReceiptTileData(
          label: "Reference",
          value: "TRX24072983910527NGN",
          onTap: () => copyReference(),
        ),
      ],
    ),
  ],
  footer: const GtConfirmationFooter(
    ${knobs.showDisclaimer ? 'disclaimer: "Your transfer has been processed successfully...",' : ''}
    ${knobs.showFooterNote ? 'note: "Please reach out to support for more information.",' : ''}
    ${knobs.showFooterTrailing ? 'trailing: AppImageData(GtVectors.logo),' : ''}
  ),
)''',
      child: GtSizedBox(height: 650, child: knobs.buildBody(context)),
    );
  }
}
