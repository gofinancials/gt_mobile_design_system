import 'dart:typed_data';

import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/documents.dart';

/// The customer a statement is addressed to, set at the top left of the first
/// page.
class GtPdfStatementHolder extends AppEquatable {
  /// The account holder's name, set as the lead line.
  final String name;

  /// The postal address, one entry per line.
  final List<String> address;

  /// Creates a [GtPdfStatementHolder].
  const GtPdfStatementHolder({required this.name, this.address = const []});

  @override
  List<Object?> get props => [name, address];
}

/// A row of a statement's Balance Summary table.
///
/// Every value is presentation-ready and printed as given; amounts keep the
/// app's own formatting.
class GtPdfStatementSummaryRow extends AppEquatable {
  /// The product's name, such as "Savings Account".
  final String product;

  /// The account number set beneath the [product]. Omitted when null or empty.
  final String? accountNumber;

  /// The balance at the start of the period.
  final String openingBalance;

  /// The sum of the debits over the period.
  final String totalOutgoings;

  /// The sum of the credits over the period.
  final String totalDeposits;

  /// The balance at the end of the period.
  final String closingBalance;

  /// Creates a [GtPdfStatementSummaryRow].
  const GtPdfStatementSummaryRow({
    required this.product,
    required this.openingBalance,
    required this.totalOutgoings,
    required this.totalDeposits,
    required this.closingBalance,
    this.accountNumber,
  });

  @override
  List<Object?> get props => [
    product,
    accountNumber,
    openingBalance,
    totalOutgoings,
    totalDeposits,
    closingBalance,
  ];
}

/// A row of a statement's transaction table.
///
/// Every value is presentation-ready and printed as given, except that the
/// [amount] is signed by the builder from [isCredit].
class GtPdfStatementTransaction extends AppEquatable {
  /// The date the transaction posted, for example `"01/03/2026"`.
  final String date;

  /// What the transaction was, set bold at the head of the description, for
  /// example `"Payment from Francis Lobaloba"`.
  final String title;

  /// Lines set beneath the [title], such as the transaction ID, the other
  /// party, a reference or a masked card number. May be empty.
  final List<String> details;

  /// The amount moved, unsigned, for example `"₦1,000,000"`.
  ///
  /// The builder signs it from [isCredit]: `+` for a credit, `-` for a debit.
  /// A sign already leading the string is dropped first, so an amount the app
  /// formats with its own sign is not signed twice.
  final String amount;

  /// Whether money came into the account, which signs the [amount] `+` and
  /// draws it in [GtPdfReceiptTheme.success]. A debit is signed `-` and drawn
  /// in ink.
  final bool isCredit;

  /// The account balance once the transaction posted.
  final String balance;

  /// Creates a [GtPdfStatementTransaction].
  const GtPdfStatementTransaction({
    required this.date,
    required this.title,
    required this.amount,
    required this.isCredit,
    required this.balance,
    this.details = const [],
  });

  @override
  List<Object?> get props => [date, title, details, amount, isCredit, balance];
}

/// The band closing every page of a statement.
///
/// The contact block on the left, an optional QR code on the right, and
/// beneath them the [copyright] opposite the page count. Every field is
/// optional; the page count is always drawn.
class GtPdfStatementFooter extends AppEquatable {
  /// A bold lead-in above the address, for example `"Sterling Bank Address"`.
  final String? title;

  /// The institution's postal address, one entry per line.
  final List<String> address;

  /// Softer lines beneath the [address], such as a support email and phone
  /// numbers.
  final List<String> contactLines;

  /// The payload encoded into the QR code. No QR code, and no space for one,
  /// when null or empty.
  final String? qrData;

  /// The copyright line set opposite the page count, for example
  /// `"© 2026 Sterling Bank"`.
  final String? copyright;

