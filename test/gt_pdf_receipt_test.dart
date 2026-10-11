import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GtPdfTypeface typeface;

  setUpAll(() async {
    typeface = await GtPdfTypeface.load();
  });

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
      expect(data.resolvedFileName, 'Transfer_Confirmation.pdf');
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

    test('slugs a supplied file name the same way as a derived one', () {
      const supplied = GtPdfReceiptData(
        title: 'Transfer Confirmation',
        fileName: '  Ref 81a0cf3b/9696 \u2014 Caf\u00e9  ',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(supplied.resolvedFileName, 'Ref_81a0cf3b_9696_Caf.pdf');
    });

    test('keeps the case and hyphens of a supplied reference', () {
      const reference = GtPdfReceiptData(
        title: 'Transfer Confirmation',
        fileName: 'transaction_TXN-2026-08-21',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(reference.resolvedFileName, 'transaction_TXN-2026-08-21.pdf');
    });

    test('drops a separator left at either edge of a supplied name', () {
      const edged = GtPdfReceiptData(
        title: 'Transfer Confirmation',
        fileName: '..-Ref.',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(edged.resolvedFileName, 'Ref.pdf');
    });

    test('falls back to a usable file name for a separator-only one', () {
      const dot = GtPdfReceiptData(
        title: 'Transfer Confirmation',
        fileName: '.',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(dot.resolvedFileName, 'receipt.pdf');
    });

    test('falls back to a usable file name for an unsluggable one', () {
      const symbols = GtPdfReceiptData(
        title: 'Transfer Confirmation',
        fileName: '***',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [GtPdfReceiptEntry(label: 'Amount', value: '1.00')],
          ),
        ],
      );

      expect(symbols.resolvedFileName, 'receipt.pdf');
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
      final sections = data.sections.whereType<GtPdfReceiptSection>();

      expect(sections.first.resolvedLayout, GtPdfReceiptSectionLayout.grid);
      expect(sections.last.resolvedLayout, GtPdfReceiptSectionLayout.split);
    });

    test('compares prose by its title, heading and paragraphs', () {
      const prose = GtPdfReceiptProse(
        heading: '1. Overdraft Facility',
        paragraphs: ['1.1 The Overdraft allows you to spend.'],
      );

      expect(
        prose,
        const GtPdfReceiptProse(
          heading: '1. Overdraft Facility',
          paragraphs: ['1.1 The Overdraft allows you to spend.'],
        ),
      );
      expect(
        prose,
        isNot(
          const GtPdfReceiptProse(
            title: 'Terms',
            heading: '1. Overdraft Facility',
            paragraphs: ['1.1 The Overdraft allows you to spend.'],
          ),
        ),
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

    test('sets a rendered receipt in Open Runde', () async {
      final bytes = await const GtPdfReceiptBuilder().render(data);
      final source = latin1.decode(bytes);

      expect(source, contains('/BaseFont/OpenRunde-Medium'));
      expect(source, contains('/BaseFont/OpenRunde-Semibold'));
      expect(source, isNot(contains('/BaseFont/Helvetica')));
    });

    test(
      'falls back to the package default family without a typeface',
      () async {
        final bytes = await const GtPdfReceiptBuilder().build(data).save();
        final source = latin1.decode(bytes);

        expect(source, contains('/BaseFont/Helvetica'));
        expect(source, isNot(contains('OpenRunde')));
      },
    );

    test('renders a receipt carrying characters the font cannot set', () async {
      const unsettable = GtPdfReceiptData(
        title: 'Transfer Confirmation \u2014 \u201cRent\u201d',
        sections: [
          GtPdfReceiptSection(
            title: 'Details',
            entries: [
              GtPdfReceiptEntry(label: 'Amount', value: '\u20a620,000.00'),
              GtPdfReceiptEntry(
                label: 'Message',
                value: 'Rent \u2013 flat 3\u2026',
              ),
            ],
          ),
        ],
      );

      final bytes = await const GtPdfReceiptBuilder().render(unsettable);

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
      final document = const GtPdfReceiptBuilder().build(
        reference,
        typeface: typeface,
      );
      await document.save();

      expect(document.document.pdfPageList.pages, hasLength(1));
    });

    test('keeps headroom beneath the single-page budget', () async {
      // Two full grid rows past the reference receipt — four entries across
      // the two columns — still fit, so the layout is not scraping the page
      // boundary. Those rows are the whole of the margin: a fifth entry
      // starts the next row and spills onto a second page.
      final details = reference.sections.first as GtPdfReceiptSection;
      final padded = GtPdfReceiptData(
        title: reference.title,
        issuedOn: reference.issuedOn,
        issuedOnLabel: reference.issuedOnLabel,
        footer: reference.footer,
        sections: [
          GtPdfReceiptSection(
            title: details.title,
            entries: [
              ...details.entries,
              for (var extra = 0; extra < 4; extra++)
                GtPdfReceiptEntry(label: 'Extra $extra', value: 'Value $extra'),
            ],
          ),
          ...reference.sections.skip(1),
        ],
      );

      final document = const GtPdfReceiptBuilder().build(
        padded,
        typeface: typeface,
      );
      await document.save();

      expect(document.document.pdfPageList.pages, hasLength(1));
    });

    test('lays a ten-entry bill receipt out on a single page', () async {
      // The last section used to close with the gap that separates a section
      // from the next hairline. A receipt ending within that gap of the footer
      // opened a second page holding nothing but the repeated footer.
      final bill = GtPdfReceiptData(
        title: 'Bill Payment Receipt',
        issuedOn: '10.10.2026',
        issuedOnLabel: 'Issued on:',
        footer: reference.footer,
        sections: const [
          GtPdfReceiptSection(
            title: 'Transaction Details',
            entries: [
              GtPdfReceiptEntry(label: 'Amount', value: '\u20a610,000.00'),
              GtPdfReceiptEntry(
                label: 'Transaction Date',
                value: '10.10.2026, 09:41',
              ),
              GtPdfReceiptEntry(label: 'Status', value: 'Successful'),
              GtPdfReceiptEntry(
                label: 'Transaction Type',
                value: 'Electricity bill',
              ),
              GtPdfReceiptEntry(
                label: 'Message',
                value: 'Prepaid electricity top-up',
              ),
              GtPdfReceiptEntry(
                label: 'Reference',
                value: 'BIL-20261010-7F3A92C1',
              ),
              GtPdfReceiptEntry(
                label: 'Token',
                value: '4821-0937-5562-1048-7735',
              ),
              GtPdfReceiptEntry(label: 'Token Units', value: '68.4 kWh'),
              GtPdfReceiptEntry(
                label: 'Session ID',
                value: '000013261010094112345678901234',
              ),
              GtPdfReceiptEntry(label: 'Fee', value: '\u20a6100.00'),
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
            heading: 'IKEJA ELECTRIC',
            entries: [
              GtPdfReceiptEntry(label: 'Meter Number', value: '45012345678'),
              GtPdfReceiptEntry(label: 'Biller', value: 'IKEJA ELECTRIC DISCO'),
            ],
          ),
        ],
      );

      final document = const GtPdfReceiptBuilder().build(
        bill,
        typeface: typeface,
      );
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

      final document = const GtPdfReceiptBuilder().build(
        long,
        typeface: typeface,
      );
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

    test('renders an agreement mixing entries and running text', () async {
      const agreement = GtPdfReceiptData(
        title: 'Overdraft Agreement',
        issuedOn: '10.10.2026',
        issuedOnLabel: 'Issued on:',
        sections: [
          GtPdfReceiptSection(
            title: 'Facility Details',
            entries: [
              GtPdfReceiptEntry(label: 'Limit', value: '\u20a6500,000.00'),
              GtPdfReceiptEntry(label: 'Tenor', value: '30 days'),
            ],
          ),
          GtPdfReceiptProse(
            title: 'Agreement',
            paragraphs: [
              'Dear Olalekan,',
              'This Overdraft Agreement sets out the terms of your facility.',
            ],
          ),
          GtPdfReceiptProse(
            heading: '1. Overdraft Facility',
            paragraphs: ['1.1 The Overdraft allows you to spend.'],
          ),
        ],
      );

      final bytes = await const GtPdfReceiptBuilder().render(agreement);

      expect(looksLikePdf(bytes), isTrue);
    });

    test('breaks running text across pages', () async {
      const clause =
          'The Overdraft allows you to spend or transact beyond your '
          'available balance, up to the approved limit, subject to the terms '
          'of this Agreement. Interest accrues daily on the outstanding '
          'balance and is charged monthly to your account.';
      final agreement = GtPdfReceiptData(
        title: 'Overdraft Agreement',
        sections: [
          for (var index = 1; index <= 9; index++)
            GtPdfReceiptProse(
              heading: '$index. Clause',
              paragraphs: ['$index.1 $clause', '$index.2 $clause $clause'],
            ),
          // A single paragraph longer than a page must split, not throw.
          GtPdfReceiptProse(paragraphs: [List.filled(60, clause).join(' ')]),
        ],
      );

      final document = const GtPdfReceiptBuilder().build(
        agreement,
        typeface: typeface,
      );
      await document.save();

      expect(document.document.pdfPageList.pages.length, greaterThan(2));
    });

    test('asserts that running text has at least one paragraph', () {
      const empty = GtPdfReceiptData(
        title: 'Agreement',
        sections: [GtPdfReceiptProse(heading: 'Terms', paragraphs: [])],
      );

      expect(
        () => const GtPdfReceiptBuilder().build(empty),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('gtPdfSafeText', () {
    test('leaves text the font can already set alone', () {
      expect(
        gtPdfSafeText('Instant bank transfer - 20,000.00 NGN'),
        'Instant bank transfer - 20,000.00 NGN',
      );
      expect(gtPdfSafeText(''), '');
    });

    test('normalises a currency glyph to its code, spaced off the figure', () {
      expect(gtPdfSafeText('\u20a620,000.00'), 'NGN 20,000.00');
      expect(gtPdfSafeText('20,000.00\u20a6'), '20,000.00 NGN');
      expect(gtPdfSafeText('\u20a6 20,000.00'), 'NGN 20,000.00');
      expect(gtPdfSafeText('(\u20a620,000.00)'), '(NGN 20,000.00)');
      expect(gtPdfSafeText('\u00a31,000.00'), 'GBP 1,000.00');
      expect(gtPdfSafeText(r'$1,000.00'), 'USD 1,000.00');
      expect(gtPdfSafeText('\u20ac1,000.00'), 'EUR 1,000.00');
    });

    test('leaves the yen glyph alone, since it denotes two currencies', () {
      expect(gtPdfSafeText('\u00a51,000'), '\u00a51,000');
      expect(gtPdfSafeText('\uffe51,000'), '\u00a51,000');
    });

    test('transliterates the typographic characters a paste carries', () {
      expect(
        gtPdfSafeText(
          '\u201cRent\u201d \u2014 flat\u00a03, \u2018paid\u2019\u2026',
        ),
        '"Rent" - flat 3, \'paid\'...',
      );
      expect(gtPdfSafeText('\u2022 First\n\u2022 Second'), '- First\n- Second');
      expect(gtPdfSafeText('Sterling\u2122'), 'Sterling(TM)');
      expect(gtPdfSafeText('soft\u00adhyphen\u200bjoin'), 'softhyphenjoin');
    });

    test('replaces anything the font still cannot set', () {
      expect(gtPdfSafeText('\u0915\u0941\u0926\u093e'), '????');
      expect(gtPdfSafeText('Caf\u00e9 \u5143'), 'Caf\u00e9 ?');
    });
  });

  group('GtPdfReceiptTheme', () {
    test('converts design system colours into PDF colours', () {
      expect(
        gtPdfColorOf(const Color(0xFFCB0828)),
        const PdfColor.fromInt(0xFFCB0828),
      );
    });

    test('sets copy in the medium face and bold text in the semibold', () {
      const theme = GtPdfReceiptTheme.light();
      final style = theme.pdfTheme(typeface).defaultTextStyle;

      expect(style.fontNormal, typeface.medium);
      expect(style.fontBold, typeface.semibold);
      expect(
        style.copyWith(fontWeight: pw.FontWeight.bold).font,
        typeface.semibold,
      );
    });

    test('falls back to the package default family without a typeface', () {
      const theme = GtPdfReceiptTheme.light();
      final style = theme.pdfTheme().defaultTextStyle;

      expect(style.font?.fontName, pw.Font.helvetica().fontName);
      expect(style.fontBold?.fontName, pw.Font.helveticaBold().fontName);
    });

    test('leaves the face to the document theme', () {
      const theme = GtPdfReceiptTheme.light();

      // Styles carry weight, never a face, so they follow whichever typeface
      // the document was built with.
      expect(theme.titleStyle.fontNormal, isNull);
      expect(theme.valueStyle.fontNormal, isNull);
      expect(theme.bodyStyle.fontNormal, isNull);
    });

    test('sets the title, labels and headings semibold, the rest medium', () {
      const theme = GtPdfReceiptTheme.light();

      for (final style in [
        theme.titleStyle,
        theme.footerTitleStyle,
        theme.headingStyle,
        theme.labelStyle,
      ]) {
        expect(style.fontWeight, pw.FontWeight.bold);
      }
      for (final style in [
        theme.subtitleStyle,
        theme.sectionTitleStyle,
        theme.valueStyle,
        theme.bodyStyle,
        theme.bodyHeadingStyle,
        theme.footnoteStyle,
      ]) {
        expect(style.fontWeight, isNot(pw.FontWeight.bold));
      }
    });

    test('sets running text above the size of entry values', () {
      const theme = GtPdfReceiptTheme.light();

      expect(theme.bodyStyle.fontSize, theme.bodySize);
      expect(theme.bodySize, greaterThan(theme.valueSize));
      expect(theme.bodyHeadingStyle.fontSize, theme.bodySize);
      expect(theme.bodyHeadingStyle.color, theme.textStrong);
    });

    test('overrides only size and colour on the default text style', () {
      const theme = GtPdfReceiptTheme.light();
      final style = theme.pdfTheme(typeface).defaultTextStyle;

      expect(style.fontSize, theme.valueSize);
      expect(style.color, theme.textSub);
    });

    test('defaults documents to a white page with dark text', () {
      for (final theme in [
        const GtPdfReceiptExporter().builder.theme,
        const GtPdfInvoiceExporter().builder.theme,
      ]) {
        expect(theme.pageColor, PdfColors.white);
        expect(theme.textStrong.luminance, lessThan(0.1));
      }
    });

    test('keeps a white page when themed from a brand light palette', () {
      final palette = kFlexTheme.lightPalette;
      final theme = GtPdfReceiptTheme.fromPalette(palette);

      expect(theme.pageColor.luminance, greaterThan(0.9));
      expect(theme.textStrong.luminance, lessThan(0.1));
      expect(theme.brand, gtPdfColorOf(palette.primary.base));
    });

    test('goes dark only when handed a dark palette', () {
      final theme = GtPdfReceiptTheme.fromPalette(kFlexTheme.darkPalette);

      expect(theme.pageColor.luminance, lessThan(0.1));
      expect(theme.textStrong.luminance, greaterThan(0.5));
    });

    test('keeps unspecified fields when copied', () {
      const theme = GtPdfReceiptTheme.light();

      final copy = theme.copyWith(titleSize: 30, bodySize: 11);

      expect(copy.titleSize, 30);
      expect(copy.bodySize, 11);
      expect(copy.brand, theme.brand);
      expect(copy.pageFormat, theme.pageFormat);
    });
  });
}
