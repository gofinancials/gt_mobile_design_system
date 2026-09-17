import 'dart:math' as math;
import 'dart:typed_data';

import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:pdf/widgets.dart' as pw;

/// The ISO 4217 code each currency glyph is normalised to by [gtPdfSafeText].
///
/// The yen glyph is deliberately absent: it is the one mark the apps' own
/// currency tables spell two currencies with — JPY and CNY — so no single code
/// is right, and Latin-1 can set it, so it is left as the caller wrote it. The
/// dollar and pound signs are ambiguous too but take their overwhelmingly
/// common reading; a receipt in another dollar currency should state its code
/// in the amount rather than lean on the glyph.
const _currencyCodes = <String, String>{
  '\u20a6': 'NGN',
  r'$': 'USD',
  '\u20ac': 'EUR',
  '\u00a3': 'GBP',
  '\u20b5': 'GHS',
  '\u20b9': 'INR',
  '\u20bd': 'RUB',
  '\u20a9': 'KRW',
  '\u20aa': 'ILS',
  '\u20ba': 'TRY',
  '\u20ab': 'VND',
  '\u20b4': 'UAH',
  '\u0e3f': 'THB',
  '\u20b1': 'PHP',
  '\u20a1': 'CRC',
  '\u20b8': 'KZT',
};

/// The ASCII spelling each typographic character is transliterated to by
/// [gtPdfSafeText].
///
/// These are the characters that arrive in a narration or a beneficiary name
/// pasted from a word processor, where a plain quote or hyphen was meant.
const _transliterations = <String, String>{
  '\u2018': "'",
  '\u2019': "'",
  '\u201a': "'",
  '\u201b': "'",
  '\u2032': "'",
  '\u201c': '"',
  '\u201d': '"',
  '\u201e': '"',
  '\u201f': '"',
  '\u2033': '"',
  '\u2039': '<',
  '\u203a': '>',
  '\u2013': '-',
  '\u2014': '-',
  '\u2015': '-',
  '\u2212': '-',
  '\u2022': '-',
  '\u2026': '...',
  '\u2044': '/',
  '\u2122': '(TM)',
  '\uffe5': '\u00a5',
  '\u00a0': ' ',
  '\u2007': ' ',
  '\u2009': ' ',
  '\u200a': ' ',
  '\u202f': ' ',
  '\u200b': '',
  '\u00ad': '',
};

/// Every glyph [_currencyCodes] knows, as one alternation.
final _currencyPattern = RegExp(
  _currencyCodes.keys.map(RegExp.escape).join('|'),
);

/// A character a currency code must be spaced away from.
final _wordCharacter = RegExp(r'[0-9A-Za-z]');

/// The character substituted for anything the typeface cannot set.
const _replacementRune = 0x3f;

/// The last rune the typeface can set.
const _lastLatin1Rune = 0xff;

/// Rewrites [value] into text the receipt typeface can actually set.
///
/// Documents are typeset in the `pdf` package's default family — see
/// [GtPdfReceiptTheme] — which carries no glyph above `U+00FF`. Shipping a
/// Unicode face for a receipt is not worth the megabytes, so
/// [GtPdfReceiptBuilder] runs every string it renders through this instead, and
/// the font's limits are handled once where the font is chosen rather than
/// again in every app that exports a receipt.
///
/// Three passes, in order:
///
/// 1. A currency glyph becomes its ISO 4217 code, spaced off the figure it
///    marks, so an amount reads `"NGN 20,000.00"`. That is the intended
///    reading of a receipt amount, not merely a fallback.
/// 2. The typographic characters a pasted narration carries — smart quotes,
///    the dashes, an ellipsis, a bullet, a non-breaking space — are
///    transliterated to their ASCII spellings.
/// 3. Anything still outside the typeface's range becomes a question mark.
///
/// Example usage:
/// ```dart
/// gtPdfSafeText('\u20a620,000.00 \u2014 \u201crent\u201d');
/// // NGN 20,000.00 - "rent"
/// ```
String gtPdfSafeText(String value) {
  if (value.isEmpty) return value;

  var text = value.replaceAllMapped(_currencyPattern, (match) {
    final code = _currencyCodes[match[0]]!;
    final before = match.start > 0 ? value[match.start - 1] : '';
    final after = match.end < value.length ? value[match.end] : '';
    final lead = _wordCharacter.hasMatch(before) ? ' ' : '';
    final trail = _wordCharacter.hasMatch(after) ? ' ' : '';

    return '$lead$code$trail';
  });

  for (final MapEntry(key: from, value: to) in _transliterations.entries) {
    text = text.replaceAll(from, to);
  }

  return String.fromCharCodes(
    text.runes.map((rune) => rune <= _lastLatin1Rune ? rune : _replacementRune),
  );
}

/// Renders a [GtPdfReceiptData] into a paginated PDF document.
///
/// The builder owns layout only; content comes from the data and styling from
/// the [theme]. Delivering the finished document to the user — sharing it,
/// saving it — is [GtPdfReceiptExporter]'s job.
///
/// Spacing is tuned so an ordinary transfer receipt — a details block plus a
/// sender and a recipient, closed by a footer — lands on a single page, with
/// one more grid row of headroom before it spills. Longer receipts
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
              pw.Text(gtPdfSafeText(data.title), style: theme.titleStyle),
              if (data.issuedOn.hasValue) ...[
                pw.SizedBox(height: 8),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: '${gtPdfSafeText(data.displayIssuedOnLabel)} ',
                        style: theme.subtitleLabelStyle,
                      ),
                      pw.TextSpan(
                        text: gtPdfSafeText(data.issuedOn!),
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
      pw.Text(
        gtPdfSafeText(section.title.upper),
        style: theme.sectionTitleStyle,
      ),
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
              ? pw.Text(
                  gtPdfSafeText(section.heading!),
                  style: theme.headingStyle,
                )
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
        pw.Text(gtPdfSafeText(entry.label), style: theme.labelStyle),
        pw.SizedBox(height: _entryGap),
        pw.Text(gtPdfSafeText(entry.value), style: theme.valueStyle),
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
        pw.Text(gtPdfSafeText(footer.disclaimer!), style: theme.footnoteStyle),
      ],
      if (footer.note.hasValue) ...[
        pw.SizedBox(height: _noteGap),
        pw.Text(gtPdfSafeText(footer.note!), style: theme.footnoteStyle),
      ],
    ];
  }

  /// The institution's name, address and contact lines.
  pw.Widget _footerContacts(GtPdfReceiptFooter footer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (footer.title.hasValue) ...[
          pw.Text(gtPdfSafeText(footer.title!), style: theme.footerTitleStyle),
          pw.SizedBox(height: 4),
        ],
        if (footer.address.hasValue) ...[
          pw.Text(
            gtPdfSafeText(footer.address!),
            style: theme.footerAddressStyle,
          ),
          pw.SizedBox(height: 1),
        ],
        for (final (index, line) in footer.contactLines.indexed) ...[
          if (index > 0) pw.SizedBox(height: 1),
          pw.Text(gtPdfSafeText(line), style: theme.footerContactStyle),
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
