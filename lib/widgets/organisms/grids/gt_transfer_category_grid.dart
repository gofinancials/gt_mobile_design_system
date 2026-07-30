import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

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
  final GtTransactionCategoryController controller;

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
    final allCategories = [...defaultGridCategories, ...categories];
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
    return GtInkWell(
      borderRadius: context.borderRadiusSm,
      onTap: onTap,
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
