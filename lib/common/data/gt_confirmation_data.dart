import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A titled group of label/value rows rendered as a single card within a
/// [GtConfirmationBody].
///
/// Each section maps to one card on a transaction confirmation screen, such as
/// "Account Details", "Recipient Details" or "Transaction Details". The [title]
/// is rendered by [GtSectionHeader], which uppercases it automatically, so it
/// should be supplied in its natural casing.
///
/// Rows reuse [GtReceiptTileData], the design system's generic
/// label/value/optional-image/optional-tap row model. Supplying an `onTap`
/// makes a row interactive (for example, tap-to-copy on a reference).
///
/// Example usage:
/// ```dart
/// GtConfirmationSection(
///   title: "Recipient Details",
///   tiles: [
///     const GtReceiptTileData(label: "Name", value: "KENNETH OSMOSIS"),
///     const GtReceiptTileData(label: "Account Number", value: "3910527NGN"),
///     GtReceiptTileData(
///       label: "Reference",
///       value: "TRX24072983910527NGN",
///       onTap: () => copyReference(),
///     ),
///   ],
/// )
/// ```
class GtConfirmationSection extends AppEquatable {
  /// The section heading, rendered uppercased by [GtSectionHeader].
  final String title;

  /// The label/value rows displayed beneath the [title].
  ///
  /// Must contain at least one entry; a section with no rows would render as a
  /// card containing nothing but a heading. This is asserted by
  /// [GtConfirmationBody] at build time rather than here, because `List.length`
  /// is not const-evaluable and asserting on it would prevent callers from
  /// declaring sections as `const`.
  final List<GtReceiptTileData> tiles;

  /// Creates a [GtConfirmationSection].
  const GtConfirmationSection({required this.title, required this.tiles});

  @override
  List<Object?> get props => [title, tiles];
}

/// The fine print rendered beneath the final section of a
/// [GtConfirmationBody].
///
/// Models the closing block of a transaction confirmation screen: a
/// [disclaimer] paragraph laid out beside an optional [trailing] image
/// (typically a QR code linking to the digital receipt), followed by a short
/// closing [note].
///
/// Every field is optional so callers can render any subset, but a footer with
/// no content at all renders nothing — see [hasContent].
///
/// Example usage:
/// ```dart
/// const GtConfirmationFooter(
///   disclaimer:
///       "Your transfer has been processed successfully and will be "
///       "delivered. However, there may be interruptions or delays from "
///       "third party services.",
///   note: "Please reach out to support for more information.",
///   trailing: AppImageData(GtVectors.qrCode),
/// )
/// ```
class GtConfirmationFooter extends AppEquatable {
  /// The legal fine print, rendered opposite [trailing].
  final String? disclaimer;

  /// A short closing line rendered beneath the [disclaimer].
  final String? note;

  /// An image rendered opposite the [disclaimer], typically a QR code.
  ///
  /// Because a QR code carries meaning it is announced to screen readers using
  /// [trailingLabel] rather than being marked decorative.
  final AppImageData? trailing;

  /// The accessibility label announced for [trailing].
  ///
  /// Defaults to a localised "receiptQrCode" string when omitted.
  final String? trailingLabel;

  /// Creates a [GtConfirmationFooter].
  const GtConfirmationFooter({
    this.disclaimer,
    this.note,
    this.trailing,
    this.trailingLabel,
  });

  /// Whether this footer carries anything worth rendering.
  bool get hasContent =>
      disclaimer.hasValue || note.hasValue || trailing != null;

  /// The accessibility label used for [trailing].
  String get displayTrailingLabel => trailingLabel ?? 'receiptQrCode'.ctr();

  @override
  List<Object?> get props => [disclaimer, note, trailing, trailingLabel];
}
