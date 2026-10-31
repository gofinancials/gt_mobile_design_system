import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Renders a [GtPdfStatementData] into a paginated PDF account statement.
///
/// The builder owns layout only; content comes from the data and colour from
/// the [theme], which it shares with [GtPdfReceiptBuilder] and
/// [GtPdfInvoiceBuilder]. Delivering the finished document to the user is
/// [GtPdfStatementExporter]'s job.
///
/// Every page opens on the title, the period and the brand mark, and closes
/// on the footer and a page count that counts the whole document. The first
/// page carries the account holder and the Balance Summary; the transaction
/// table follows and runs on to as many pages as it needs, breaking between
/// rows, never inside one, and repeating its column headings at the top of
/// every page it continues onto.
///
/// Example usage:
/// ```dart
/// const builder = GtPdfStatementBuilder();
/// final bytes = await builder.render(data);
/// ```
class GtPdfStatementBuilder {
  /// The colour and page size applied to the document.
  final GtPdfReceiptTheme theme;

  /// Creates a [GtPdfStatementBuilder].
  const GtPdfStatementBuilder({this.theme = const .light()});

  /// The inset of the content from the page's top and side edges.
  static const _gutter = 40.0;

  /// The inset of the footer from the page's bottom edge.
  static const _bottomGutter = 24.0;

  /// The width and height of the brand mark or logo.
  static const _markSize = 40.0;

  /// The gap between the page header and the body beneath it.
  static const _headerGap = 38.0;

  /// The gap between the account holder and the Balance Summary.
  static const _holderGap = 34.0;

  /// The gap between the Balance Summary and the transaction table.
  static const _sectionGap = 32.0;

  /// The gap between a section's heading and its table.
  static const _headingGap = 12.0;

  /// The space above and below the content of each table row.
  static const _cellPadding = 12.0;

  /// The gap kept between a table cell and the next column.
  static const _cellGap = 12.0;

  /// The gap kept between the Balance Summary's cells, tighter than
  /// [_cellGap] so its five columns each keep a balance in the billions on
  /// one line.
  static const _summaryCellGap = 8.0;

  /// The width of the account holder column, where the details begin.
  static const _holderWidth = 224.0;

  /// The gap kept between the body and the footer.
  static const _footerGap = 40.0;

  /// The gap between the footer's contact block and its copyright line.
  static const _copyrightGap = 32.0;

  /// The width and height of the footer QR code.
  static const _qrSize = 48.0;

  /// The thickness of the rules between table rows.
  static const _ruleWidth = 0.5;

  /// The relative widths of the Balance Summary columns.
  ///
  /// Narrower for the product and wider for the amounts than drawn: the
  /// design sets amounts with the naira sign, which [gtPdfSafeText] spells
  /// `NGN `, and a balance in the billions must still fit on one line.
  static const _summaryColumns = [95, 105, 105, 105, 105];

  /// The relative widths of the transaction table columns.
  ///
  /// Wider for the amount and balance than drawn, for the reason given on
  /// [_summaryColumns].
  static const _transactionColumns = [80, 195, 120, 120];

