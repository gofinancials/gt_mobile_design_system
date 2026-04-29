import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A data model representing a category for a transaction or transfer.
///
/// Typically used in grids or lists where users can select a classification
/// for a specific transaction (e.g., "Shopping", "Food", "Payroll").
class GtTransactionCategory {
  /// The display name or title of the category.
  final String label;

  /// The visual representation (icon or illustration) associated with the category.
  final AppImageData image;

  /// An optional visual variant determining the color scheme of the category's card.
  final GtCardVariant? variant;

  /// Creates a new [GtTransactionCategory].
  const GtTransactionCategory({
    required this.label,
    required this.image,
    this.variant,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GtTransactionCategory) return false;
    return other.label == label &&
        other.image == image &&
        other.variant == variant;
  }

  @override
  int get hashCode => Object.hash(label, image, variant);
}