  /// Creates a [GtPdfStatementFooter].
  const GtPdfStatementFooter({
    this.title,
    this.address = const [],
    this.contactLines = const [],
    this.qrData,
    this.copyright,
  });

  /// Whether the contact block — [title], [address] and [contactLines] — has
  /// anything to render.
  bool get hasContactBlock =>
      title.hasValue || address.hasValue || contactLines.hasValue;

  /// Whether a QR code is drawn.
  bool get hasQr => qrData.hasValue;

  @override
  List<Object?> get props => [title, address, contactLines, qrData, copyright];
}

/// The fixed copy of a statement.
///
/// English by default. Pass a translated set to [GtPdfStatementData.labels] to
/// localise the document.
///
/// *Note: [GtPdfStatementBuilder.render] lays the statement out on a
/// background isolate, so [transactionSummary] and [pageOf] are sent to it.
/// Pass top-level or static functions, or closures over plain values — never
/// one that captures a `BuildContext` or other state that cannot leave the
/// main isolate.*
class GtPdfStatementLabels extends AppEquatable {
  /// The heading over the Balance Summary table.
  final String balanceSummary;

  /// Builds the heading over the transaction table from
  /// [GtPdfStatementData.period], for example
  /// "Account Transaction Summary (01/03/2026 - 10/03/2026)".
  final String Function(String period) transactionSummary;

  /// The summary table's product column heading.
  final String product;

  /// The summary table's opening balance column heading.
  final String openingBalance;

  /// The summary table's total outgoings column heading.
  final String totalOutgoings;

  /// The summary table's total deposits column heading.
  final String totalDeposits;

  /// The summary table's closing balance column heading.
  final String closingBalance;

  /// The transaction table's date column heading.
  final String date;

  /// The transaction table's description column heading.
  final String description;

  /// The transaction table's amount column heading.
  final String amount;

  /// The transaction table's balance column heading.
  final String balance;

  /// The line set beneath the transaction table's headings when the period
  /// has no transactions.
  final String noTransactions;

  /// Builds the page count in the footer, for example "Page 1 of 2".
  final String Function(int page, int pages) pageOf;

  /// Creates a [GtPdfStatementLabels].
  const GtPdfStatementLabels({
    this.balanceSummary = 'Balance Summary',
    this.transactionSummary = _transactionSummary,
    this.product = 'Product',
    this.openingBalance = 'Opening Balance',
    this.totalOutgoings = 'Total Outgoings',
    this.totalDeposits = 'Total Deposits',
    this.closingBalance = 'Closing Balance',
    this.date = 'Date',
    this.description = 'Description',
    this.amount = 'Amount',
    this.balance = 'Balance',
    this.noTransactions = 'No transactions in this period',
    this.pageOf = _pageOf,
  });

  static String _transactionSummary(String period) {
    return 'Account Transaction Summary ($period)';
  }

  static String _pageOf(int page, int pages) => 'Page $page of $pages';

  @override
  List<Object?> get props => [
    balanceSummary,
    transactionSummary,
    product,
    openingBalance,
    totalOutgoings,
    totalDeposits,
    closingBalance,
    date,
    description,
    amount,
    balance,
    noTransactions,
    pageOf,
  ];
}

