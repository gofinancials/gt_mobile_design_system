import 'dart:typed_data';

import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Slugs [source] into a file name for an exported PDF, always suffixed with
/// `.pdf`.
///
/// Letters, digits, dots, underscores and hyphens are kept as they were
/// written, while every other run of characters collapses to a single
/// underscore and any separator left at either edge is dropped. A `.pdf` the
/// caller already wrote is not slugged into the name, and a source with
/// nothing usable left falls back to [fallback].
String gtPdfFileName(String source, {String fallback = 'receipt'}) {
  final base = source.trim().replaceAll(
    RegExp(r'\.pdf$', caseSensitive: false),
    '',
  );
  final slug = base.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');
  final trimmed = slug.replaceAll(RegExp(r'^[._-]+|[._-]+$'), '');
  final name = trimmed.hasValue ? trimmed : fallback;
  return '$name.pdf';
}

/// A single label/value pair within a [GtPdfReceiptSection].
///
/// Values are never formatted here. As everywhere else in the design system,
/// callers pass presentation-ready strings — amounts already grouped, dates
/// already formatted, account numbers already masked. What the document
/// typeface cannot set is the one thing they need not handle; see [value].
class GtPdfReceiptEntry extends AppEquatable {
  /// The row label, for example `"Amount"`.
  final String label;

  /// The presentation-ready value, for example `"20,000.00 NGN"`.
  ///
  /// A value carrying a currency glyph or the typography of a pasted narration
  /// needs no cleaning up first: [GtPdfReceiptBuilder] runs it through
  /// [gtPdfSafeText] at render time, which normalises a glyph to its currency
  /// code and transliterates what the document typeface cannot set.
  final String value;

  /// Creates a [GtPdfReceiptEntry].
  const GtPdfReceiptEntry({required this.label, required this.value});

  /// Creates an entry from the [GtReceiptTileData] used by on-screen receipts,
  /// so a confirmation screen and its exported PDF share a single source of
  /// truth.
  GtPdfReceiptEntry.fromTile(GtReceiptTileData tile)
    : label = tile.label,
      value = tile.value;

  @override
  List<Object?> get props => [label, value];
}

/// How a [GtPdfReceiptSection] arranges its entries on the page.
enum GtPdfReceiptSectionLayout {
  /// Entries flow across [GtPdfReceiptSection.columns] columns, row-major.
  ///
  /// Used for detail blocks such as "Transfer Details", where every row
  /// carries equal weight.
  grid,

  /// [GtPdfReceiptSection.heading] fills the leading column while the entries
  /// stack down the trailing one.
  ///
  /// Used for party blocks such as "Sender Details", where a name is set
  /// against the account it belongs to.
  split,
}

/// A titled block of a PDF receipt.
///
/// Mirrors [GtConfirmationSection], the on-screen equivalent, so the same
/// transaction can be rendered to a screen and to a document without the two
/// drifting apart.
///
/// Example usage:
/// ```dart
/// const GtPdfReceiptSection(
///   title: "Sender Details",
///   heading: "OLALEKAN OMOLUABI",
///   entries: [
///     GtPdfReceiptEntry(label: "Account number", value: "******5678"),
///     GtPdfReceiptEntry(label: "Bank Name", value: "STERLING BANK"),
///   ],
/// )
/// ```
class GtPdfReceiptSection extends AppEquatable {
  /// The section heading, uppercased when rendered.
  final String title;

  /// An optional emphasised line, typically a party name.
  ///
  /// Supplying one switches the section to
  /// [GtPdfReceiptSectionLayout.split] unless [layout] says otherwise.
  final String? heading;

  /// The label/value rows rendered beneath the [title].
  final List<GtPdfReceiptEntry> entries;

  /// How the [entries] are arranged.
  ///
  /// Defaults to [GtPdfReceiptSectionLayout.split] when a [heading] is present
  /// and [GtPdfReceiptSectionLayout.grid] otherwise. See [resolvedLayout].
  final GtPdfReceiptSectionLayout? layout;

  /// The number of columns used by [GtPdfReceiptSectionLayout.grid].
  ///
  /// Must be at least one; asserted by the renderer at build time.
  final int columns;

  /// Creates a [GtPdfReceiptSection].
  const GtPdfReceiptSection({
    required this.title,
    required this.entries,
    this.heading,
    this.layout,
    this.columns = 2,
  });

  /// Creates a section from the [GtConfirmationSection] used by
  /// [GtConfirmationBody].
  GtPdfReceiptSection.fromConfirmation(
    GtConfirmationSection section, {
    this.heading,
    this.layout,
    this.columns = 2,
  }) : title = section.title,
       entries = section.tiles.map(GtPdfReceiptEntry.fromTile).toList();

  /// The layout actually used when rendering, resolving the [layout] default.
  GtPdfReceiptSectionLayout get resolvedLayout =>
      layout ?? (heading.hasValue ? .split : .grid);

  @override
  List<Object?> get props => [title, heading, entries, layout, columns];
}

/// The closing block of a PDF receipt.
///
/// Carries the issuing institution's contact details, an optional QR code
/// linking back to the digital receipt, and the legal fine print. Every field
/// is optional; a footer with no content at all is skipped — see [hasContent].
class GtPdfReceiptFooter extends AppEquatable {
  /// A bold lead-in above the contact block, for example
  /// `"Sterling Bank Address"`.
  final String? title;

  /// The emphasised first contact line, typically a street address.
  final String? address;

  /// Softer contact lines rendered beneath the [address], such as a support
  /// email and phone numbers.
  final List<String> contactLines;

