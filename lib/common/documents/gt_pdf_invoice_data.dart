import 'dart:typed_data';

import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:pdf/pdf.dart';

/// The pill set beneath an invoice's title, such as "Pending" or "Paid".
///
/// Invoice states belong to the app, not the design system, so the caller
/// names the state and picks its colours. [GtPdfInvoiceStatus.fromVariant]
/// takes those colours from a [GtPillVariant], the way the on-screen receipt
/// pill does, so an exported invoice reads in the same tones as the screen.
class GtPdfInvoiceStatus extends AppEquatable {
  /// The state's name, uppercased when rendered.
  final String label;

  /// The colour of the [label].
  final PdfColor textColor;

  /// The pill's fill.
  final PdfColor backgroundColor;

  /// The pill's outline.
  final PdfColor borderColor;

  /// Creates a [GtPdfInvoiceStatus] from explicit colours.
  const GtPdfInvoiceStatus({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  /// Creates a status coloured as a [GtStatusPill] of [variant] would be in
  /// [palette].
  ///
  /// The away variant reads as a pending state, so, as on [GtReceiptStatusPill],
  /// its label takes the base shade and its outline the light one.
  factory GtPdfInvoiceStatus.fromVariant({
    required String label,
    required GtPillVariant variant,
    required GtPalette palette,
  }) {
    var textColor = variant.getTextColor(palette);
    var borderColor = variant.getBorderColor(palette);

    if (variant == .away) {
      textColor = palette.away.base;
      borderColor = palette.away.light;
    }

    return GtPdfInvoiceStatus(
      label: label,
      textColor: gtPdfColorOf(textColor),
      backgroundColor: gtPdfColorOf(variant.getBgColor(palette)),
      borderColor: gtPdfColorOf(borderColor),
    );
  }

  @override
  List<Object?> get props => [label, textColor, backgroundColor, borderColor];
}

/// A party to an invoice: who it is billed to, or who it is from.
///
/// Rendered as the [name], then the [address], then the [details], each block
/// set a blank line apart and skipped when empty.
class GtPdfInvoiceParty extends AppEquatable {
  /// The party's name, set in bold.
  final String name;

  /// The postal address, one entry per line.
  final List<String> address;

  /// Closing lines such as an email address or a tax identification number.
  final List<String> details;

  /// Creates a [GtPdfInvoiceParty].
  const GtPdfInvoiceParty({
    required this.name,
    this.address = const [],
    this.details = const [],
  });

  @override
  List<Object?> get props => [name, address, details];
}

/// The account an invoice is paid into.
class GtPdfInvoiceAccount extends AppEquatable {
  /// The name the account is held in.
  final String name;

  /// The presentation-ready account number, picked out in the
  /// theme's [GtPdfReceiptTheme.brand] colour.
  final String number;

  /// The bank the account is held at.
  final String? bank;

  /// Creates a [GtPdfInvoiceAccount].
  const GtPdfInvoiceAccount({
    required this.name,
    required this.number,
    this.bank,
  });

  @override
  List<Object?> get props => [name, number, bank];
}

/// A line of an invoice's items table.
///
/// Every value is presentation-ready and printed as given; amounts keep the
/// app's own formatting.
class GtPdfInvoiceItem extends AppEquatable {
  /// What is being charged for.
  final String description;

  /// The price of a single unit.
  final String price;

  /// How many units are charged.
  final String quantity;

  /// The tax rate applied to this line, when one applies.
  ///
  /// Left blank on this line when null. The tax rate column is dropped from
  /// the table altogether when no item carries one.
  final String? taxRate;

  /// The line total.
  final String amount;

  /// Creates a [GtPdfInvoiceItem].
  const GtPdfInvoiceItem({
    required this.description,
    required this.price,
    required this.quantity,
    required this.amount,
    this.taxRate,
  });

  @override
  List<Object?> get props => [description, price, quantity, taxRate, amount];
}

/// The block inviting the customer to pay the invoice online.
///
/// Draws a QR code beside a short [prompt]. When [url] is set, both are a
/// link to it, so a reader who cannot scan the code can tap through instead.
class GtPdfInvoicePayment extends AppEquatable {
  /// Where the invoice is paid. Encoded into the QR code unless [qrImage] is
  /// supplied, and linked from the block.
  final String url;

  /// A pre-rendered QR code, as PNG or JPEG bytes, for callers who mint their
  /// own codes.
  final Uint8List? qrImage;

  /// The copy set beside the QR code.
  final String prompt;

  /// Creates a [GtPdfInvoicePayment].
  const GtPdfInvoicePayment({
    required this.url,
    this.qrImage,
    this.prompt =
        'Scan the code with the camera on your mobile device or click here '
        'to pay online',
  });

  @override
  List<Object?> get props => [url, qrImage, prompt];
}

/// The mark set in the invoice's closing band, beneath a "Powered by" label.
///
/// Supply one of [image] or [svg]; the mark is drawn [height] points tall and
/// as wide as its aspect ratio allows.
class GtPdfInvoicePoweredBy extends AppEquatable {
  /// The mark as PNG or JPEG bytes.
  final Uint8List? image;

  /// The mark as SVG markup. Ignored when [image] is supplied.
  final String? svg;

  /// The height the mark is drawn at.
  final double height;

  /// Creates a [GtPdfInvoicePoweredBy].
  const GtPdfInvoicePoweredBy({this.image, this.svg, this.height = 32})
    : assert(
        image != null || svg != null,
        'GtPdfInvoicePoweredBy requires an image or an svg',
      );

  @override
  List<Object?> get props => [image, svg, height];
}

/// The fixed copy of an invoice.
///
/// English by default. Pass a translated set to [GtPdfInvoiceData.labels] to
/// localise the document.
class GtPdfInvoiceLabels extends AppEquatable {
  /// The document title set at the top right.
  final String title;

  /// The label preceding [GtPdfInvoiceData.number].
  final String number;

  /// The heading over [GtPdfInvoiceData.billedTo].
  final String billedTo;

  /// The heading over [GtPdfInvoiceData.from].
  final String from;

  /// The heading over [GtPdfInvoiceData.account].
  final String account;

  /// The heading over the items table.
  final String items;

  /// The items table's description column heading.
  final String description;

  /// The items table's price column heading.
  final String price;

  /// The items table's quantity column heading.
  final String quantity;

  /// The items table's tax rate column heading.
  final String taxRate;

  /// The items table's amount column heading.
  final String amount;

  /// The label of [GtPdfInvoiceData.subtotal].
  final String subtotal;

  /// The label of [GtPdfInvoiceData.total].
  final String total;

  /// The heading over [GtPdfInvoiceData.payment].
  final String payOnline;

  /// The label over [GtPdfInvoiceData.poweredBy].
  final String poweredBy;

  /// Builds the page count in the closing band, for example "Page 1 of 2".
  final String Function(int page, int pages) pageOf;

  /// Creates a [GtPdfInvoiceLabels].
  const GtPdfInvoiceLabels({
    this.title = 'Invoice',
    this.number = 'Invoice Number:',
    this.billedTo = 'Billed to',
    this.from = 'From',
    this.account = 'Account no:',
    this.items = 'Item',
    this.description = 'Description',
    this.price = 'Price',
    this.quantity = 'Quantity',
    this.taxRate = 'Tax rate',
    this.amount = 'Amount',
    this.subtotal = 'Subtotal',
    this.total = 'Total',
    this.payOnline = 'Pay this invoice online',
    this.poweredBy = 'Powered by',
    this.pageOf = _pageOf,
  });

  static String _pageOf(int page, int pages) => 'Page $page of $pages';

  @override
  List<Object?> get props => [
    title,
    number,
    billedTo,
    from,
    account,
    items,
    description,
    price,
    quantity,
    taxRate,
    amount,
    subtotal,
    total,
    payOnline,
    poweredBy,
    pageOf,
  ];
}

/// The complete content of an exportable PDF invoice.
///
/// Describes what appears on the page — never how it is styled. Colour and
/// page size come from the [GtPdfReceiptTheme] handed to
/// [GtPdfInvoiceBuilder], and delivery to the user is [GtPdfInvoiceExporter]'s
/// job. Every value is presentation-ready and printed as given, after
/// [gtPdfSafeText] has made it settable.
///
/// Example usage:
/// ```dart
/// final data = GtPdfInvoiceData(
///   number: 'INV-001',
///   status: GtPdfInvoiceStatus.fromVariant(
///     label: 'Pending',
///     variant: .away,
///     palette: context.palette,
///   ),
///   details: const [
///     GtPdfReceiptEntry(label: 'Issued on:', value: 'December 15, 2025'),
///     GtPdfReceiptEntry(label: 'Due date:', value: 'December 25, 2025'),
///   ],
///   billedTo: const GtPdfInvoiceParty(name: 'Yahya Bello'),
///   from: const GtPdfInvoiceParty(name: 'Funmilola Joseph'),
///   items: const [
///     GtPdfInvoiceItem(
///       description: 'Design',
///       price: 'NGN 300,000',
///       quantity: '1',
///       amount: 'NGN 300,000',
///     ),
///   ],
///   subtotal: 'NGN 300,000',
///   total: 'NGN 300,000.00',
/// );
/// ```
class GtPdfInvoiceData extends AppEquatable {
  /// The invoice number, for example `"INV-001"`.
  final String number;

  /// The pill beneath the title. Omitted when null.
  final GtPdfInvoiceStatus? status;

  /// The issuer's picture, as PNG or JPEG bytes, drawn as a circle at the top
  /// left. Omitted when null.
  final Uint8List? avatar;

  /// Rows set beneath the [number], such as the issue date and the due or
  /// paid date.
  final List<GtPdfReceiptEntry> details;

  /// Who the invoice is billed to.
  final GtPdfInvoiceParty billedTo;

  /// Who the invoice is from.
  final GtPdfInvoiceParty from;

  /// The account the invoice is paid into. Omitted when null.
  final GtPdfInvoiceAccount? account;

  /// The lines of the items table.
  ///
  /// Must contain at least one item; asserted by [GtPdfInvoiceBuilder] at
  /// render time so this data can still be declared `const`.
  final List<GtPdfInvoiceItem> items;

  /// The sum of the [items], picked out beneath the table. Omitted when null
  /// or empty.
  final String? subtotal;

  /// Rows between the [subtotal] and the [total], such as tax or a discount.
  /// A row with an empty value is skipped.
  final List<GtPdfReceiptEntry> adjustments;

  /// The amount due.
  final String total;

  /// The block inviting the customer to pay online. Omitted when null.
  final GtPdfInvoicePayment? payment;

  /// The mark in the closing band. Omitted, with its label, when null.
  final GtPdfInvoicePoweredBy? poweredBy;

  /// The fixed copy of the document.
  final GtPdfInvoiceLabels labels;

  /// The file name used when the document is shared or saved.
  ///
  /// Slugged before use, like [GtPdfReceiptData.fileName]. Defaults to one
  /// derived from the [number]. See [resolvedFileName].
  final String? fileName;

  /// Creates a [GtPdfInvoiceData].
  const GtPdfInvoiceData({
    required this.number,
    required this.billedTo,
    required this.from,
    required this.items,
    required this.total,
    this.status,
    this.avatar,
    this.details = const [],
    this.account,
    this.subtotal,
    this.adjustments = const [],
    this.payment,
    this.poweredBy,
    this.labels = const GtPdfInvoiceLabels(),
    this.fileName,
  });

  /// The document title, used as the PDF's own title and when sharing.
  String get title => '${labels.title} $number';

  /// The file name used on export, always suffixed with `.pdf`.
  ///
  /// Derived from [fileName] when given and from [number] otherwise, and
  /// slugged by [gtPdfFileName].
  String get resolvedFileName {
    return gtPdfFileName(
      fileName.hasValue ? fileName! : number,
      fallback: 'invoice',
    );
  }

  /// Whether any item carries a tax rate, and so whether the table has a tax
  /// rate column.
  bool get hasTaxRate => items.any((item) => item.taxRate != null);

  @override
  List<Object?> get props => [
    number,
    status,
    avatar,
    details,
    billedTo,
    from,
    account,
    items,
    subtotal,
    adjustments,
    total,
    payment,
    poweredBy,
    labels,
    fileName,
  ];
}
