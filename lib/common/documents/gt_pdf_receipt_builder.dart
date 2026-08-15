import 'dart:math' as math;
import 'dart:typed_data';

import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/widgets.dart' as pw;

/// Renders a [GtPdfReceiptData] into a paginated PDF document.
///
/// The builder owns layout only; content comes from the data and styling from
/// the [theme]. Delivering the finished document to the user — sharing it,
/// saving it — is [GtPdfReceiptExporter]'s job.
///
/// Spacing is tuned so an ordinary transfer receipt — a details block plus a
/// sender and a recipient, closed by a footer — lands on a single page, with
/// roughly two more grid rows of headroom before it spills. Longer receipts
/// still flow onto as many pages as they need: the document is laid out with
/// `MultiPage`, so a section that will not fit breaks across the page boundary
/// rather than being clipped.
///
/// Example usage:
/// ```dart
/// const builder = GtPdfReceiptBuilder();
/// final bytes = await builder.render(data);
/// ```
class GtPdfReceiptBuilder {
  /// The typography, colour and page geometry applied to the document.
  final GtPdfReceiptTheme theme;

  /// Creates a [GtPdfReceiptBuilder].
  const GtPdfReceiptBuilder({this.theme = const .light()});

  /// The gap between the header block and the first section.
  static const _headerGap = 28.0;

  /// The gap between a section's leading hairline and its heading.
  static const _sectionTopGap = 15.0;

  /// The gap between a section heading and its entries.
  static const _sectionHeadingGap = 14.0;

  /// The gap between the last entry of a section and the next hairline.
  static const _sectionBottomGap = 40.0;

  /// The gap between an entry label and its value.
  static const _entryGap = 5.0;

  /// The gap between stacked entries, in both layouts.
  static const _entryStackGap = 16.0;

  /// The gap between the columns of a grid or split section.
  static const _columnGap = 24.0;

  /// The gap between the footer contact block and the disclaimer.
  static const _footnoteGap = 20.0;

  /// The gap between the disclaimer and the closing note.
  static const _noteGap = 10.0;

