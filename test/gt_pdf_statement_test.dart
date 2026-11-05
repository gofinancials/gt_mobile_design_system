import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GtPdfTypeface typeface;

  setUpAll(() async {
    typeface = await GtPdfTypeface.load();
  });

  const summary = GtPdfStatementSummaryRow(
    product: 'Savings Account',
    accountNumber: '0123456789',
    openingBalance: '₦1,200,000,000',
    totalOutgoings: '₦19,000,123',
    totalDeposits: '₦19,000,123',
    closingBalance: '₦19,000,123',
  );

  GtPdfStatementTransaction transaction(int index) {
    return GtPdfStatementTransaction(
      date: '01/03/2026',
      title: 'Payment $index',
      details: const [
        'Transaction ID: TRX24072983910527NG',
        'From: Francis Lobaloba, 01234567890',
        'Reference: House Rent',
      ],
      amount: '₦1,000,000',
      isCredit: index.isEven,
      balance: '₦1,200,000,000',
    );
  }

  /// The statement from the design spec, which lands on a single page.
  const reference = GtPdfStatementData(
    title: 'Savings Account Statement',
    period: '01/03/2026 - 10/03/2026',
    holder: GtPdfStatementHolder(
      name: 'Alex Lobaloba',
      address: ['210 Sanusi Street', 'Surulere, Lagos', '234768', 'Nigeria'],
    ),
    details: [
      GtPdfReceiptEntry(label: 'Account Number', value: '0123456789'),
      GtPdfReceiptEntry(label: 'Bank Sort Code', value: '232'),
    ],
    summary: [summary],
    transactions: [
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
        amount: '-₦700,000,000',
        isCredit: false,
        balance: '₦19,000,123',
      ),
    ],
    footer: GtPdfStatementFooter(
      title: 'Sterling Bank Address',
      address: ['Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria'],
      contactLines: ['customercare@sterling.ng', '02018888822, 07008220000'],
      qrData: 'https://sterling.ng/statements/81a0cf3b',
      copyright: '© 2026 Sterling Bank',
    ),
  );

  GtPdfStatementData withTransactions(List<GtPdfStatementTransaction> rows) {
    return GtPdfStatementData(
      title: reference.title,
      period: reference.period,
      holder: reference.holder,
      details: reference.details,
      summary: reference.summary,
      transactions: rows,
      footer: reference.footer,
    );
  }

  /// A PDF file always opens with the `%PDF-` header.
  bool looksLikePdf(Uint8List bytes) {
    return ascii.decode(bytes.sublist(0, 5)) == '%PDF-';
  }

  /// Builds [data], saves it so it paginates, and counts its pages.
  Future<int> pageCount(GtPdfStatementData data) async {
    final document = const GtPdfStatementBuilder().build(
      data,
      typeface: typeface,
    );
    await document.save();
    return document.document.pdfPageList.pages.length;
  }

  group('GtPdfStatementData', () {
    test('derives a slugged file name from the title and period', () {
      expect(
        reference.resolvedFileName,
        'Savings_Account_Statement_01_03_2026_-_10_03_2026.pdf',
      );
    });

    test('prefers an explicit file name', () {
      const named = GtPdfStatementData(
        title: 'Statement',
        period: 'March',
        holder: GtPdfStatementHolder(name: 'Alex Lobaloba'),
        summary: [summary],
        fileName: 'statement-0123456789',
      );

      expect(named.resolvedFileName, 'statement-0123456789.pdf');
    });

    test('titles the document with its period', () {
      expect(
        reference.documentTitle,
        'Savings Account Statement 01/03/2026 - 10/03/2026',
      );
    });

    test('builds the transaction heading and page count from labels', () {
      const labels = GtPdfStatementLabels();

      expect(
        labels.transactionSummary('01/03/2026 - 10/03/2026'),
        'Account Transaction Summary (01/03/2026 - 10/03/2026)',
      );
      expect(labels.pageOf(2, 5), 'Page 2 of 5');
    });
  });

  group('GtPdfStatementBuilder', () {
    test('lays the reference statement out on a single page', () async {
      expect(await pageCount(reference), 1);
    });

    test('renders a statement with no transactions', () async {
      const empty = GtPdfStatementData(
        title: 'Savings Account Statement',
        period: '01/03/2026 - 10/03/2026',
        holder: GtPdfStatementHolder(name: 'Alex Lobaloba'),
        summary: [summary],
      );

      expect(await pageCount(empty), 1);
    });

    test('runs a long transaction table on to further pages', () async {
      final pages = await pageCount(
        withTransactions([
          for (var index = 0; index < 60; index++) transaction(index),
        ]),
      );

      expect(pages, greaterThan(1));
    });

    test('runs past the 20 pages MultiPage allows by default', () async {
      // Each row is ~60pt tall, so a thousand of them fill far more than the
      // 20 pages the pdf package caps a single spanning widget at.
      final pages = await pageCount(
        withTransactions([
          for (var index = 0; index < 1000; index++) transaction(index),
        ]),
      );

      expect(pages, greaterThan(20));
    });

    test('closes every page on a count of the whole document', () async {
      final counts = <(int, int)>[];
      final base = withTransactions([
        for (var index = 0; index < 60; index++) transaction(index),
      ]);
      final data = GtPdfStatementData(
        title: base.title,
        period: base.period,
        holder: base.holder,
        details: base.details,
        summary: base.summary,
        transactions: base.transactions,
        footer: base.footer,
        labels: GtPdfStatementLabels(
          pageOf: (page, pages) {
            counts.add((page, pages));
            return 'Page $page of $pages';
          },
        ),
      );

      final document = const GtPdfStatementBuilder().build(
        data,
        typeface: typeface,
      );
      await document.save();
      final pages = document.document.pdfPageList.pages.length;

      // The footers drawn on the pages are the last built, once every page
      // exists; earlier ones only measured the band during layout.
      final drawn = counts.sublist(counts.length - pages);
      expect(pages, greaterThan(1));
      expect(drawn, [for (var page = 1; page <= pages; page++) (page, pages)]);
    });

    test('renders to PDF bytes off the main isolate', () async {
      final bytes = await const GtPdfStatementBuilder().render(reference);

      expect(looksLikePdf(bytes), isTrue);
    });

    test('renders a long statement off the main isolate', () async {
      final watch = Stopwatch()..start();
      final bytes = await const GtPdfStatementBuilder().render(
        withTransactions([
          for (var index = 0; index < 2000; index++) transaction(index),
        ]),
      );
      watch.stop();

      expect(looksLikePdf(bytes), isTrue);
      // ignore: avoid_print
      print('2000 transactions rendered in ${watch.elapsedMilliseconds}ms');
    });

    test('themes from a palette', () async {
      final builder = GtPdfStatementBuilder(
        theme: GtPdfReceiptTheme.fromPalette(kPersonalTheme.lightPalette),
      );
      final document = builder.build(reference, typeface: typeface);
      await document.save();

      expect(document.document.pdfPageList.pages, hasLength(1));
    });
  });
}
