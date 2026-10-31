import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'GtPdfStatementExporter',
  type: GtPdfStatementExporter,
)
Widget playgroundGtPdfStatementExporterUseCase(BuildContext context) {
  return const _PdfStatementExportPreview();
}

const _period = '01/03/2026 - 10/03/2026';

const _holder = GtPdfStatementHolder(
  name: 'Alex Lobaloba',
  address: ['210 Sanusi Street', 'Surulere, Lagos', '234768', 'Nigeria'],
);

const _details = [
  GtPdfReceiptEntry(label: 'Account Number', value: '0123456789'),
  GtPdfReceiptEntry(label: 'Bank Sort Code', value: '232'),
];

const _summary = GtPdfStatementSummaryRow(
  product: 'Savings Account',
  accountNumber: '0123456789',
  openingBalance: '₦1,200,000,000',
  totalOutgoings: '₦19,000,123',
  totalDeposits: '₦19,000,123',
  closingBalance: '₦19,000,123',
);

const _samples = [
  GtPdfStatementTransaction(
    date: '01/03/2026',
    title: 'Payment from Francis Lobaloba',
    details: [
      'Transaction ID: TRX24072983910527NG',
      'From: Francis Lobaloba, 01234567890',
      'Reference: House Rent',
    ],
    amount: '₦1,000,000',
    isCredit: true,
    balance: '₦1,200,000,000',
  ),
  GtPdfStatementTransaction(
    date: '02/03/2026',
    title: 'Paystack Checkout',
    details: [
      'Transaction ID: TRX24072983910527NG',
      'To: Paystack Checkout, Chowdeck',
      'Card: **** ***** **** 4490',
    ],
    amount: '₦500,000',
    isCredit: false,
    balance: '₦1,180,999,877',
  ),
  GtPdfStatementTransaction(
    date: '08/03/2026',
    title: 'To Shopping Stash',
    details: ['Transaction ID: TRX24072983910527NG'],
    amount: '₦700,000,000',
    isCredit: false,
    balance: '₦19,000,123',
  ),
];

const _footer = GtPdfStatementFooter(
  title: 'Sterling Bank Address',
  address: ['Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria'],
  contactLines: ['customercare@sterling.ng', '02018888822, 07008220000'],
  qrData: 'https://sterling.ng/statements/0123456789',
  copyright: '© 2026 Sterling Bank',
);

class _PdfStatementKnobs {
  final int transactionCount;
  final bool showFooter;
  final bool showQr;
  final bool followAppTheme;
  final bool showPreview;

  const _PdfStatementKnobs({
    required this.transactionCount,
    required this.showFooter,
    required this.showQr,
    required this.followAppTheme,
    required this.showPreview,
  });

  factory _PdfStatementKnobs.of(BuildContext context) {
    return _PdfStatementKnobs(
      transactionCount: context.knobs.int.slider(
        label: 'Transactions',
        initialValue: 3,
        min: 0,
        max: 2000,
      ),
      showFooter: context.knobs.boolean(
        label: 'Show Footer',
        initialValue: true,
      ),
      showQr: context.knobs.boolean(label: 'Show QR Code', initialValue: true),
      followAppTheme: context.knobs.boolean(
        label: 'Follow App Theme',
        initialValue: false,
      ),
      showPreview: context.knobs.boolean(
        label: 'Show Preview',
        initialValue: true,
      ),
    );
  }

  GtPdfStatementData buildData() {
    return GtPdfStatementData(
      title: 'Savings Account Statement',
      period: _period,
      holder: _holder,
      details: _details,
      summary: const [_summary],
      transactions: [
        for (var index = 0; index < transactionCount; index++)
          _samples[index % _samples.length],
      ],
      footer: switch ((showFooter, showQr)) {
        (false, _) => null,
        (true, true) => _footer,
        (true, false) => GtPdfStatementFooter(
          title: _footer.title,
          address: _footer.address,
          contactLines: _footer.contactLines,
          copyright: _footer.copyright,
        ),
      },
    );
  }

  GtPalette paletteOf(BuildContext context) {
    if (followAppTheme) return context.palette;
    return context.themeData.lightPalette;
  }

  Object get previewKey => (transactionCount, showFooter, showQr);
}

class _PdfStatementExportPreview extends StatefulWidget {
  const _PdfStatementExportPreview();

  @override
  State<_PdfStatementExportPreview> createState() =>
      _PdfStatementExportPreviewState();
}

class _PdfStatementExportPreviewState
    extends State<_PdfStatementExportPreview> {
  bool _busy = false;

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

  Future<void> _share(
    GtPdfStatementExporter exporter,
    GtPdfStatementData data,
  ) {
    return _run(() async {
      await exporter.share(context, data);
      return "Shared ${data.resolvedFileName}";
    });
  }

  Future<void> _download(
    GtPdfStatementExporter exporter,
    GtPdfStatementData data,
  ) {
    return _run(() async {
      final result = await exporter.save(data);
      if (result.hasError) return "Download cancelled or unavailable";
      return "Downloaded ${data.resolvedFileName}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final knobs = _PdfStatementKnobs.of(context);
    final palette = knobs.paletteOf(context);
    final exporter = GtPdfStatementExporter.fromPalette(palette);
    final data = knobs.buildData();
    final paletteCode = knobs.followAppTheme
        ? 'context.palette'
        : 'context.themeData.lightPalette';

    return GtWidgetDocPage(
      title: 'GtPdfStatementExporter',
      description:
          'Builds a printable PDF account statement from GtPdfStatementData '
          'and hands it to the device, the way GtPdfInvoiceExporter does for '
          'invoices. The header and footer repeat on every page, and the '
          'transaction table breaks between rows, carrying its column '
          'headings on to every page it continues onto. A credit is signed + '
          'in the success colour and a debit - in ink; the app passes the '
          'amounts unsigned and formatted. Rendering runs off the main '
          'isolate, so a period of thousands of transactions does not stall '
          'the interface: slide Transactions up to try one. With no '
          'transactions the table carries the empty-period line instead.',
      code:
          '''
final exporter = GtPdfStatementExporter.fromPalette($paletteCode);

const data = GtPdfStatementData(
  title: "Savings Account Statement",
  period: "$_period",
  holder: GtPdfStatementHolder(
    name: "Alex Lobaloba",
    address: ["210 Sanusi Street", "Surulere, Lagos"],
  ),
  details: [
    GtPdfReceiptEntry(label: "Account Number", value: "0123456789"),
  ],
  summary: [
    GtPdfStatementSummaryRow(
      product: "Savings Account",
      accountNumber: "0123456789",
      openingBalance: "₦1,200,000,000",
      totalOutgoings: "₦19,000,123",
      totalDeposits: "₦19,000,123",
      closingBalance: "₦19,000,123",
    ),
  ],
  transactions: [
    GtPdfStatementTransaction(
      date: "01/03/2026",
      title: "Payment from Francis Lobaloba",
      details: ["Transaction ID: TRX24072983910527NG"],
      amount: "₦1,000,000",
      isCredit: true,
      balance: "₦1,200,000,000",
    ),
  ],${knobs.showFooter ? '''
  footer: GtPdfStatementFooter(
    title: "Sterling Bank Address",
    address: ["Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria"],
    contactLines: ["customercare@sterling.ng"],${knobs.showQr ? '''
    qrData: "https://sterling.ng/statements/...",''' : ''}
    copyright: "© 2026 Sterling Bank",
  ),''' : ''}
);

await exporter.share(context, data);''',
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (knobs.showPreview) ...[
            GalleryPdfPreview(
              render: () => exporter.render(data),
              cacheKey: (knobs.previewKey, palette),
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