/// The complete content of an exportable PDF account statement.
///
/// Describes what appears on the page — never how it is styled. Colour and
/// page size come from the [GtPdfReceiptTheme] handed to
/// [GtPdfStatementBuilder], and delivery to the user is
/// [GtPdfStatementExporter]'s job. Every value is presentation-ready and
/// printed as given, after [gtPdfSafeText] has made it settable: the caller
/// formats dates and amounts, as it does for an invoice.
///
/// Example usage:
/// ```dart
/// const data = GtPdfStatementData(
///   title: 'Savings Account Statement',
///   period: '01/03/2026 - 10/03/2026',
///   holder: GtPdfStatementHolder(
///     name: 'Alex Lobaloba',
///     address: ['210 Sanusi Street', 'Surulere, Lagos'],
///   ),
///   details: [
///     GtPdfReceiptEntry(label: 'Account Number', value: '0123456789'),
///   ],
///   summary: [
///     GtPdfStatementSummaryRow(
///       product: 'Savings Account',
///       accountNumber: '0123456789',
///       openingBalance: '₦1,200,000,000',
///       totalOutgoings: '₦19,000,123',
///       totalDeposits: '₦19,000,123',
///       closingBalance: '₦19,000,123',
///     ),
///   ],
///   transactions: [
///     GtPdfStatementTransaction(
///       date: '01/03/2026',
///       title: 'Payment from Francis Lobaloba',
///       details: ['Transaction ID: TRX24072983910527NG'],
///       amount: '₦1,000,000',
///       isCredit: true,
///       balance: '₦1,200,000,000',
///     ),
///   ],
/// );
/// ```
class GtPdfStatementData extends AppEquatable {
  /// The document title, for example `"Savings Account Statement"`, set at the
  /// head of every page.
  final String title;

  /// The presentation-ready period the statement covers, for example
  /// `"01/03/2026 - 10/03/2026"`. Set beneath the [title] and in the heading
  /// over the transaction table.
  final String period;

  /// The customer the statement is addressed to.
  final GtPdfStatementHolder holder;

  /// Labelled values set opposite the [holder], such as the account number
  /// and sort code. An entry with an empty value is skipped.
  final List<GtPdfReceiptEntry> details;

  /// The rows of the Balance Summary table.
  ///
  /// Must contain at least one row; asserted by [GtPdfStatementBuilder] at
  /// render time so this data can still be declared `const`.
  final List<GtPdfStatementSummaryRow> summary;

  /// The rows of the transaction table, in the order they are printed.
  ///
  /// May be empty, in which case the table carries
  /// [GtPdfStatementLabels.noTransactions] beneath its headings. Has no upper
  /// bound: the table runs on to as many pages as it needs.
  final List<GtPdfStatementTransaction> transactions;

  /// The band closing every page. Only the page count is drawn when null.
  final GtPdfStatementFooter? footer;

  /// An institution logo set at the top right of every page, as PNG or JPEG
  /// bytes.
  ///
  /// When null the built-in brand mark is drawn instead, in the theme's
  /// [GtPdfReceiptTheme.brand] and [GtPdfReceiptTheme.brandAccent], unless
  /// [showBrandMark] is false.
  final Uint8List? logo;

  /// Whether to fall back to the built-in brand mark when [logo] is null.
  final bool showBrandMark;

  /// The fixed copy of the document.
  final GtPdfStatementLabels labels;

  /// The file name used when the document is shared or saved.
  ///
  /// Slugged before use, like [GtPdfReceiptData.fileName]. Defaults to one
  /// derived from the [title] and [period]. See [resolvedFileName].
  final String? fileName;

  /// Creates a [GtPdfStatementData].
  const GtPdfStatementData({
    required this.title,
    required this.period,
    required this.holder,
    required this.summary,
    this.details = const [],
    this.transactions = const [],
    this.footer,
    this.logo,
    this.showBrandMark = true,
    this.labels = const GtPdfStatementLabels(),
    this.fileName,
  });

  /// The document's own title, used in the PDF metadata and when sharing.
  String get documentTitle => '$title $period';

  /// The file name used on export, always suffixed with `.pdf`.
  ///
  /// Derived from [fileName] when given and from [documentTitle] otherwise,
  /// and slugged by [gtPdfFileName].
  String get resolvedFileName {
    return gtPdfFileName(
      fileName.hasValue ? fileName! : documentTitle,
      fallback: 'statement',
    );
  }

  @override
  List<Object?> get props => [
    title,
    period,
    holder,
    details,
    summary,
    transactions,
    footer,
    logo,
    showBrandMark,
    labels,
    fileName,
  ];
}
