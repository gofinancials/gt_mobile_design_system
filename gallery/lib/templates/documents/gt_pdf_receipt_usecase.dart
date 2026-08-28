import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPdfReceiptExporter', type: GtPdfReceiptExporter)
Widget playgroundGtPdfReceiptExporterUseCase(BuildContext context) {
  return const _PdfReceiptExportPreview();
}

const _disclaimer =
    "Your transfer has been processed successfully and will be delivered. "
    "However, there may be interruptions or delays from third party services. "
    "Sterling Bank is therefore not liable for any failures not within our "
    "control. All transactions are also subject to verification and fraud "
    "checks.";

const _note = "Please reach out to support for more information.";

const _transferDetails = GtPdfReceiptSection(
  title: "Transfer Details",
  entries: [
    GtPdfReceiptEntry(label: "Transfer Type", value: "Instant bank transfer"),
    GtPdfReceiptEntry(label: "Amount", value: "20,000.00 NGN"),
    GtPdfReceiptEntry(
      label: "Session ID/Reference",
      value: "81a0cf3b-cb71-49f8-9696-c68e9f747671",
    ),
    GtPdfReceiptEntry(label: "Transfer Date", value: "30.09.2025"),
    GtPdfReceiptEntry(label: "Message", value: "House cleaning part payment"),
    GtPdfReceiptEntry(label: "Fee", value: "0.00 NGN"),
  ],
);

const _senderDetails = GtPdfReceiptSection(
  title: "Sender Details",
  heading: "OLALEKAN OMOLUABI",
  entries: [
    GtPdfReceiptEntry(label: "Account number", value: "******5678"),
    GtPdfReceiptEntry(label: "Bank Name", value: "STERLING BANK"),
  ],
);

const _recipientDetails = GtPdfReceiptSection(
  title: "Recipient Details",
  heading: "KENNETH OSMOSIS",
  entries: [
    GtPdfReceiptEntry(label: "Account number", value: "9012345678"),
    GtPdfReceiptEntry(label: "Bank Name", value: "KUDA BANK LIMITED"),
  ],
);

/// The knobs describing the receipt handed to the exporter.
class _PdfReceiptKnobs {
  final String title;
  final String issuedOn;
  final String fileName;
  final bool showBrandMark;
  final bool showFooter;
  final bool showQr;
  final bool themeFromPalette;
  final bool showPreview;

  const _PdfReceiptKnobs({
    required this.title,
    required this.issuedOn,
    required this.fileName,
    required this.showBrandMark,
    required this.showFooter,
    required this.showQr,
    required this.themeFromPalette,
    required this.showPreview,
  });

  factory _PdfReceiptKnobs.of(BuildContext context) {
    return _PdfReceiptKnobs(
      title: context.knobs.string(
        label: 'Document Title',
        initialValue: 'Transfer Confirmation',
      ),
      issuedOn: context.knobs.string(
        label: 'Issued On',
        initialValue: '03.10.2025',
      ),
      fileName: context.knobs.string(label: 'File Name', initialValue: ''),
      showBrandMark: context.knobs.boolean(
        label: 'Show Brand Mark',
        initialValue: true,
      ),
      showFooter: context.knobs.boolean(
        label: 'Show Footer',
        initialValue: true,
      ),
      showQr: context.knobs.boolean(label: 'Show QR Code', initialValue: true),
      themeFromPalette: context.knobs.boolean(
        label: 'Theme From App Palette',
        initialValue: false,
      ),
      showPreview: context.knobs.boolean(
        label: 'Show Preview',
        initialValue: true,
      ),
    );
  }

  GtPdfReceiptData buildData() {
    return GtPdfReceiptData(
      title: title,
      issuedOn: issuedOn.hasValue ? issuedOn : null,
      issuedOnLabel: 'Issued on:',
      fileName: fileName.hasValue ? fileName : null,
      showBrandMark: showBrandMark,
      sections: const [_transferDetails, _senderDetails, _recipientDetails],
      footer: showFooter
          ? GtPdfReceiptFooter(
              title: "Sterling Bank Address",
              address:
                  "Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria",
              contactLines: const [
                "customercare@sterling.ng",
                "02018888822, 07008220000",
              ],
              qrData: showQr
                  ? "https://sterling.ng/receipts/81a0cf3b-cb71-49f8-9696"
                  : null,
              disclaimer: _disclaimer,
              note: _note,
            )
          : null,
    );
  }

  GtPdfReceiptExporter buildExporter(BuildContext context) {
    if (!themeFromPalette) return const GtPdfReceiptExporter();
    return GtPdfReceiptExporter.fromPalette(context.palette);
  }

  Object get previewKey => (
    title,
    issuedOn,
    fileName,
    showBrandMark,
    showFooter,
    showQr,
    themeFromPalette,
  );
}

