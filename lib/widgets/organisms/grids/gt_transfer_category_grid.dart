import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_ui/widgets/organisms/cards/gt_selectable_card.dart';

/// A controller that manages the selection state of a [GtTransactionCategory].
///
/// It extends [ValueNotifier] to allow widgets to rebuild when the selected
/// category changes.
class GtTransferCategoryController
    extends ValueNotifier<GtTransactionCategory?> {
  /// Creates a [GtTransferCategoryController] with an initial [value].
  GtTransferCategoryController(super.value);

  /// Updates the currently selected category to the provided [category].
  void select(GtTransactionCategory category) {
    value = category;
  }
}

/// A widget that displays a grid of selectable transaction categories.
///
/// Uses a [Wrap] layout to present categories in a responsive grid. It combines
/// a predefined list of default categories (via [GtTransactionCategoryMixin])
/// with an optional list of custom [categories].
///
/// It also includes a custom addition button at the end of the list to allow users
/// to create new categories.
class GtTransferCategoryGrid extends GtStatelessWidget
    with GtTransactionCategoryMixin {
  /// The controller managing the currently selected category.
  final GtTransferCategoryController controller;

  /// An optional list of additional custom categories to append to the default list.
  final List<GtTransactionCategory> categories;

  /// A callback triggered when the user taps the "Add custom" button.
  final OnPressed onAdd;

  /// Creates a [GtTransferCategoryGrid].
  const GtTransferCategoryGrid({
    required this.controller,
    required this.onAdd,
    this.categories = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final allCategories = [...defaultCategories, ...categories];
    final isMobile = context.screenType.isMobile;

    return GenericListener<GtTransactionCategory?>(
      valueListenable: controller,
      builder: (selectedCategory) {
        return Wrap(
          alignment: isMobile ? .spaceEvenly : .start,
          crossAxisAlignment: .start,
          spacing: !isMobile ? 0 : context.spacingXl,
          runSpacing: context.spacingXl,
          children: [
            for (final category in allCategories)
              GtTransactionCategoryGridCell(
                label: category.label,
                onTap: () => controller.select(category),
                child: GtSelectableCard(
                  selected: category == selectedCategory,
                  value: category,
                  onSelect: controller.select,
                  variant: category.variant ?? .featured,
                  child: GtImage(image: category.image, width: 48, height: 48),
                ),
              ),
            GtTransactionCategoryGridCell(
              label: "custom".ctr(),
              onTap: onAdd,
              child: GtIconButton(
                icon: GtIcons.plus,
                onPressed: onAdd,
                alignment: .topCenter,
                shape: .square,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A visual representation of a single cell within the [GtTransferCategoryGrid].
///
/// It displays a [child] widget (typically an icon or image inside a selectable card)
/// centered above a text [label].
class GtTransactionCategoryGridCell extends GtStatelessWidget {
  /// The main visual content of the cell, usually an icon or image.
  final Widget child;

  /// The text displayed below the [child].
  final String label;

  /// The callback triggered when the cell is tapped.
  final OnPressed onTap;

  /// Creates a [GtTransactionCategoryGridCell].
  const GtTransactionCategoryGridCell({
    required this.child,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Column(
        spacing: context.spacingBase,
        mainAxisSize: .min,
        children: [
          Padding(
            padding: context.insets.symmetricDp(horizontal: 12.px),
            child: GtSquareConstrainedBox(48, child: child),
          ),
          GtText(
            label,
            style: context.textStyles.body2Xs(color: context.palette.text.sub),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}

/// A mixin that provides a comprehensive list of default transaction categories.
///
/// These categories are commonly used in financial applications for classifying
/// transfers, payments, and other transactions.
mixin GtTransactionCategoryMixin {
  /// A predefined list of standard [GtTransactionCategory] objects.
  List<GtTransactionCategory> get defaultCategories => [
    GtTransactionCategory(
      label: "transfers".ctr(),
      image: AppImageData(imageData: GtNetworkImages.transfer),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "shopping".ctr(),
      image: AppImageData(imageData: GtNetworkImages.shopping),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "payroll".ctr(),
      image: AppImageData(imageData: GtNetworkImages.cash),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "family".ctr(),
      image: AppImageData(imageData: GtNetworkImages.family),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "food".ctr(),
      image: AppImageData(imageData: GtNetworkImages.food),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "savings".ctr(),
      image: AppImageData(imageData: GtNetworkImages.savings),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "bills".ctr(),
      image: AppImageData(imageData: GtNetworkImages.bill),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "card".ctr(),
      image: AppImageData(imageData: GtNetworkImages.card),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "household".ctr(),
      image: AppImageData(imageData: GtNetworkImages.household),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "health".ctr(),
      image: AppImageData(imageData: GtNetworkImages.health),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "gift".ctr(),
      image: AppImageData(imageData: GtNetworkImages.gift),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "charity".ctr(),
      image: AppImageData(imageData: GtNetworkImages.charity),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "holiday".ctr(),
      image: AppImageData(imageData: GtNetworkImages.holiday),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "transport".ctr(),
      image: AppImageData(imageData: GtNetworkImages.transport),
      variant: .info,
    ),
    GtTransactionCategory(
      label: "education".ctr(),
      image: AppImageData(imageData: GtNetworkImages.school),
      variant: .success,
    ),
    GtTransactionCategory(
      label: "emergency".ctr(),
      image: AppImageData(imageData: GtNetworkImages.alarm),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "refund".ctr(),
      image: AppImageData(imageData: GtNetworkImages.returns),
      variant: .error,
    ),
    GtTransactionCategory(
      label: "books".ctr(),
      image: AppImageData(imageData: GtNetworkImages.books),
      variant: .featured,
    ),
    GtTransactionCategory(
      label: "fitness".ctr(),
      image: AppImageData(imageData: GtNetworkImages.gym),
      variant: .success,
    ),
  ];
}
