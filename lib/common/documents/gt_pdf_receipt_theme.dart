import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show Color;
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Converts a Flutter [Color] into the [PdfColor] used by the `pdf` package.
///
/// Alpha is preserved, so translucent design tokens survive the crossing.
PdfColor gtPdfColorOf(Color color) => PdfColor.fromInt(color.toARGB32());

/// The faces a document is typeset in.
///
/// Documents follow the design system's Open Runde, in the two weights the
/// document specs use: [medium] for running copy, labels and values, and
/// [semibold] for the title and other emphasised lead-ins. Text styled
/// `pw.FontWeight.bold` is set in [semibold]; everything else in [medium].
///
/// The app's own font files are CFF-flavoured OpenType, which the `pdf`
/// package cannot embed, so the package ships TrueType builds of these two
/// weights for documents alone, cut down to the Latin-1 range
/// [gtPdfSafeText] already confines document text to. Each embeds as a
/// subset of the glyphs a document actually uses.
///
/// [GtPdfReceiptBuilder.render] and [GtPdfInvoiceBuilder.render] load the
/// faces themselves; [load] is only needed to pass them to `build`.
///
/// Example usage:
/// ```dart
/// final typeface = await GtPdfTypeface.load();
/// final document = const GtPdfReceiptBuilder().build(data, typeface: typeface);
/// ```
class GtPdfTypeface {
  /// The face for running copy, labels and values.
  final pw.Font medium;

  /// The face for the title and emphasised lead-ins.
  final pw.Font semibold;

  /// Creates a [GtPdfTypeface].
  const GtPdfTypeface({required this.medium, required this.semibold});

  static const _path = 'packages/gt_mobile_ui/assets/fonts';

  static Future<GtPdfTypeface>? _openRunde;

  /// Loads the design system's Open Runde faces.
  ///
  /// The faces are read from the package's assets once and reused by every
  /// document after; a failed read is not cached, so the next call retries.
  static Future<GtPdfTypeface> load() => _openRunde ??= _loadOpenRunde();

  static Future<GtPdfTypeface> _loadOpenRunde() async {
    try {
      final medium = await rootBundle.load('$_path/OpenRunde-Medium.ttf');
      final semibold = await rootBundle.load('$_path/OpenRunde-Semibold.ttf');

      return GtPdfTypeface(
        medium: pw.Font.ttf(medium),
        semibold: pw.Font.ttf(semibold),
      );
    } catch (_) {
      _openRunde = null;
      rethrow;
    }
  }
}

/// The typography, colour and page geometry applied to a
/// [GtPdfReceiptData] by [GtPdfReceiptBuilder], and to a [GtPdfInvoiceData] by
/// [GtPdfInvoiceBuilder].
///
/// Kept separate from the receipt content so the same data can be rendered
/// against a light default, an institution's own colours, or an app palette
/// via [GtPdfReceiptTheme.fromPalette].
///
/// Documents are printed, emailed and opened in readers that ignore the app's
/// appearance, so they are white with dark text unless the caller opts out.
/// To keep the brand without the mode, theme from the brand's light palette:
///
/// ```dart
/// GtPdfReceiptTheme.fromPalette(context.themeData.lightPalette);
/// ```
///
/// Passing the live `context.palette` instead is the explicit way to make a
/// document follow dark mode.
///
/// Typefaces are deliberately not part of the theme. Documents are set in the
/// design system's Open Runde — see [GtPdfTypeface] — at the weights the
/// design specifies, so a document carries the same hierarchy as the screen
/// it was exported from. A document built without a [GtPdfTypeface] falls
/// back to the `pdf` package's default family, which every reader carries.
/// Either way only Latin-1 is set, so content outside that range — a naira
/// sign, a curly quote pasted into a narration — is never rendered as is;
/// callers do not have to guard against that themselves, because
/// [GtPdfReceiptBuilder] runs every string it renders through [gtPdfSafeText]
/// first.
class GtPdfReceiptTheme {
  /// The page background.
  final PdfColor pageColor;

  /// The colour of titles, labels and other emphasised copy.
  final PdfColor textStrong;

  /// The colour of values and secondary copy.
  final PdfColor textSub;

  /// The colour of section headings, fine print and other de-emphasised copy.
  final PdfColor textSoft;

  /// The colour of the hairlines separating sections.
  final PdfColor divider;

  /// The colour of the faintest copy, such as an invoice's detail labels.
  final PdfColor textDisabled;

