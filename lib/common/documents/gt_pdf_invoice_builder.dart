import 'dart:typed_data';

import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Renders a [GtPdfInvoiceData] into a paginated PDF document.
///
/// The builder owns layout only; content comes from the data and colour from
/// the [theme], which it shares with [GtPdfReceiptBuilder]. Delivering the
/// finished document to the user is [GtPdfInvoiceExporter]'s job.
///
/// The page closes on a full-width band carrying the page count and the
/// [GtPdfInvoiceData.poweredBy] mark on every page, with the
/// [GtPdfInvoiceData.payment] block above them on the last. The
/// [GtPdfInvoiceData.note] sits between the totals and that band. A long items
/// table breaks between rows, and a long note between lines, onto as many
/// pages as they need.
///
/// Example usage:
/// ```dart
/// const builder = GtPdfInvoiceBuilder();
/// final bytes = await builder.render(data);
/// ```
class GtPdfInvoiceBuilder {
  /// The colour and page size applied to the document.
  final GtPdfReceiptTheme theme;

  /// Creates a [GtPdfInvoiceBuilder].
  const GtPdfInvoiceBuilder({this.theme = const .light()});

  /// The inset of the content from the page's side edges.
  static const _gutter = 48.0;

  /// The width and height of the issuer's avatar.
  static const _avatarSize = 48.0;

  /// The gap between the header and the invoice details.
  static const _headerGap = 32.0;

  /// The gap between the blocks of the body.
  static const _blockGap = 40.0;

  /// The gap kept between the body and the closing band.
  static const _bandGap = 35.0;

  /// The gap between a block's heading and its content.
  static const _headingGap = 16.0;

  /// The gap between columns.
  static const _columnGap = 24.0;

  /// The gap between the cells of the items table.
  static const _cellGap = 12.0;

  /// The width of the invoice detail labels.
  static const _detailLabelWidth = 140.0;

  /// The width of each party column but the account's.
  static const _partyWidth = 138.0;

  /// The width of the items table's description column.
  static const _descriptionWidth = 139.0;

  /// The width of the totals block.
  static const _totalsWidth = 226.0;

  /// The width and height of the payment QR code.
  static const _qrSize = 54.0;

  /// The width of the payment prompt beside the QR code.
  static const _promptWidth = 116.0;

  /// The space a body line of 10pt copy occupies, and so the height of the
  /// blank line between blocks of a party.
  static const _lineHeight = 14.0;

