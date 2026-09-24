import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtPdfInvoiceExporter', type: GtPdfInvoiceExporter)
Widget playgroundGtPdfInvoiceExporterUseCase(BuildContext context) {
  return const _PdfInvoiceExportPreview();
}

const _poweredBySvg =
    '<svg fill="none" height="14" viewBox="0 0 14 14" width="14" '
    'xmlns="http://www.w3.org/2000/svg"><rect fill="#d92128" height="14" '
    'rx="7" width="14"/><circle cx="8.75" cy="4.66528" fill="#fff" '
    'r="1.75"/></svg>';

const _billedTo = GtPdfInvoiceParty(
  name: 'Yahya Bello',
  address: ['48, York Crescent, Maitama', '20234, Abuja, Nigeria'],
  details: ['yahya@belloentreprises.com'],
);

const _from = GtPdfInvoiceParty(
  name: 'Funmilola Joseph',
  address: ['93B Fola Osibo Street,', '10235, Lagos, Nigeria'],
  details: ['TIN 12345678-0004'],
);

const _account = GtPdfInvoiceAccount(
  name: 'Funmilola Joseph',
  number: '9963974558',
  bank: 'Sterling Bank PLC',
);

class _PdfInvoiceKnobs {
  final String number;
  final bool isPaid;
  final int itemCount;
  final bool withTaxRate;
  final bool showAvatar;
  final bool showPayment;
  final bool showPoweredBy;
  final bool themeFromPalette;
  final bool showPreview;

  const _PdfInvoiceKnobs({
    required this.number,
    required this.isPaid,
    required this.itemCount,
    required this.withTaxRate,
    required this.showAvatar,
    required this.showPayment,
    required this.showPoweredBy,
    required this.themeFromPalette,
    required this.showPreview,
  });

  factory _PdfInvoiceKnobs.of(BuildContext context) {
    return _PdfInvoiceKnobs(
      number: context.knobs.string(
        label: 'Invoice Number',
        initialValue: 'INV-001',
      ),
      isPaid: context.knobs.boolean(label: 'Paid', initialValue: false),
      itemCount: context.knobs.int.slider(
        label: 'Items',
        initialValue: 1,
        min: 1,
        max: 40,
      ),
      withTaxRate: context.knobs.boolean(
        label: 'With Tax Rate',
        initialValue: false,
      ),
      showAvatar: context.knobs.boolean(
        label: 'Show Avatar',
        initialValue: true,
      ),
      showPayment: context.knobs.boolean(
        label: 'Show Payment Block',
        initialValue: true,
      ),
      showPoweredBy: context.knobs.boolean(
        label: 'Show Powered By',
        initialValue: true,
      ),
      themeFromPalette: context.knobs.boolean(
        label: 'Theme From App Palette',
        initialValue: true,
      ),
      showPreview: context.knobs.boolean(
        label: 'Show Preview',
        initialValue: true,
      ),
    );
  }

  GtPdfInvoiceData buildData(GtPalette palette, {Uint8List? avatar}) {
    final items = [
      for (var line = 0; line < itemCount; line++)
        GtPdfInvoiceItem(
          description: line == 0 ? 'Design' : 'Brand guideline $line',
          price: 'NGN 300,000',
          quantity: '1',
          taxRate: withTaxRate && line.isEven ? '7.5%' : null,
          amount: 'NGN 300,000',
        ),
    ];

    return GtPdfInvoiceData(
      number: number,
      status: GtPdfInvoiceStatus.fromVariant(
        label: isPaid ? 'Paid' : 'Pending',
        variant: isPaid ? .success : .away,
        palette: palette,
      ),
      avatar: showAvatar ? avatar : null,
      details: [
        const GtPdfReceiptEntry(
          label: 'Issued on:',
          value: 'December 15, 2025',
        ),
        GtPdfReceiptEntry(
          label: isPaid ? 'Paid on:' : 'Due date:',
          value: 'December 25, 2025',
        ),
      ],
      billedTo: _billedTo,
      from: _from,
      account: _account,
      items: items,
      subtotal: 'NGN 300,000',
      adjustments: [
        if (withTaxRate)
          const GtPdfReceiptEntry(label: 'Tax', value: 'NGN 22,500'),
      ],
      total: withTaxRate ? 'NGN 322,500.00' : 'NGN 300,000.00',
      payment: showPayment
          ? GtPdfInvoicePayment(url: 'https://pay.sterling.ng/$number')
          : null,
      poweredBy: showPoweredBy
          ? const GtPdfInvoicePoweredBy(svg: _poweredBySvg, height: 27)
          : null,
    );
  }

