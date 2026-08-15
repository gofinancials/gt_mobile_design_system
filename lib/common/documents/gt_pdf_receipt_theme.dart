import 'package:flutter/widgets.dart' show Color;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Converts a Flutter [Color] into the [PdfColor] used by the `pdf` package.
///
/// Alpha is preserved, so translucent design tokens survive the crossing.
PdfColor gtPdfColorOf(Color color) => PdfColor.fromInt(color.toARGB32());

/// The typography, colour and page geometry applied to a
/// [GtPdfReceiptData] by [GtPdfReceiptBuilder].
///
/// Kept separate from the receipt content so the same data can be rendered
/// against a light default, an institution's own colours, or the live app
/// palette via [GtPdfReceiptTheme.fromPalette].
///
/// Typefaces are deliberately not configurable. Documents use the `pdf`
/// package's own default family, which is embedded in every reader and needs no
/// assets or async loading; the app's brand faces stay on screen where they
/// belong. That family is Latin-1 only, so content outside that range — a naira
/// sign, a curly quote pasted into a narration — cannot be rendered.
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

  /// The colour of the built-in brand mark drawn when no logo is supplied.
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
    this.brand = const PdfColor.fromInt(0xFFCB0828),
    this.brandAccent = PdfColors.white,
    this.titleSize = 16,
    this.subtitleSize = 10,
    this.sectionTitleSize = 12,
    this.headingSize = 10,
    this.labelSize = 10,
    this.valueSize = 8,
    this.footerSize = 8,
    this.footnoteSize = 8,
    this.pageFormat = PdfPageFormat.a4,
    this.pagePadding = const pw.EdgeInsets.fromLTRB(60, 70, 60, 50),
    this.logoSize = 42,
    this.qrSize = 36,
  });

  /// The default light theme, matching the design system's receipt spec.
  const GtPdfReceiptTheme.light() : this();

  /// Derives a theme from the live app [palette] so an exported receipt matches
  /// the screen it was exported from.
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
      brand: gtPdfColorOf(palette.primary.base),
      brandAccent: gtPdfColorOf(palette.text.white),
      pageFormat: pageFormat,
    );
  }

  /// The base `pdf` theme used for the document.
  ///
  /// Built from the package default so every widget inherits the standard
  /// family, with only size and colour overridden.
  pw.ThemeData get pdfTheme {
    return pw.ThemeData.base().copyWith(
      defaultTextStyle: pw.TextStyle(
        fontSize: valueSize,
        color: textSub,
        lineSpacing: 1.5,
        font: pw.Font.helvetica(),
        fontBold: pw.Font.helveticaBold(),
      ),
    );
  }

  /// The style of the document title.
  pw.TextStyle get titleStyle =>
      pw.TextStyle(fontSize: titleSize, color: textStrong);

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
  pw.TextStyle get sectionTitleStyle => pw.TextStyle(
    fontSize: sectionTitleSize,
    color: textSoft,
    letterSpacing: 0.6,
  );

  /// The style of the emphasised heading inside a split section.
  pw.TextStyle get headingStyle => pw.TextStyle(
    fontSize: headingSize,
    color: textStrong,
    letterSpacing: 0.4,
  );

  /// The style of entry labels.
  pw.TextStyle get labelStyle =>
      pw.TextStyle(fontSize: labelSize, color: textStrong);

  /// The style of entry values.
  pw.TextStyle get valueStyle =>
      pw.TextStyle(fontSize: valueSize, color: textSub);

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
    PdfColor? brand,
    PdfColor? brandAccent,
    double? titleSize,
    double? subtitleSize,
    double? sectionTitleSize,
    double? headingSize,
    double? labelSize,
    double? valueSize,
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
      brand: brand ?? this.brand,
      brandAccent: brandAccent ?? this.brandAccent,
      titleSize: titleSize ?? this.titleSize,
      subtitleSize: subtitleSize ?? this.subtitleSize,
      sectionTitleSize: sectionTitleSize ?? this.sectionTitleSize,
      headingSize: headingSize ?? this.headingSize,
      labelSize: labelSize ?? this.labelSize,
      valueSize: valueSize ?? this.valueSize,
      footerSize: footerSize ?? this.footerSize,
      footnoteSize: footnoteSize ?? this.footnoteSize,
      pageFormat: pageFormat ?? this.pageFormat,
      pagePadding: pagePadding ?? this.pagePadding,
      logoSize: logoSize ?? this.logoSize,
      qrSize: qrSize ?? this.qrSize,
    );
  }
}
