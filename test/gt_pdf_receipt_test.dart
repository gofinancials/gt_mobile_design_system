import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  const data = GtPdfReceiptData(
    title: 'Transfer Confirmation',
    issuedOn: '03.10.2025',
    issuedOnLabel: 'Issued on:',
    sections: [
      GtPdfReceiptSection(
        title: 'Transfer Details',
        entries: [
          GtPdfReceiptEntry(
            label: 'Transfer Type',
            value: 'Instant bank transfer',
          ),
          GtPdfReceiptEntry(label: 'Amount', value: '20,000.00 NGN'),
          GtPdfReceiptEntry(label: 'Message', value: 'House cleaning'),
        ],
      ),
      GtPdfReceiptSection(
        title: 'Sender Details',
        heading: 'OLALEKAN OMOLUABI',
        entries: [
          GtPdfReceiptEntry(label: 'Account number', value: '******5678'),
          GtPdfReceiptEntry(label: 'Bank Name', value: 'STERLING BANK'),
        ],
      ),
    ],
    footer: GtPdfReceiptFooter(
      title: 'Sterling Bank Address',
      address: 'Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria',
      contactLines: ['customercare@sterling.ng', '02018888822'],
      qrData: 'https://sterling.ng/receipts/81a0cf3b',
      disclaimer: 'Your transfer has been processed successfully.',
      note: 'Please reach out to support for more information.',
    ),
  );

  /// The receipt from the design spec: three sections and a full footer.
  ///
  /// The layout is tuned so a receipt of this shape lands on a single page, so
  /// this doubles as the fixture guarding that.
  const reference = GtPdfReceiptData(
    title: 'Transfer Confirmation',
    issuedOn: '03.10.2025',
    issuedOnLabel: 'Issued on:',
    sections: [
      GtPdfReceiptSection(
        title: 'Transfer Details',
        entries: [
          GtPdfReceiptEntry(
            label: 'Transfer Type',
            value: 'Instant bank transfer',
          ),
          GtPdfReceiptEntry(label: 'Amount', value: '20,000.00 NGN'),
          GtPdfReceiptEntry(
            label: 'Session ID/Reference',
            value: '81a0cf3b-cb71-49f8-9696-c68e9f747671',
          ),
          GtPdfReceiptEntry(label: 'Transfer Date', value: '30.09.2025'),
          GtPdfReceiptEntry(
            label: 'Message',
            value: 'House cleaning part payment',
          ),
          GtPdfReceiptEntry(label: 'Fee', value: '0.00 NGN'),
        ],
      ),
      GtPdfReceiptSection(
        title: 'Sender Details',
        heading: 'OLALEKAN OMOLUABI',
        entries: [
          GtPdfReceiptEntry(label: 'Account number', value: '******5678'),
          GtPdfReceiptEntry(label: 'Bank Name', value: 'STERLING BANK'),
        ],
      ),
      GtPdfReceiptSection(
        title: 'Recipient Details',
        heading: 'KENNETH OSMOSIS',
        entries: [
          GtPdfReceiptEntry(label: 'Account number', value: '9012345678'),
          GtPdfReceiptEntry(label: 'Bank Name', value: 'KUDA BANK LIMITED'),
        ],
      ),
    ],
    footer: GtPdfReceiptFooter(
      title: 'Sterling Bank Address',
      address: 'Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria',
      contactLines: ['customercare@sterling.ng', '02018888822, 07008220000'],
      qrData: 'https://sterling.ng/receipts/81a0cf3b-cb71-49f8-9696',
      disclaimer:
          'Your transfer has been processed successfully and will be '
          'delivered. However, there may be interruptions or delays from '
          'third party services. Sterling Bank is therefore not liable for '
          'any failures not within our control. All transactions are also '
          'subject to verification and fraud checks.',
      note: 'Please reach out to support for more information.',
    ),
  );

  /// A PDF file always opens with the `%PDF-` header.
  bool looksLikePdf(Uint8List bytes) {
    return ascii.decode(bytes.sublist(0, 5)) == '%PDF-';
  }

  group('GtPdfReceiptData', () {
    test('derives a slugged file name from the title', () {
      expect(data.resolvedFileName, 'transfer_confirmation.pdf');
    });

    test('prefers an explicit file name and suffixes it once', () {
      const named = GtPdfReceiptData(
        title: 'Transfer Confirmation',
        fileName: 'receipt-1234.pdf',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(named.resolvedFileName, 'receipt-1234.pdf');
    });

    test('falls back to a usable file name for an unsluggable title', () {
      const symbols = GtPdfReceiptData(
        title: '***',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(symbols.resolvedFileName, 'receipt.pdf');
    });

    test('resolves the section layout from the presence of a heading', () {
      expect(
        data.sections.first.resolvedLayout,
        GtPdfReceiptSectionLayout.grid,
      );
      expect(
        data.sections.last.resolvedLayout,
        GtPdfReceiptSectionLayout.split,
      );
    });

    test('maps confirmation sections onto PDF sections', () {
      final section = GtPdfReceiptSection.fromConfirmation(
        const GtConfirmationSection(
          title: 'Account Details',
          tiles: [
            GtReceiptTileData(label: 'Name', value: 'OLOWOFALA ALAO'),
            GtReceiptTileData(label: 'Account Number', value: '3910527NGN'),
          ],
        ),
      );

      expect(section.title, 'Account Details');
      expect(section.entries, [
        const GtPdfReceiptEntry(label: 'Name', value: 'OLOWOFALA ALAO'),
        const GtPdfReceiptEntry(label: 'Account Number', value: '3910527NGN'),
      ]);
    });

    test('reports whether a footer carries anything worth rendering', () {
      expect(data.footer?.hasContent, isTrue);
      expect(data.footer?.hasQr, isTrue);
      expect(const GtPdfReceiptFooter().hasContent, isFalse);
      expect(const GtPdfReceiptFooter(note: 'Note').hasQr, isFalse);
    });
  });

  group('GtPdfReceiptBuilder', () {
    test('renders a receipt to PDF bytes', () async {
      const builder = GtPdfReceiptBuilder();

      final bytes = await builder.render(data);

      expect(bytes, isNotEmpty);
      expect(looksLikePdf(bytes), isTrue);
    });

    test('renders a receipt carrying only the required content', () async {
      const minimal = GtPdfReceiptData(
        title: 'Receipt',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      final bytes = await const GtPdfReceiptBuilder().render(minimal);

      expect(looksLikePdf(bytes), isTrue);
    });

    test('lays the reference receipt out on a single page', () async {
      final document = const GtPdfReceiptBuilder().build(reference);
      await document.save();

      expect(document.document.pdfPageList.pages, hasLength(1));
    });

    test('keeps headroom beneath the single-page budget', () async {
      // A full grid row past the reference receipt — two entries across the
      // two columns — still fits, so the layout is not scraping the page
      // boundary. That row is the whole of the margin: a third entry starts
      // the next row and spills onto a second page.
      final padded = GtPdfReceiptData(
        title: reference.title,
        issuedOn: reference.issuedOn,
        issuedOnLabel: reference.issuedOnLabel,
        footer: reference.footer,
        sections: [
          GtPdfReceiptSection(
            title: reference.sections.first.title,
            entries: [
              ...reference.sections.first.entries,
              for (var extra = 0; extra < 2; extra++)
                GtPdfReceiptEntry(label: 'Extra $extra', value: 'Value $extra'),
            ],
          ),
          ...reference.sections.skip(1),
        ],
      );

      final document = const GtPdfReceiptBuilder().build(padded);
      await document.save();

      expect(document.document.pdfPageList.pages, hasLength(1));
    });

    test('paginates a receipt too long for a single page', () async {
      final long = GtPdfReceiptData(
        title: 'Statement',
        sections: [
          for (var section = 0; section < 12; section++)
            GtPdfReceiptSection(
              title: 'Section $section',
              entries: [
                for (var entry = 0; entry < 8; entry++)
                  GtPdfReceiptEntry(
                    label: 'Label $entry',
                    value: 'Value $entry',
                  ),
              ],
            ),
        ],
      );

      final document = const GtPdfReceiptBuilder().build(long);
      await document.save();

      expect(document.document.pdfPageList.pages.length, greaterThan(1));
    });

    test('renders against a custom theme', () async {
      final builder = GtPdfReceiptBuilder(
        theme: const GtPdfReceiptTheme.light().copyWith(
          pageFormat: PdfPageFormat.letter,
          brand: PdfColors.blue,
        ),
      );

      final bytes = await builder.render(data);

      expect(looksLikePdf(bytes), isTrue);
    });

    test('asserts that a receipt has at least one section', () {
      const empty = GtPdfReceiptData(title: 'Receipt', sections: []);

      expect(
        () => const GtPdfReceiptBuilder().build(empty),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts that a grid section has at least one column', () {
      const zeroColumns = GtPdfReceiptData(
        title: 'Receipt',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            columns: 0,
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(
        () => const GtPdfReceiptBuilder().build(zeroColumns),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('GtPdfReceiptTheme', () {
    test('converts design system colours into PDF colours', () {
      expect(
        gtPdfColorOf(const Color(0xFFCB0828)),
        const PdfColor.fromInt(0xFFCB0828),
      );
    });

    test('inherits the package default font family', () {
      const theme = GtPdfReceiptTheme.light();
      final base = pw.ThemeData.base();

      // No typeface is specified anywhere, so text falls through to the
      // package default rather than to an app font.
      expect(
        theme.pdfTheme.defaultTextStyle.font?.fontName,
        base.defaultTextStyle.font?.fontName,
      );
      expect(theme.titleStyle.font, isNull);
      expect(theme.valueStyle.font, isNull);
    });

    test('overrides only size and colour on the default text style', () {
      const theme = GtPdfReceiptTheme.light();

      expect(theme.pdfTheme.defaultTextStyle.fontSize, theme.valueSize);
      expect(theme.pdfTheme.defaultTextStyle.color, theme.textSub);
    });

    test('keeps unspecified fields when copied', () {
      const theme = GtPdfReceiptTheme.light();

      final copy = theme.copyWith(titleSize: 30);

      expect(copy.titleSize, 30);
      expect(copy.brand, theme.brand);
      expect(copy.pageFormat, theme.pageFormat);
    });
  });
}