  GtPdfInvoiceExporter buildExporter(BuildContext context) {
    if (!themeFromPalette) return const GtPdfInvoiceExporter();
    return GtPdfInvoiceExporter.fromPalette(context.palette);
  }

  Object get previewKey => (
    number,
    isPaid,
    itemCount,
    withTaxRate,
    showAvatar,
    showPayment,
    showPoweredBy,
    themeFromPalette,
  );
}

class _PdfInvoiceExportPreview extends StatefulWidget {
  const _PdfInvoiceExportPreview();

  @override
  State<_PdfInvoiceExportPreview> createState() =>
      _PdfInvoiceExportPreviewState();
}

class _PdfInvoiceExportPreviewState extends State<_PdfInvoiceExportPreview> {
  bool _busy = false;

  Future<Uint8List> _avatar() async {
    final data = await rootBundle.load(GtAssetImages.avatar);
    return data.buffer.asUint8List();
  }

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
    GtPdfInvoiceExporter exporter,
    Future<GtPdfInvoiceData> Function() data,
  ) {
    return _run(() async {
      final invoice = await data();
      if (!mounted) return '';
      await exporter.share(context, invoice);
      return "Shared ${invoice.resolvedFileName}";
    });
  }

  Future<void> _download(
    GtPdfInvoiceExporter exporter,
    Future<GtPdfInvoiceData> Function() data,
  ) {
    return _run(() async {
      final invoice = await data();
      final result = await exporter.save(invoice);
      if (result.hasError) return "Download cancelled or unavailable";
      return "Downloaded ${invoice.resolvedFileName}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final knobs = _PdfInvoiceKnobs.of(context);
    final palette = context.palette;
    final exporter = knobs.buildExporter(context);

    Future<GtPdfInvoiceData> data() async {
      final avatar = knobs.showAvatar ? await _avatar() : null;
      return knobs.buildData(palette, avatar: avatar);
    }

    return GtWidgetDocPage(
      title: 'GtPdfInvoiceExporter',
      description:
          'Builds a printable PDF invoice from GtPdfInvoiceData and hands it '
          'to the device, the way GtPdfReceiptExporter does for receipts. '
          'The status pill takes its colours from a GtPillVariant, the '
          'avatar and powered-by mark are supplied by the app, and every '
          'amount is printed exactly as the app formatted it. The tax rate '
          'column only appears when an item carries a rate, and a long items '
          'table breaks between rows onto further pages.',
      code:
          '''
final exporter = GtPdfInvoiceExporter.fromPalette(context.palette);

final data = GtPdfInvoiceData(
  number: "${knobs.number}",
  status: GtPdfInvoiceStatus.fromVariant(
    label: "${knobs.isPaid ? 'Paid' : 'Pending'}",
    variant: ${knobs.isPaid ? '.success' : '.away'},
    palette: context.palette,
  ),
  avatar: avatarBytes,
  details: const [
    GtPdfReceiptEntry(label: "Issued on:", value: "December 15, 2025"),
    GtPdfReceiptEntry(label: "${knobs.isPaid ? 'Paid on:' : 'Due date:'}", value: "December 25, 2025"),
  ],
  billedTo: const GtPdfInvoiceParty(
    name: "Yahya Bello",
    address: ["48, York Crescent, Maitama", "20234, Abuja, Nigeria"],
    details: ["yahya@belloentreprises.com"],
  ),
  from: const GtPdfInvoiceParty(name: "Funmilola Joseph"),
  account: const GtPdfInvoiceAccount(
    name: "Funmilola Joseph",
    number: "9963974558",
    bank: "Sterling Bank PLC",
  ),
  items: const [
    GtPdfInvoiceItem(
      description: "Design",
      price: "NGN 300,000",
      quantity: "1",${knobs.withTaxRate ? '''
      taxRate: "7.5%",''' : ''}
      amount: "NGN 300,000",
    ),
  ],
  subtotal: "NGN 300,000",
  total: "NGN 300,000.00",${knobs.showPayment ? '''
  payment: const GtPdfInvoicePayment(url: "https://pay.sterling.ng/..."),''' : ''}${knobs.showPoweredBy ? '''
  poweredBy: GtPdfInvoicePoweredBy(svg: brandSvg),''' : ''}
);

await exporter.share(context, data);''',
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (knobs.showPreview) ...[
            GalleryPdfPreview(
              render: () async => exporter.render(await data()),
              cacheKey: (knobs.previewKey, palette),
              height: 800,
              fileName: '${knobs.number}.pdf',
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
