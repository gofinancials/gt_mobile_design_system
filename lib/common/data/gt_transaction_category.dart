import 'package:flutter/material.dart';
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

  GtDropdownData<GtTransactionCategory> get dropdownData {
    return GtDropdownData(value: this, label: label);
  }

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

/// A controller that manages the selection state of a [GtTransactionCategory].
///
/// It extends [ValueNotifier] to allow widgets to rebuild when the selected
/// category changes.
class GtTransactionCategoryController
    extends ValueNotifier<GtTransactionCategory?> {
  List<GtTransactionCategory> _categories;

  /// Creates a [GtTransactionCategoryController] with an initial [value].
  GtTransactionCategoryController(
    super.value, {
    required List<GtTransactionCategory> categories,
  }) : _categories = categories;

  /// Updates the currently selected category to the provided [category].
  void select(GtTransactionCategory category) {
    value = category;
  }

  set categories(List<GtTransactionCategory> categories) {
    _categories = categories;
    notifyListeners();
  }

  /// Gets the list of all available categories.
  List<GtTransactionCategory> get categories => .unmodifiable(_categories);

  /// Resets the selected category to null.
  void reset() => value = null;

  @override
  void dispose() {
    _categories.clear();
    super.dispose();
  }
}

/// A mixin that provides a comprehensive list of default transaction categories.
///
/// These categories are commonly used in financial applications for classifying
/// transfers, payments, and other transactions.
mixin GtTransactionCategoryMixin {
  /// A predefined list of standard [GtTransactionCategory] objects.
  List<GtTransactionCategory> get defaultGridCategories => [
    GtTransactionCategory(
      label: "transfers".ctr(),
      image: AppImageData(GtNetworkImages.transfer),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "shopping".ctr(),
      image: AppImageData(GtNetworkImages.shopping),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "payroll".ctr(),
      image: AppImageData(GtNetworkImages.cash),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "family".ctr(),
      image: AppImageData(GtNetworkImages.family),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "food".ctr(),
      image: AppImageData(GtNetworkImages.food),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "savings".ctr(),
      image: AppImageData(GtNetworkImages.savings),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "bills".ctr(),
      image: AppImageData(GtNetworkImages.bill),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "card".ctr(),
      image: AppImageData(GtNetworkImages.card),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "household".ctr(),
      image: AppImageData(GtNetworkImages.household),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "health".ctr(),
      image: AppImageData(GtNetworkImages.health),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "gift".ctr(),
      image: AppImageData(GtNetworkImages.gift),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "charity".ctr(),
      image: AppImageData(GtNetworkImages.charity),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "holiday".ctr(),
      image: AppImageData(GtNetworkImages.holiday),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "transport".ctr(),
      image: AppImageData(GtNetworkImages.transport),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "education".ctr(),
      image: AppImageData(GtNetworkImages.school),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "emergency".ctr(),
      image: AppImageData(GtNetworkImages.alarm),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "refund".ctr(),
      image: AppImageData(GtNetworkImages.returns),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "books".ctr(),
      image: AppImageData(GtNetworkImages.books),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "fitness".ctr(),
      image: AppImageData(GtNetworkImages.gym),
      variant: .success,
    ),
  ];

  /// A predefined list of standard [GtTransactionCategory] objects.
  List<GtTransactionCategory> get defaultInputCategories => [
    GtTransactionCategory(
      label: "transfers".ctr(),
      image: AppImageData(GtVectorIllustrations.transferCat),
    ),
    GtTransactionCategory(
      label: "shopping".ctr(),
      image: AppImageData(GtVectorIllustrations.shoppingCat),
    ),
    GtTransactionCategory(
      label: "payroll".ctr(),
      image: AppImageData(GtVectorIllustrations.payrollCat),
    ),
    GtTransactionCategory(
      label: "family".ctr(),
      image: AppImageData(GtVectorIllustrations.familyCat),
    ),
    GtTransactionCategory(
      label: "food".ctr(),
      image: AppImageData(GtVectorIllustrations.foodCat),
    ),
    GtTransactionCategory(
      label: "savings".ctr(),
      image: AppImageData(GtVectorIllustrations.savingsCat),
    ),
    GtTransactionCategory(
      label: "bills".ctr(),
      image: AppImageData(GtVectorIllustrations.cashCat),
    ),
    GtTransactionCategory(
      label: "card".ctr(),
      image: AppImageData(GtVectorIllustrations.debitCardsCat),
    ),
    GtTransactionCategory(
      label: "household".ctr(),
      image: AppImageData(GtVectorIllustrations.houseCat),
    ),
    GtTransactionCategory(
      label: "health".ctr(),
      image: AppImageData(GtVectorIllustrations.healthCat),
    ),
    GtTransactionCategory(
      label: "gift".ctr(),
      image: AppImageData(GtVectorIllustrations.giftCat),
    ),
    GtTransactionCategory(
      label: "charity".ctr(),
      image: AppImageData(GtVectorIllustrations.charityCat),
    ),
    GtTransactionCategory(
      label: "holiday".ctr(),
      image: AppImageData(GtVectorIllustrations.holidayCat),
    ),
    GtTransactionCategory(
      label: "transport".ctr(),
      image: AppImageData(GtVectorIllustrations.transportCat),
    ),
    GtTransactionCategory(
      label: "education".ctr(),
      image: AppImageData(GtVectorIllustrations.educationCat),
    ),
    GtTransactionCategory(
      label: "emergency".ctr(),
      image: AppImageData(GtVectorIllustrations.emergencyCat),
    ),
    GtTransactionCategory(
      label: "refund".ctr(),
      image: AppImageData(GtVectorIllustrations.detailsCat),
    ),
    GtTransactionCategory(
      label: "books".ctr(),
      image: AppImageData(GtVectorIllustrations.file),
    ),
    GtTransactionCategory(
      label: "fitness".ctr(),
      image: AppImageData(GtVectorIllustrations.fitnessCat),
    ),
  ];
}
