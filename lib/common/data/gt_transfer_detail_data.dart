import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// An untitled group of label/value rows rendered as a single card within a
/// [GtTransferDetailBody].
///
/// Each section maps to one card beneath the status tracker on a transfer
/// detail screen — for example the category, source account and message; the
/// fees and levies; or the reference and session identifiers.
///
/// Rows reuse [GtReceiptTileData]. Supplying an `image` draws it before the
/// value, an `onTap` makes the row interactive (for example, tap-to-copy on a
/// reference), and an `onInfoTap` adds an info icon beside the label.
///
/// Unlike [GtConfirmationSection], a section carries no heading.
///
/// Example usage:
/// ```dart
/// GtTransferDetailSection(
///   tiles: [
///     GtReceiptTileData(
///       label: "Fees (VAT Incl)",
///       value: "₦25",
///       onInfoTap: () => explainFees(),
///     ),
///     const GtReceiptTileData(label: "Stamp duty", value: "₦50"),
///   ],
/// )
/// ```
class GtTransferDetailSection extends AppEquatable {
  /// The label/value rows displayed in this section's card.
  ///
  /// Must contain at least one entry. This is asserted by
  /// [GtTransferDetailBody] at build time rather than here, because
  /// `List.length` is not const-evaluable and asserting on it would prevent
  /// callers from declaring sections as `const`.
  final List<GtReceiptTileData> tiles;

  /// Creates a [GtTransferDetailSection].
  const GtTransferDetailSection({required this.tiles});

  @override
  List<Object?> get props => [tiles];
}