  /// The fill of the band an invoice closes on.
  final PdfColor band;

  /// The brand colour: the receipt's built-in mark when no logo is supplied,
  /// and the accent picking out an invoice's account number and subtotal.
  final PdfColor brand;

  /// The colour of the cut-out inside the built-in brand mark.
  final PdfColor brandAccent;

  /// The document title size.
  final double titleSize;

  /// The size of the issue date line beneath the title.
  final double subtitleSize;

  /// The size of uppercased section headings.
  final double sectionTitleSize;

  /// The size of the emphasised heading inside a split section.
  final double headingSize;

  /// The size of entry labels.
  final double labelSize;

  /// The size of entry values.
  final double valueSize;

  /// The reading size of running text, such as the clauses of an agreement.
  final double bodySize;

  /// The size of footer contact copy.
  final double footerSize;

  /// The size of the disclaimer and closing note.
  final double footnoteSize;

  /// The page size the document is laid out against.
  final PdfPageFormat pageFormat;

  /// The margin between the page edge and the content.
  final pw.EdgeInsets pagePadding;

  /// The width and height of the brand mark or logo in the header.
  final double logoSize;

  /// The width and height of the footer QR code.
  final double qrSize;

  /// Creates a [GtPdfReceiptTheme].
  const GtPdfReceiptTheme({
    this.pageColor = PdfColors.white,
    this.textStrong = const PdfColor.fromInt(0xFF1B1B1B),
    this.textSub = const PdfColor.fromInt(0xFF666666),
    this.textSoft = const PdfColor.fromInt(0xFF808080),
    this.divider = const PdfColor.fromInt(0xFF000000),
    this.textDisabled = const PdfColor.fromInt(0xFFA3A3A3),
    this.band = const PdfColor.fromInt(0xFFF7F7F7),
    this.brand = const PdfColor.fromInt(0xFFCB0828),
    this.brandAccent = PdfColors.white,
    this.titleSize = 16,
    this.subtitleSize = 10,
    this.sectionTitleSize = 12,
    this.headingSize = 10,
    this.labelSize = 10,
    this.valueSize = 8,
    this.bodySize = 10,
    this.footerSize = 8,
    this.footnoteSize = 8,
    this.pageFormat = PdfPageFormat.a4,
    this.pagePadding = const pw.EdgeInsets.fromLTRB(60, 70, 60, 50),
    this.logoSize = 42,
    this.qrSize = 36,
  });

  /// The default light theme, matching the design system's receipt spec.
  const GtPdfReceiptTheme.light() : this();

  /// Derives a theme from [palette].
  ///
  /// Every colour comes from the palette as given, page included, so a dark
  /// palette yields a dark document. Pass the brand's light palette
  /// (`context.themeData.lightPalette`) for the usual white page in the
  /// brand's colours, and the live `context.palette` only when the document
  /// should follow the app into dark mode.
  ///
  /// Only colour is taken from the palette; sizes and page geometry keep their
  /// defaults unless overridden.
  factory GtPdfReceiptTheme.fromPalette(
    GtPalette palette, {
    PdfPageFormat pageFormat = PdfPageFormat.a4,
  }) {
    return GtPdfReceiptTheme(
      pageColor: gtPdfColorOf(palette.bg.white),
      textStrong: gtPdfColorOf(palette.text.strong),
      textSub: gtPdfColorOf(palette.text.sub),
      textSoft: gtPdfColorOf(palette.text.soft),
      divider: gtPdfColorOf(palette.stroke.strong),
      textDisabled: gtPdfColorOf(palette.text.disabled),
      band: gtPdfColorOf(palette.bg.weak),
      brand: gtPdfColorOf(palette.primary.base),
      brandAccent: gtPdfColorOf(palette.text.white),
      pageFormat: pageFormat,
    );
  }

  /// The base `pdf` theme used for the document, set in [typeface].
  ///
  /// Every widget inherits [GtPdfTypeface.medium], and text styled
  /// `pw.FontWeight.bold` takes [GtPdfTypeface.semibold]. Without a
  /// [typeface] the package's default family stands in, in its regular and
  /// bold cuts.
  pw.ThemeData pdfTheme([GtPdfTypeface? typeface]) {
    return pw.ThemeData.base().copyWith(
      defaultTextStyle: pw.TextStyle(
        fontSize: valueSize,
        color: textSub,
        lineSpacing: 1.5,
        fontNormal: typeface?.medium ?? pw.Font.helvetica(),
        fontBold: typeface?.semibold ?? pw.Font.helveticaBold(),
      ),
    );
  }