  /// Builds the document without serialising it.
  ///
  /// Useful when the receipt is one part of a larger PDF, or when the caller
  /// wants to inspect or extend the document before saving.
  pw.Document build(GtPdfReceiptData data) {
    assert(
      data.sections.hasValue,
      'GtPdfReceiptData requires at least one section',
    );
    assert(
      data.sections.every((section) => section.columns > 0),
      'Every GtPdfReceiptSection requires at least one column',
    );

    final document = pw.Document(title: data.title);

    document.addPage(
      pw.MultiPage(
        footer: (_) {
          if (data.footer case GtPdfReceiptFooter footer
              when footer.hasContent) {
            return pw.Column(
              children: _footer(footer),
              crossAxisAlignment: .stretch,
            );
          }

          return pw.SizedBox.shrink();
        },
        pageTheme: pw.PageTheme(
          pageFormat: theme.pageFormat,
          margin: theme.pagePadding,
          theme: theme.pdfTheme,
          buildBackground: (_) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: theme.pageColor),
          ),
        ),
        build: (_) => [
          _header(data),
          pw.SizedBox(height: _headerGap),
          for (final section in data.sections) ..._section(section),
        ],
      ),
    );

    return document;
  }

  /// Builds the document and serialises it to bytes ready for export.
  Future<Uint8List> render(GtPdfReceiptData data) => build(data).save();

  /// The document title, issue date and institution mark.
  pw.Widget _header(GtPdfReceiptData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(data.title, style: theme.titleStyle),
              if (data.issuedOn.hasValue) ...[
                pw.SizedBox(height: 8),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: '${data.displayIssuedOnLabel} ',
                        style: theme.subtitleLabelStyle,
                      ),
                      pw.TextSpan(
                        text: data.issuedOn,
                        style: theme.subtitleStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        pw.SizedBox(width: _columnGap),
        ?_logo(data),
      ],
    );
  }

  /// The institution logo, falling back to the built-in brand mark.
  pw.Widget? _logo(GtPdfReceiptData data) {
    if (data.logo case Uint8List logo) {
      return pw.SizedBox(
        width: theme.logoSize,
        height: theme.logoSize,
        child: pw.Image(pw.MemoryImage(logo), fit: pw.BoxFit.contain),
      );
    }

    if (!data.showBrandMark) return null;

    return pw.SvgImage(
      svg: """
        <svg fill="none" height="14" viewBox="0 0 14 14" width="14"><rect fill="#d92128" height="14" rx="7" width="14"/><circle cx="8.75" cy="4.66528" fill="#fff" r="1.75"/></svg>
      """,
      width: theme.logoSize,
      height: theme.logoSize,
    );
  }

  /// A titled block, preceded by the hairline that separates it from whatever
  /// came before.
  List<pw.Widget> _section(GtPdfReceiptSection section) {
    return [
      pw.Divider(color: theme.divider, thickness: 0.6, height: 0.6),
      pw.SizedBox(height: _sectionTopGap),
      pw.Text(section.title.upper, style: theme.sectionTitleStyle),
      pw.SizedBox(height: _sectionHeadingGap),
      switch (section.resolvedLayout) {
        .split => _splitSection(section),
        .grid => _gridSection(section),
      },
      pw.SizedBox(height: _sectionBottomGap),
    ];
  }

  /// Entries flowing row-major across [GtPdfReceiptSection.columns] columns.
  pw.Widget _gridSection(GtPdfReceiptSection section) {
    final rows = <pw.Widget>[];
    final columns = section.columns;

    for (var start = 0; start < section.entries.length; start += columns) {
      final end = math.min(start + columns, section.entries.length);
      final slice = section.entries.sublist(start, end);

      if (rows.hasValue) rows.add(pw.SizedBox(height: _entryStackGap));
      rows.add(
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (var column = 0; column < columns; column++) ...[
              if (column > 0) pw.SizedBox(width: _columnGap),
              pw.Expanded(
                child: column < slice.length
                    ? _entry(slice[column])
                    : pw.SizedBox(),
              ),
            ],
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: rows,
    );
  }

  /// A heading in the leading column with the entries stacked in the trailing
  /// one.
  pw.Widget _splitSection(GtPdfReceiptSection section) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: section.heading.hasValue
              ? pw.Text(section.heading!, style: theme.headingStyle)
              : pw.SizedBox(),
        ),
        pw.SizedBox(width: _columnGap),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final (index, entry) in section.entries.indexed) ...[
                if (index > 0) pw.SizedBox(height: _entryStackGap),
                _entry(entry),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// A single label over value pair.
  pw.Widget _entry(GtPdfReceiptEntry entry) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(entry.label, style: theme.labelStyle),
        pw.SizedBox(height: _entryGap),
        pw.Text(entry.value, style: theme.valueStyle),
      ],
    );
  }

  /// The contact block, QR code, disclaimer and closing note.
  List<pw.Widget> _footer(GtPdfReceiptFooter footer) {
    return [
      if (footer.hasContactBlock || footer.hasQr) ...[
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: _footerContacts(footer)),
            pw.SizedBox(width: _columnGap),
            ?_qr(footer),
          ],
        ),
      ],
      if (footer.disclaimer.hasValue) ...[
        pw.SizedBox(height: _footnoteGap),
        pw.Text(footer.disclaimer!, style: theme.footnoteStyle),
      ],
      if (footer.note.hasValue) ...[
        pw.SizedBox(height: _noteGap),
        pw.Text(footer.note!, style: theme.footnoteStyle),
      ],
    ];
  }

  /// The institution's name, address and contact lines.
  pw.Widget _footerContacts(GtPdfReceiptFooter footer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (footer.title.hasValue) ...[
          pw.Text(footer.title!, style: theme.footerTitleStyle),
          pw.SizedBox(height: 4),
        ],
        if (footer.address.hasValue) ...[
          pw.Text(footer.address!, style: theme.footerAddressStyle),
          pw.SizedBox(height: 1),
        ],
        for (final (index, line) in footer.contactLines.indexed) ...[
          if (index > 0) pw.SizedBox(height: 1),
          pw.Text(line, style: theme.footerContactStyle),
        ],
      ],
    );
  }

  /// The QR code linking back to the digital receipt.
  pw.Widget? _qr(GtPdfReceiptFooter footer) {
    if (footer.qrImage case Uint8List image) {
      return pw.SizedBox(
        width: theme.qrSize,
        height: theme.qrSize,
        child: pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.contain),
      );
    }

    if (!footer.qrData.hasValue) return null;

    return pw.BarcodeWidget(
      barcode: pw.Barcode.qrCode(),
      data: footer.qrData!,
      width: theme.qrSize,
      height: theme.qrSize,
      color: theme.textStrong,
      drawText: false,
    );
  }
}