  /// The payload encoded into a QR code rendered opposite the contact block.
  ///
  /// Ignored when [qrImage] is supplied.
  final String? qrData;

  /// A pre-rendered QR code, as PNG or JPEG bytes.
  ///
  /// Takes precedence over [qrData], for callers who mint their own codes.
  final Uint8List? qrImage;

  /// The legal fine print rendered beneath the contact block.
  final String? disclaimer;

  /// A short closing line rendered beneath the [disclaimer].
  final String? note;

  /// Creates a [GtPdfReceiptFooter].
  const GtPdfReceiptFooter({
    this.title,
    this.address,
    this.contactLines = const [],
    this.qrData,
    this.qrImage,
    this.disclaimer,
    this.note,
  });

  /// Whether this footer carries anything worth rendering.
  bool get hasContent =>
      title.hasValue ||
      address.hasValue ||
      contactLines.hasValue ||
      disclaimer.hasValue ||
      note.hasValue ||
      hasQr;

  /// Whether a QR code should be drawn, from either [qrImage] or [qrData].
  bool get hasQr => qrImage != null || qrData.hasValue;

  /// Whether the contact block — [title], [address] and [contactLines] — has
  /// anything to render.
  bool get hasContactBlock =>
      title.hasValue || address.hasValue || contactLines.hasValue;

  @override
  List<Object?> get props => [
    title,
    address,
    contactLines,
    qrData,
    qrImage,
    disclaimer,
    note,
  ];
}

/// The complete content of an exportable PDF receipt.
///
/// Describes what appears on the page — never how it is styled. Typography,
/// colour and page geometry live in [GtPdfReceiptTheme]; the rendering itself
/// is [GtPdfReceiptBuilder]'s job, and delivery to the user is
/// [GtPdfReceiptExporter]'s.
///
/// Example usage:
/// ```dart
/// const data = GtPdfReceiptData(
///   title: "Transfer Confirmation",
///   issuedOn: "03.10.2025",
///   sections: [
///     GtPdfReceiptSection(
///       title: "Transfer Details",
///       entries: [
///         GtPdfReceiptEntry(label: "Transfer Type", value: "Instant bank transfer"),
///         GtPdfReceiptEntry(label: "Amount", value: "20,000.00 NGN"),
///       ],
///     ),
///   ],
///   footer: GtPdfReceiptFooter(
///     title: "Sterling Bank Address",
///     address: "Sterling Towers, 20 Marina, Lagos Island, Lagos, Nigeria",
///     contactLines: ["customercare@sterling.ng", "02018888822, 07008220000"],
///     qrData: "https://sterling.ng/receipts/81a0cf3b",
///   ),
/// );
/// ```
class GtPdfReceiptData extends AppEquatable {
  /// The document title, set at the head of the first page.
  final String title;

  /// The presentation-ready issue date, for example `"03.10.2025"`.
  ///
  /// Never formatted here; callers pass the string they want printed.
  final String? issuedOn;

  /// The label preceding [issuedOn].
  ///
  /// Defaults to a localised "issuedOn" string. See [displayIssuedOnLabel].
  final String? issuedOnLabel;

  /// An institution logo rendered at the top-right, as PNG or JPEG bytes.
  ///
  /// When null the built-in brand mark is drawn instead, unless
  /// [showBrandMark] is false.
  final Uint8List? logo;

  /// Whether to fall back to the built-in brand mark when [logo] is null.
  final bool showBrandMark;

  /// The titled blocks that make up the body of the receipt.
  ///
  /// Must contain at least one section; asserted by [GtPdfReceiptBuilder] at
  /// render time rather than here, because `List.length` is not const-evaluable
  /// and asserting on it would prevent callers from declaring this data
  /// `const`.
  final List<GtPdfReceiptSection> sections;

  /// The optional closing block.
  final GtPdfReceiptFooter? footer;

  /// The file name used when the document is shared or saved.
  ///
  /// Slugged before use, so a transaction reference or a title carrying
  /// spaces, punctuation or an accent is safe to pass straight through. The
  /// case, dots, underscores and hyphens inside a reference survive the slug
  /// unchanged, so an app quoting a reference back to the user does not need a
  /// file name helper of its own. Any `.pdf` suffix is optional. Defaults to a
  /// slug derived from [title]. See [resolvedFileName].
  final String? fileName;

  /// Creates a [GtPdfReceiptData].
  const GtPdfReceiptData({
    required this.title,
    required this.sections,
    this.issuedOn,
    this.issuedOnLabel,
    this.logo,
    this.showBrandMark = true,
    this.footer,
    this.fileName,
  });

  /// The label rendered before [issuedOn].
  String get displayIssuedOnLabel => issuedOnLabel ?? 'issuedOn'.ctr();

  /// The file name used on export, always suffixed with `.pdf`.
  ///
  /// Derived from [fileName] when given and from [title] otherwise. Either way
  /// letters, digits, dots, underscores and hyphens are kept as they were
  /// written — a receipt names a record before it reads as a slug, and the case
  /// of a transaction reference is part of that record — while every other run
  /// of characters collapses to a single underscore, and any separator left at
  /// either edge is dropped. A caller-supplied name goes through the same slug
  /// as a derived one, so no app has to pre-slug a reference of its own; a
  /// `.pdf` the caller already wrote is not slugged into the name.
  String get resolvedFileName {
    return gtPdfFileName(fileName.hasValue ? fileName! : title);
  }

  @override
  List<Object?> get props => [
    title,
    issuedOn,
    issuedOnLabel,
    logo,
    showBrandMark,
    sections,
    footer,
    fileName,
  ];
}
