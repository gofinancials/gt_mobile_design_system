import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/pdf.dart';

void main() {
  const item = GtPdfInvoiceItem(
    description: 'Design',
    price: '₦300,000',
    quantity: '1',
    amount: '₦300,000',
  );

  /// The invoice from the design spec, which lands on a single page.
  const reference = GtPdfInvoiceData(
    number: 'INV-7',
    status: GtPdfInvoiceStatus(
      label: 'Pending',
      textColor: PdfColor.fromInt(0xFFE6A819),
      backgroundColor: PdfColor.fromInt(0xFFFFFAEB),
      borderColor: PdfColor.fromInt(0xFFFFECC0),
    ),
    details: [
      GtPdfReceiptEntry(label: 'Issued on:', value: 'November 19, 2025'),
      GtPdfReceiptEntry(label: 'Due date:', value: 'November 26, 2025'),
    ],
    billedTo: GtPdfInvoiceParty(
      name: 'Yahya Bello',
      address: ['48, York Crescent, Maitama', '20234, Abuja, Nigeria'],
      details: ['yahya@belloentreprises.com'],
    ),
    from: GtPdfInvoiceParty(
      name: 'Funmilola Joseph',
      address: ['93B Fola Osibo Street,', '10235, Lagos, Nigeria'],
      details: ['TIN 12345678-0004'],
    ),
    account: GtPdfInvoiceAccount(
      name: 'Funmilola Joseph',
      number: '9963974558',
      bank: 'Sterling Bank PLC',
    ),
    items: [item],
    subtotal: '₦300,000',
    total: '₦300,000.00',
    payment: GtPdfInvoicePayment(url: 'https://pay.sterling.ng/inv-7'),
    poweredBy: GtPdfInvoicePoweredBy(
      svg:
          '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14">'
          '<circle cx="7" cy="7" r="7" fill="#d92128"/></svg>',
    ),
  );

  /// A PDF file always opens with the `%PDF-` header.
  bool looksLikePdf(Uint8List bytes) {
    return ascii.decode(bytes.sublist(0, 5)) == '%PDF-';
  }

  group('GtPdfInvoiceData', () {
    test('derives a slugged file name from the invoice number', () {
      expect(reference.resolvedFileName, 'INV-7.pdf');
    });

    test('prefers an explicit file name', () {
      const named = GtPdfInvoiceData(
        number: 'INV-7',
        billedTo: GtPdfInvoiceParty(name: 'Yahya Bello'),
        from: GtPdfInvoiceParty(name: 'Funmilola Joseph'),
        items: [item],
        total: '1.00',
        fileName: 'Invoice INV-7 — Bello',
      );

      expect(named.resolvedFileName, 'Invoice_INV-7_Bello.pdf');
    });

    test('falls back to a usable file name for an unsluggable one', () {
      const symbols = GtPdfInvoiceData(
        number: '***',
        billedTo: GtPdfInvoiceParty(name: 'Yahya Bello'),
        from: GtPdfInvoiceParty(name: 'Funmilola Joseph'),
        items: [item],
        total: '1.00',
      );

      expect(symbols.resolvedFileName, 'invoice.pdf');
    });

    test('titles the document after the invoice number', () {
      expect(reference.title, 'Invoice INV-7');
    });

    test('has a tax rate column only when an item carries a rate', () {
      expect(reference.hasTaxRate, isFalse);

      const taxed = GtPdfInvoiceData(
        number: 'INV-8',
        billedTo: GtPdfInvoiceParty(name: 'Yahya Bello'),
        from: GtPdfInvoiceParty(name: 'Funmilola Joseph'),
        items: [
          item,
          GtPdfInvoiceItem(
            description: 'Printing',
            price: '₦1,000',
            quantity: '2',
            taxRate: '7.5%',
            amount: '₦2,150',
          ),
        ],
        total: '₦302,150',
      );

      expect(taxed.hasTaxRate, isTrue);
    });
  });

  group('GtPdfInvoiceStatus', () {
    final palette = FlexLightPalette();

    test('colours a pending state as the receipt pill does', () {
      final status = GtPdfInvoiceStatus.fromVariant(
        label: 'Pending',
        variant: .away,
        palette: palette,
      );

      expect(status.textColor, gtPdfColorOf(palette.away.base));
      expect(status.borderColor, gtPdfColorOf(palette.away.light));
      expect(status.backgroundColor, gtPdfColorOf(palette.away.lighter));
    });

    test('colours any other state from its pill variant', () {
      final status = GtPdfInvoiceStatus.fromVariant(
        label: 'Paid',
        variant: .success,
        palette: palette,
      );

      expect(status.textColor, gtPdfColorOf(palette.success.dark));
      expect(status.borderColor, gtPdfColorOf(palette.success.light));
      expect(status.backgroundColor, gtPdfColorOf(palette.success.lighter));
    });
  });

  group('GtPdfInvoiceBuilder', () {
    test('renders the reference invoice to a PDF', () async {
      final bytes = await const GtPdfInvoiceBuilder().render(reference);

      expect(looksLikePdf(bytes), isTrue);
    });

    test('renders an invoice carrying only what it requires', () async {
      const minimal = GtPdfInvoiceData(
        number: 'INV-9',
        billedTo: GtPdfInvoiceParty(name: 'Yahya Bello'),
        from: GtPdfInvoiceParty(name: 'Funmilola Joseph'),
        items: [item],
        total: '₦300,000',
        adjustments: [GtPdfReceiptEntry(label: 'Tax', value: '')],
      );

      final bytes = await const GtPdfInvoiceBuilder().render(minimal);

      expect(looksLikePdf(bytes), isTrue);
    });

    test('lays the reference invoice out on a single page', () async {
      final document = const GtPdfInvoiceBuilder().build(reference);
      await document.save();

      expect(document.document.pdfPageList.pages, hasLength(1));
    });

    test('breaks a long items table across pages', () async {
      final long = GtPdfInvoiceData(
        number: reference.number,
        billedTo: reference.billedTo,
        from: reference.from,
        items: [
          for (var line = 0; line < 40; line++)
            GtPdfInvoiceItem(
              description: 'Line $line',
              price: '₦1,000',
              quantity: '1',
              taxRate: line.isEven ? '7.5%' : null,
              amount: '₦1,000',
            ),
        ],
        total: '₦40,000',
        payment: reference.payment,
        poweredBy: reference.poweredBy,
      );

      final document = const GtPdfInvoiceBuilder().build(long);
      await document.save();

      expect(document.document.pdfPageList.pages.length, greaterThan(1));
    });

    test('themes from the live palette', () async {
      final exporter = GtPdfInvoiceExporter.fromPalette(FlexLightPalette());

      expect(
        exporter.builder.theme.brand,
        gtPdfColorOf(FlexLightPalette().primary.base),
      );
      expect(looksLikePdf(await exporter.render(reference)), isTrue);
    });
  });
}
