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