  /// Builds the document without serialising it, set in [typeface].
  ///
  /// Runs on the calling isolate, so a statement with many transactions
  /// blocks it while the pages are laid out; [render] does that work off the
  /// main isolate. Pass the faces from [GtPdfTypeface.load] to match the
  /// design; without them the document falls back to the `pdf` package's
  /// default family.
  pw.Document build(GtPdfStatementData data, {GtPdfTypeface? typeface}) {
    assert(
      data.summary.hasValue,
      'GtPdfStatementData requires at least one summary row',
    );

    final document = pw.Document(title: gtPdfSafeText(data.documentTitle));
    final table = _TablePages();

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: theme.pageFormat,
          margin: const pw.EdgeInsets.fromLTRB(
            _gutter,
            _gutter,
            _gutter,
            _bottomGutter,
          ),
          theme: theme.pdfTheme(typeface),
          buildBackground: (_) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: theme.pageColor),
          ),
        ),
        header: (context) => _header(data, table, context),
        footer: (context) => _footer(data, context),
        build: (_) => [
          _holder(data),
          pw.SizedBox(height: _holderGap),
          _heading(data.labels.balanceSummary),
          pw.SizedBox(height: _headingGap),
          _summary(data),
          pw.SizedBox(height: _sectionGap),
          _heading(data.labels.transactionSummary(data.period)),
          pw.SizedBox(height: _headingGap),
          ..._transactions(data, table),
        ],
      ),
    );

    return document;
  }

  /// Builds the document in the design system's [GtPdfTypeface] and
  /// serialises it to bytes ready for export.
  ///
  /// The layout runs on a background isolate, so a statement of thousands of
  /// transactions does not stall the interface while it renders. [data] is
  /// sent to that isolate, which is why the functions on its
  /// [GtPdfStatementLabels] must not capture state confined to the main
  /// isolate. On the web, where there are no isolates, it renders in place.
  Future<Uint8List> render(GtPdfStatementData data) async {
    final fonts = await GtPdfTypeface.loadBytes();

    return compute(_render, (
      builder: this,
      data: data,
      fonts: fonts,
    ), debugLabel: 'Render PDF statement');
  }

  /// The body of [render], run on the background isolate.
  static Future<Uint8List> _render(
    ({
      GtPdfStatementBuilder builder,
      GtPdfStatementData data,
      GtPdfTypefaceBytes fonts,
    })
    message,
  ) {
    final typeface = GtPdfTypeface.fromBytes(message.fonts);
    return message.builder.build(message.data, typeface: typeface).save();
  }

  /// A line of copy, made settable by [gtPdfSafeText].
  pw.Widget _text(
    String text, {
    required double fontSize,
    required PdfColor color,
    bool bold = false,
  }) {
    return pw.Text(
      gtPdfSafeText(text),
      style: pw.TextStyle(
        fontSize: fontSize,
        color: color,
        lineSpacing: 2,
        fontWeight: bold ? pw.FontWeight.bold : null,
      ),
    );
  }

  /// A section heading, such as "Balance Summary".
  pw.Widget _heading(String text) {
    return _text(text, fontSize: 14, color: theme.textStrong);
  }

  /// The title and period beside the brand mark, repeated on every page.
  ///
  /// On every page after the one the transaction table starts on, the
  /// table's column headings follow, so the rows it carries on with read
  /// under them. Those pages hold nothing but the table.
  pw.Widget _header(
    GtPdfStatementData data,
    _TablePages table,
    pw.Context context,
  ) {
    final continuesTable = switch (table.startPage) {
      int start => context.pageNumber > start,
      null => false,
    };

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _masthead(data),
        pw.SizedBox(height: _headerGap),
        if (continuesTable) _transactionHeadings(data),
      ],
    );
  }

  /// The title and period beside the brand mark.
  pw.Widget _masthead(GtPdfStatementData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(gtPdfSafeText(data.title), style: theme.titleStyle),
              pw.SizedBox(height: 4),
              _text(data.period, fontSize: 10, color: theme.textSub),
            ],
          ),
        ),
        pw.SizedBox(width: _cellGap),
        ?_mark(data),
      ],
    );
  }

  /// The institution logo, falling back to the built-in brand mark drawn in
  /// the theme's brand colours.
  pw.Widget? _mark(GtPdfStatementData data) {
    if (data.logo case Uint8List logo) {
      return pw.SizedBox(
        width: _markSize,
        height: _markSize,
        child: pw.Image(pw.MemoryImage(logo), fit: pw.BoxFit.contain),
      );
    }

    if (!data.showBrandMark) return null;

    // The mark is a disc with a dot cut out near its top right, drawn on a
    // 14-unit grid: the dot sits at (8.75, 4.67) with a 1.75 radius.
    const unit = _markSize / 14;
    const dot = 3.5 * unit;

    return pw.SizedBox(
      width: _markSize,
      height: _markSize,
      child: pw.Stack(
        children: [
          pw.Container(
            decoration: pw.BoxDecoration(
              color: theme.brand,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.Positioned(
            left: 7 * unit,
            top: 2.92 * unit,
            child: pw.Container(
              width: dot,
              height: dot,
              decoration: pw.BoxDecoration(
                color: theme.brandAccent,
                shape: pw.BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A label over its value, as the holder's details are set.
  pw.Widget _entry(GtPdfReceiptEntry entry) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _text(entry.label, fontSize: 10, color: theme.textStrong),
        pw.SizedBox(height: 4),
        _text(entry.value, fontSize: 10, color: theme.textSub),
      ],
    );
  }

  /// The account holder's name and address beside the labelled details.
  pw.Widget _holder(GtPdfStatementData data) {
    final holder = data.holder;
    final details = data.details.where((entry) => entry.value.hasValue);

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: _holderWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _text(holder.name, fontSize: 10, color: theme.textStrong),
              if (holder.address.hasValue) pw.SizedBox(height: 4),
              for (final line in holder.address)
                _text(line, fontSize: 10, color: theme.textSub),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final (index, entry) in details.indexed) ...[
                if (index > 0) pw.SizedBox(height: 10),
                _entry(entry),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// A rule in the [GtPdfReceiptTheme.hairline] colour.
  pw.BorderSide get _rule {
    return pw.BorderSide(color: theme.hairline, width: _ruleWidth);
  }

  /// A row of a table: [cells] across columns of the relative widths in
  /// [columns], ruled off beneath, and above too when it opens the table.
  ///
  /// Each row is a widget of its own, so a page breaks between rows and
  /// never inside one, and laying out a long table costs one pass over its
  /// rows rather than one per page.
  pw.Widget _row(
    List<pw.Widget> cells,
    List<int> columns, {
    bool opensTable = false,
    double gap = _cellGap,
    pw.CrossAxisAlignment alignment = pw.CrossAxisAlignment.start,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(top: opensTable ? _rule : .none, bottom: _rule),
      ),
      child: pw.Row(
        crossAxisAlignment: alignment,
        children: [
          for (final (index, cell) in cells.indexed)
            pw.Expanded(
              flex: columns[index],
              child: pw.Padding(
                padding: pw.EdgeInsets.only(
                  top: _cellPadding,
                  bottom: _cellPadding,
                  right: index == cells.length - 1 ? 0 : gap,
                ),
                child: cell,
              ),
            ),
        ],
      ),
    );
  }

  /// A table's heading row, ruled above and below.
  pw.Widget _headingRow(
    List<String> headings,
    List<int> columns, {
    double gap = _cellGap,
  }) {
    return _row(
      [
        for (final heading in headings)
          _text(heading, fontSize: 9, color: theme.textStrong),
      ],
      columns,
      opensTable: true,
      gap: gap,
    );
  }

  /// The Balance Summary table.
  pw.Widget _summary(GtPdfStatementData data) {
    final labels = data.labels;
    pw.Widget amount(String value) {
      return _text(value, fontSize: 10, color: theme.textStrong);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _headingRow(
          [
            labels.product,
            labels.openingBalance,
            labels.totalOutgoings,
            labels.totalDeposits,
            labels.closingBalance,
          ],
          _summaryColumns,
          gap: _summaryCellGap,
        ),
        for (final row in data.summary)
          _row(
            [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _text(row.product, fontSize: 10, color: theme.textStrong),
                  if (row.accountNumber case String number when number.hasValue)
                    _text(number, fontSize: 10, color: theme.textStrong),
                ],
              ),
              amount(row.openingBalance),
              amount(row.totalOutgoings),
              amount(row.totalDeposits),
              amount(row.closingBalance),
            ],
            _summaryColumns,
            gap: _summaryCellGap,
            alignment: pw.CrossAxisAlignment.center,
          ),
      ],
    );
  }

  /// The transaction table's heading row.
  pw.Widget _transactionHeadings(GtPdfStatementData data) {
    final labels = data.labels;
    return _headingRow([
      labels.date,
      labels.description,
      labels.amount,
      labels.balance,
    ], _transactionColumns);
  }

  /// The transaction table: its heading row, then one widget per
  /// transaction, or the empty-period line when there are none.
  ///
  /// A zero-size marker after the heading row records the page the table
  /// starts on, which tells [_header] the pages that follow need the
  /// headings repeated.
  List<pw.Widget> _transactions(GtPdfStatementData data, _TablePages table) {
    return [
      _transactionHeadings(data),
      _PageMarker((page) => table.startPage = page),
      if (data.transactions.isEmpty)
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: _cellPadding),
          decoration: pw.BoxDecoration(border: pw.Border(bottom: _rule)),
          child: _text(
            data.labels.noTransactions,
            fontSize: 10,
            color: theme.textSub,
          ),
        ),
      for (final transaction in data.transactions) _transaction(transaction),
    ];
  }

  /// A row of the transaction table.
  pw.Widget _transaction(GtPdfStatementTransaction transaction) {
    final amount = transaction.amount.replaceFirst(_leadingSign, '');
    final sign = transaction.isCredit ? '+' : '-';

    return _row([
      _text(transaction.date, fontSize: 10, color: theme.textStrong),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _text(
            transaction.title,
            fontSize: 10,
            color: theme.textStrong,
            bold: true,
          ),
          for (final line in transaction.details) ...[
            pw.SizedBox(height: 2),
            _text(line, fontSize: 8, color: theme.textStrong),
          ],
        ],
      ),
      _text(
        '$sign$amount',
        fontSize: 10,
        color: transaction.isCredit ? theme.success : theme.textStrong,
        bold: true,
      ),
      _text(
        transaction.balance,
        fontSize: 10,
        color: theme.textStrong,
        bold: true,
      ),
    ], _transactionColumns);
  }

  /// A sign the app may already have put in front of an amount: plus, hyphen
  /// or the minus sign, with any space after it.
  static final _leadingSign = RegExp('^\\s*[+\\-−]\\s*');

  /// The contact block and QR code over the copyright and page count, closing
  /// every page.
  pw.Widget _footer(GtPdfStatementData data, pw.Context context) {
    final footer = data.footer;
    final pageOf = data.labels.pageOf(context.pageNumber, context.pagesCount);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: _footerGap),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          if (footer != null && (footer.hasContactBlock || footer.hasQr)) ...[
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Expanded(child: _contacts(footer)),
                if (footer.hasQr) ...[
                  pw.SizedBox(width: _cellGap),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: footer.qrData!,
                    width: _qrSize,
                    height: _qrSize,
                    color: theme.textStrong,
                    drawText: false,
                  ),
                ],
              ],
            ),
            pw.SizedBox(height: _copyrightGap),
          ],
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              if (footer?.copyright case String copyright
                  when copyright.hasValue)
                _text(copyright, fontSize: 8, color: theme.textStrong)
              else
                pw.SizedBox(),
              _text(pageOf, fontSize: 8, color: theme.textStrong),
            ],
          ),
        ],
      ),
    );
  }

  /// The institution's address heading, address and contact lines.
  pw.Widget _contacts(GtPdfStatementFooter footer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (footer.title case String title when title.hasValue) ...[
          _text(title, fontSize: 9, color: theme.textStrong, bold: true),
          pw.SizedBox(height: 5),
        ],
        for (final line in footer.address)
          _text(line, fontSize: 9, color: theme.textStrong),
        for (final line in footer.contactLines)
          _text(line, fontSize: 9, color: theme.textSoft),
      ],
    );
  }
}

/// The page a statement's transaction table starts on, recorded while the
/// document is laid out.
class _TablePages {
  /// The page number the table's heading row landed on, or null until the
  /// layout reaches it.
  int? startPage;
}

/// A zero-size widget reporting the page it is laid out on.
///
/// `MultiPage` builds each page's header before laying out that page's
/// content, so a marker laid out on one page is known to the headers of all
/// the pages after it.
class _PageMarker extends pw.Widget {
  /// Called with the page number whenever the marker is laid out.
  final void Function(int page) onLayout;

  /// Creates a [_PageMarker].
  _PageMarker(this.onLayout);

  @override
  void layout(
    pw.Context context,
    pw.BoxConstraints constraints, {
    bool parentUsesSize = false,
  }) {
    onLayout(context.pageNumber);
    box = PdfRect.zero;
  }
}