/// A playground for building a PDF receipt and handing it to the device.
///
/// The rendered document is shown inline so the knobs can be read against the
/// page they produce — page breaks included. That preview is a gallery
/// convenience built on `printing`; on a device the finished file is handed to
/// the platform and opened by whatever the customer already uses, which is the
/// path the two buttons below take.
class _PdfReceiptExportPreview extends StatefulWidget {
  const _PdfReceiptExportPreview();

  @override
  State<_PdfReceiptExportPreview> createState() =>
      _PdfReceiptExportPreviewState();
}

class _PdfReceiptExportPreviewState extends State<_PdfReceiptExportPreview> {
  bool _busy = false;

  /// Runs [action] with the busy flag raised, reporting failures as a toast.
  ///
  /// Export can genuinely fail — a cancelled save dialog, or content outside
  /// the Latin-1 range the standard PDF fonts cover — so nothing here is
  /// assumed to succeed.
  Future<void> _run(Future<String> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      final message = await action();
      if (!mounted) return;
      GtToast.of(context).show(message);
    } catch (error) {
      if (!mounted) return;
      GtToast.of(context).show("Export failed: $error");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share(GtPdfReceiptExporter exporter, GtPdfReceiptData data) {
    return _run(() async {
      await exporter.share(context, data);
      return "Shared ${data.resolvedFileName}";
    });
  }

  Future<void> _download(GtPdfReceiptExporter exporter, GtPdfReceiptData data) {
    return _run(() async {
      final result = await exporter.save(data);
      if (result.hasError) return "Download cancelled or unavailable";
      return "Downloaded ${data.resolvedFileName}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final knobs = _PdfReceiptKnobs.of(context);
    final data = knobs.buildData();
    final exporter = knobs.buildExporter(context);

    return GtWidgetDocPage(
      title: 'GtPdfReceiptExporter',
      description:
          'Builds a printable PDF receipt from GtPdfReceiptData and hands it '
          'to the device. Sharing goes through AppSharePlugin and downloading '
          'through AppFilePlugin, so the suite adds no plugins of its own. '
          'Layout lives in GtPdfReceiptBuilder and styling in '
          'GtPdfReceiptTheme, which can be derived from the live app palette. '
          'Documents use the PDF standard font family rather than the app '
          'typeface, so they render identically in every reader — at the cost '
          'of being Latin-1 only. The page below is the real document, '
          'rasterised by the gallery so the knobs can be read against what '
          'they produce; the suite itself ships no PDF viewer.',
      code:
          '''
const exporter = GtPdfReceiptExporter();

const data = GtPdfReceiptData(
  title: "${knobs.title}",
  issuedOn: "${knobs.issuedOn}",
  sections: [
    GtPdfReceiptSection(
      title: "Transfer Details",
      entries: [
        GtPdfReceiptEntry(label: "Amount", value: "20,000.00 NGN"),
        GtPdfReceiptEntry(label: "Fee", value: "0.00 NGN"),
      ],
    ),
    GtPdfReceiptSection(
      title: "Sender Details",
      heading: "OLALEKAN OMOLUABI",
      entries: [
        GtPdfReceiptEntry(label: "Account number", value: "******5678"),
        GtPdfReceiptEntry(label: "Bank Name", value: "STERLING BANK"),
      ],
    ),
  ],${knobs.showFooter ? '''
  footer: GtPdfReceiptFooter(
    title: "Sterling Bank Address",
    address: "Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria",${knobs.showQr ? '''
    qrData: "https://sterling.ng/receipts/81a0cf3b",''' : ''}
    disclaimer: "Your transfer has been processed successfully...",
    note: "Please reach out to support for more information.",
  ),''' : ''}
);

// Hand it to the native share sheet…
await exporter.share(context, data);

// …or write it to the device.
final result = await exporter.save(data);

// Only the bytes are needed to show it, upload it or attach it.
final bytes = await exporter.render(data);''',
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (knobs.showPreview) ...[
            GalleryPdfPreview(
              render: () => exporter.render(data),
              cacheKey: (
                knobs.previewKey,
                knobs.themeFromPalette ? context.palette : null,
              ),
              height: 800,
              fileName: data.resolvedFileName,
            ),
            const GtGap.yMd(),
          ],
          Wrap(
            spacing: context.spacingBase,
            runSpacing: context.spacingBase,
            children: [
              GtRaisedButton(
                text: _busy ? 'Working…' : 'Share PDF',
                size: .small,
                isDisabled: _busy,
                onPressed: () => _share(exporter, data),
              ),
              GtRaisedButton(
                text: 'Download PDF',
                size: .small,
                variant: .neutral,
                isDisabled: _busy,
                onPressed: () => _download(exporter, data),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