  /// The style of the document title.
  pw.TextStyle get titleStyle => pw.TextStyle(
    fontSize: titleSize,
    color: textStrong,
    fontWeight: pw.FontWeight.bold,
  );

  /// The style of the "Issued on" label.
  pw.TextStyle get subtitleLabelStyle =>
      pw.TextStyle(fontSize: subtitleSize, color: textSoft);

  /// The style of the issue date itself.
  pw.TextStyle get subtitleStyle => pw.TextStyle(
    fontSize: subtitleSize,
    color: textStrong,
    letterSpacing: 1.4,
  );

  /// The style of uppercased section headings.
  pw.TextStyle get sectionTitleStyle =>
      pw.TextStyle(fontSize: sectionTitleSize, color: textSoft);

  /// The style of the emphasised heading inside a split section.
  pw.TextStyle get headingStyle =>
      pw.TextStyle(fontSize: headingSize, color: textStrong);

  /// The style of entry labels.
  pw.TextStyle get labelStyle =>
      pw.TextStyle(fontSize: labelSize, color: textStrong);

  /// The style of entry values.
  pw.TextStyle get valueStyle =>
      pw.TextStyle(fontSize: valueSize, color: textSub);

  /// The style of running text.
  pw.TextStyle get bodyStyle =>
      pw.TextStyle(fontSize: bodySize, color: textSub, lineSpacing: 2.5);

  /// The style of the heading leading a run of [bodyStyle] text, such as a
  /// clause title, set apart by colour alone as the agreement screens do.
  pw.TextStyle get bodyHeadingStyle => bodyStyle.copyWith(color: textStrong);

  /// The style of the footer's bold lead-in.
  pw.TextStyle get footerTitleStyle => pw.TextStyle(
    fontSize: footerSize,
    color: textStrong,
    fontWeight: pw.FontWeight.bold,
  );

  /// The style of the footer's emphasised address line.
  pw.TextStyle get footerAddressStyle =>
      pw.TextStyle(fontSize: footerSize, color: textStrong);

  /// The style of the footer's softer contact lines.
  pw.TextStyle get footerContactStyle =>
      pw.TextStyle(fontSize: footerSize, color: textSoft);

  /// The style of the disclaimer and closing note.
  pw.TextStyle get footnoteStyle =>
      pw.TextStyle(fontSize: footnoteSize, color: textSoft, lineSpacing: 1.5);

  /// Returns a copy of this theme with the given fields replaced.
  GtPdfReceiptTheme copyWith({
    PdfColor? pageColor,
    PdfColor? textStrong,
    PdfColor? textSub,
    PdfColor? textSoft,
    PdfColor? divider,
    PdfColor? textDisabled,
    PdfColor? band,
    PdfColor? brand,
    PdfColor? brandAccent,
    double? titleSize,
    double? subtitleSize,
    double? sectionTitleSize,
    double? headingSize,
    double? labelSize,
    double? valueSize,
    double? bodySize,
    double? footerSize,
    double? footnoteSize,
    PdfPageFormat? pageFormat,
    pw.EdgeInsets? pagePadding,
    double? logoSize,
    double? qrSize,
  }) {
    return GtPdfReceiptTheme(
      pageColor: pageColor ?? this.pageColor,
      textStrong: textStrong ?? this.textStrong,
      textSub: textSub ?? this.textSub,
      textSoft: textSoft ?? this.textSoft,
      divider: divider ?? this.divider,
      textDisabled: textDisabled ?? this.textDisabled,
      band: band ?? this.band,
      brand: brand ?? this.brand,
      brandAccent: brandAccent ?? this.brandAccent,
      titleSize: titleSize ?? this.titleSize,
      subtitleSize: subtitleSize ?? this.subtitleSize,
      sectionTitleSize: sectionTitleSize ?? this.sectionTitleSize,
      headingSize: headingSize ?? this.headingSize,
      labelSize: labelSize ?? this.labelSize,
      valueSize: valueSize ?? this.valueSize,
      bodySize: bodySize ?? this.bodySize,
      footerSize: footerSize ?? this.footerSize,
      footnoteSize: footnoteSize ?? this.footnoteSize,
      pageFormat: pageFormat ?? this.pageFormat,
      pagePadding: pagePadding ?? this.pagePadding,
      logoSize: logoSize ?? this.logoSize,
      qrSize: qrSize ?? this.qrSize,
    );
  }
}