  /// Builds the document without serialising it.
  pw.Document build(GtPdfInvoiceData data) {
    assert(data.items.hasValue, 'GtPdfInvoiceData requires at least one item');

    final document = pw.Document(title: gtPdfSafeText(data.title));

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: theme.pageFormat,
          margin: const pw.EdgeInsets.only(top: _gutter),
          theme: theme.pdfTheme,
          buildBackground: (_) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: theme.pageColor),
          ),
        ),
        footer: (context) => _band(data, context),
        build: (_) => [
          _padded(_header(data)),
          pw.SizedBox(height: _headerGap),
          _padded(_details(data)),
          pw.SizedBox(height: _blockGap),
          _padded(_parties(data)),
          pw.SizedBox(height: _blockGap),
          _padded(_heading(data.labels.items)),
          pw.SizedBox(height: _headingGap),
          ..._table(data),
          pw.SizedBox(height: _columnGap),
          _padded(_totals(data)),
          ..._note(data),
        ],
      ),
    );

    return document;
  }

  /// Builds the document and serialises it to bytes ready for export.
  Future<Uint8List> render(GtPdfInvoiceData data) => build(data).save();

  /// Insets [child] from the page's side edges.
  ///
  /// The page itself has no side margin, so that the closing band can run
  /// edge to edge.
  pw.Widget _padded(pw.Widget child) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: _gutter),
      child: child,
    );
  }

  /// An uppercased block heading, such as "Billed to".
  pw.Widget _heading(String text, {pw.TextAlign? textAlign}) {
    return pw.Text(
      gtPdfSafeText(text.toUpperCase()),
      textAlign: textAlign,
      style: pw.TextStyle(
        fontSize: 12,
        color: theme.textStrong,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  /// A line of copy at the size shared by the details, parties and payment
  /// prompt.
  pw.Widget _line(
    String text, {
    required PdfColor color,
    double fontSize = 10,
    bool bold = false,
    pw.TextAlign? textAlign,
  }) {
    return pw.Text(
      gtPdfSafeText(text),
      textAlign: textAlign,
      style: pw.TextStyle(
        fontSize: fontSize,
        color: color,
        lineSpacing: 4,
        fontWeight: bold ? pw.FontWeight.bold : null,
      ),
    );
  }

  /// The avatar, and the title over the status pill.
  pw.Widget _header(GtPdfInvoiceData data) {
    final avatar = data.avatar;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        if (avatar != null)
          pw.ClipOval(
            child: pw.Image(
              pw.MemoryImage(avatar),
              width: _avatarSize,
              height: _avatarSize,
              fit: pw.BoxFit.cover,
            ),
          )
        else
          pw.SizedBox(),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              gtPdfSafeText(data.labels.title.toUpperCase()),
              style: pw.TextStyle(
                fontSize: 14,
                color: theme.textStrong,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            if (data.status case GtPdfInvoiceStatus status) ...[
              pw.SizedBox(height: 12),
              _status(status),
            ],
          ],
        ),
      ],
    );
  }

  /// The pill naming the invoice's state.
  pw.Widget _status(GtPdfInvoiceStatus status) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(8, 6, 10, 6),
      decoration: pw.BoxDecoration(
        color: status.backgroundColor,
        border: pw.Border.all(color: status.borderColor),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Text(
        gtPdfSafeText(status.label.toUpperCase()),
        style: pw.TextStyle(
          fontSize: 10,
          color: status.textColor,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  /// The invoice number, then each detail row, label beside value.
  pw.Widget _details(GtPdfInvoiceData data) {
    final rows = [
      (label: data.labels.number, value: data.number.toUpperCase(), bold: true),
      for (final entry in data.details)
        (label: entry.label, value: entry.value, bold: false),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final (index, row) in rows.indexed) ...[
          if (index > 0) pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: _detailLabelWidth,
                child: _line(row.label, color: theme.textDisabled),
              ),
              pw.SizedBox(width: _columnGap),
              pw.Expanded(
                child: _line(
                  row.value,
                  color: theme.textStrong,
                  bold: row.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Who the invoice is billed to and from, and the account it is paid into.
  pw.Widget _parties(GtPdfInvoiceData data) {
    final labels = data.labels;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: _partyWidth,
          child: _party(labels.billedTo, data.billedTo),
        ),
        pw.SizedBox(width: _columnGap),
        pw.SizedBox(width: _partyWidth, child: _party(labels.from, data.from)),
        pw.SizedBox(width: _columnGap),
        pw.Expanded(
          child: data.account == null
              ? pw.SizedBox()
              : _account(labels.account, data.account!),
        ),
      ],
    );
  }

  /// A party under its [heading]: the name, the address, then the details,
  /// a blank line apart.
  pw.Widget _party(String heading, GtPdfInvoiceParty party) {
    final blocks = [
      if (party.address.hasValue) party.address,
      if (party.details.hasValue) party.details,
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _heading(heading),
        pw.SizedBox(height: _headingGap),
        _line(party.name, color: theme.textSoft, bold: true),
        for (final block in blocks) ...[
          pw.SizedBox(height: _lineHeight),
          for (final line in block) _line(line, color: theme.textSoft),
        ],
      ],
    );
  }

  /// The account the invoice is paid into, set against the trailing edge.
  pw.Widget _account(String heading, GtPdfInvoiceAccount account) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        _heading(heading, textAlign: pw.TextAlign.right),
        pw.SizedBox(height: _headingGap),
        _line(
          account.name,
          color: theme.textSoft,
          bold: true,
          textAlign: pw.TextAlign.right,
        ),
        pw.SizedBox(height: _lineHeight),
        _line(
          account.number,
          color: theme.brand,
          textAlign: pw.TextAlign.right,
        ),
        if (account.bank.hasValue)
          _line(
            account.bank!,
            color: theme.textSoft,
            textAlign: pw.TextAlign.right,
          ),
      ],
    );
  }

  /// The items table: the heading row over a heavy rule, then each item over
  /// a light one.
  ///
  /// Returned as separate rows rather than one table so the page can break
  /// between any two of them.
  List<pw.Widget> _table(GtPdfInvoiceData data) {
    final labels = data.labels;
    final hasTaxRate = data.hasTaxRate;
    final headingStyle = pw.TextStyle(
      fontSize: 10,
      color: theme.textSoft,
      fontWeight: pw.FontWeight.bold,
    );
    final cellStyle = pw.TextStyle(fontSize: 12, color: theme.textStrong);

    pw.Widget row(List<String> cells, pw.TextStyle style) {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: _descriptionWidth,
            child: pw.Text(gtPdfSafeText(cells.first), style: style),
          ),
          for (final cell in cells.skip(1)) ...[
            pw.SizedBox(width: _cellGap),
            pw.Expanded(child: pw.Text(gtPdfSafeText(cell), style: style)),
          ],
        ],
      );
    }

    pw.Widget rule(double thickness) {
      return pw.Divider(
        color: theme.divider,
        thickness: thickness,
        height: thickness,
      );
    }

    return [
      _padded(
        pw.Column(
          children: [
            pw.SizedBox(height: 8),
            row([
              labels.description.toUpperCase(),
              labels.price.toUpperCase(),
              labels.quantity.toUpperCase(),
              if (hasTaxRate) labels.taxRate.toUpperCase(),
              labels.amount.toUpperCase(),
            ], headingStyle),
            pw.SizedBox(height: 12),
            rule(1.5),
          ],
        ),
      ),
      for (final item in data.items)
        _padded(
          pw.Column(
            children: [
              pw.SizedBox(height: _cellGap),
              row([
                item.description,
                item.price,
                item.quantity,
                if (hasTaxRate) item.taxRate ?? '',
                item.amount,
              ], cellStyle),
              pw.SizedBox(height: _cellGap),
              rule(1),
            ],
          ),
        ),
    ];
  }

  /// The subtotal, any adjustments and the total, set against the trailing
  /// edge.
  pw.Widget _totals(GtPdfInvoiceData data) {
    final labels = data.labels;
    final labelStyle = pw.TextStyle(fontSize: 12, color: theme.textStrong);
    final adjustments = data.adjustments.where((entry) => entry.value.hasValue);

    pw.Widget row(String label, String value, pw.TextStyle valueStyle) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(gtPdfSafeText(label), style: labelStyle),
          pw.Text(gtPdfSafeText(value.toUpperCase()), style: valueStyle),
        ],
      );
    }

    final rows = [
      if (data.subtotal case String subtotal when subtotal.hasValue)
        pw.Column(
          children: [
            row(
              labels.subtotal,
              subtotal,
              pw.TextStyle(
                fontSize: 14,
                color: theme.brand,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Divider(color: theme.divider, thickness: 1, height: 1),
          ],
        ),
      for (final entry in adjustments)
        row(entry.label, entry.value, labelStyle),
      row(
        labels.total,
        data.total,
        pw.TextStyle(
          fontSize: 12,
          color: theme.textStrong,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ];

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: _totalsWidth,
        child: pw.Column(
          children: [
            for (final (index, row) in rows.indexed) ...[
              if (index > 0) pw.SizedBox(height: _cellGap),
              row,
            ],
          ],
        ),
      ),
    );
  }

  /// The issuer's note under its heading, after a block gap.
  ///
  /// Returned as separate widgets rather than one column so the paragraph can
  /// break across pages. Empty when the invoice carries no note.
  List<pw.Widget> _note(GtPdfInvoiceData data) {
    if (data.note case String note when note.hasValue) {
      return [
        pw.SizedBox(height: _blockGap),
        _padded(_heading(data.labels.note)),
        pw.SizedBox(height: _headingGap),
        _padded(
          pw.Text(
            gtPdfSafeText(note),
            overflow: pw.TextOverflow.span,
            style: pw.TextStyle(
              fontSize: 10,
              color: theme.textSoft,
              lineSpacing: 4,
            ),
          ),
        ),
      ];
    }

    return const [];
  }

  /// The full-width band closing every page.
  ///
  /// Carries the page count and the powered-by mark, with the payment block
  /// above them on the last page. The band is laid out before the page count
  /// is known, when every page still reads as the last, so every page keeps
  /// room for the payment block. Pages before the last leave that room blank
  /// on the page itself, so the band only opens where its content starts.
  ///
  /// The band keeps its own [_bandGap] from the body, rather than the body
  /// ending on a spacer, so a spacer that no longer fits cannot open a page
  /// of its own.
  pw.Widget _band(GtPdfInvoiceData data, pw.Context context) {
    final isLastPage = context.pageNumber == context.pagesCount;
    final payment = data.payment;
    final paymentBlock = payment == null
        ? null
        : pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: _gutter),
            child: _payment(data.labels.payOnline, payment),
          );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.SizedBox(height: _bandGap),
        if (paymentBlock != null && !isLastPage)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: _gutter),
            child: pw.Opacity(opacity: 0, child: paymentBlock),
          ),
        pw.Container(
          color: theme.band,
          padding: const pw.EdgeInsets.fromLTRB(_gutter, 24, _gutter, _gutter),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (isLastPage) ?paymentBlock,
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _line(
                    data.labels.pageOf(context.pageNumber, context.pagesCount),
                    color: theme.textSoft,
                    fontSize: 8,
                  ),
                  ?_poweredBy(data),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// The QR code and prompt inviting the customer to pay online, linked to
  /// the payment page.
  pw.Widget _payment(String heading, GtPdfInvoicePayment payment) {
    final qrImage = payment.qrImage;
    final qr = qrImage != null
        ? pw.Image(
            pw.MemoryImage(qrImage),
            width: _qrSize,
            height: _qrSize,
            fit: pw.BoxFit.contain,
          )
        : pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: payment.url,
            width: _qrSize,
            height: _qrSize,
            color: theme.textStrong,
            drawText: false,
          );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _heading(heading),
        pw.SizedBox(height: _headingGap),
        pw.UrlLink(
          destination: payment.url,
          child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              qr,
              pw.SizedBox(width: _cellGap),
              pw.SizedBox(
                width: _promptWidth,
                child: _line(
                  payment.prompt,
                  color: theme.textStrong,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// The "Powered by" label over the caller's mark.
  pw.Widget? _poweredBy(GtPdfInvoiceData data) {
    final poweredBy = data.poweredBy;
    if (poweredBy == null) return null;

    final pw.Widget mark;
    if (poweredBy.image case Uint8List image) {
      mark = pw.Image(
        pw.MemoryImage(image),
        height: poweredBy.height,
        fit: pw.BoxFit.contain,
      );
    } else {
      mark = pw.SvgImage(svg: poweredBy.svg!, height: poweredBy.height);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          gtPdfSafeText(data.labels.poweredBy.toUpperCase()),
          style: pw.TextStyle(fontSize: 10, color: theme.textDisabled),
        ),
        pw.SizedBox(height: 4),
        mark,
      ],
    );
  }
}
