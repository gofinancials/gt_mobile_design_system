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
  /// Overrides spacing in logical pixels. Null preserves the current default.
  final double? spacing;

  /// Overrides run spacing in logical pixels. Null preserves the current default.
  final double? runSpacing;

  /// Overrides selected border color. Null preserves the current default.
  final Color? selectedBorderColor;

  /// Overrides label style. Null preserves the current default.
  final TextStyle? labelStyle;

  /// Overrides label color. Null preserves the current default.
  final Color? labelColor;

  /// Overrides label spacing in logical pixels. Null preserves the current default.
  final double? labelSpacing;

  /// Overrides cell padding. Null preserves the current default.
  final EdgeInsetsGeometry? cellPadding;

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
    this.spacing,
    this.runSpacing,
    this.selectedBorderColor,
    this.labelStyle,
    this.labelColor,
    this.labelSpacing,
    this.cellPadding,
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
          spacing: spacing ?? (!isMobile ? 0 : context.spacingXl),
          runSpacing: runSpacing ?? context.spacingXl,
          children: [
            for (final category in allCategories)
              GtTransactionCategoryGridCell(
                labelStyle: labelStyle,
                labelColor: labelColor,
                verticalSpacing: labelSpacing,
                padding: cellPadding,
                label: category.label,
                onTap: () => controller.select(category),
                child: GtSelectableCard(
                  borderColor: selectedBorderColor,
                  selected: category == selectedCategory,
                  value: category,
                  onSelect: controller.select,
                  variant: category.variant ?? .featured,
                  child: GtImage(
                    image: category.image,
                    width: 48,
                    height: 48,
                    isDecorative: true,
                  ),
                ),
              ),
            GtTransactionCategoryGridCell(
              labelStyle: labelStyle,
              labelColor: labelColor,
              verticalSpacing: labelSpacing,
              padding: cellPadding,
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
  /// Overrides label style. Null preserves the current default.
  final TextStyle? labelStyle;

  /// Overrides label color. Null preserves the current default.
  final Color? labelColor;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

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
    this.labelStyle,
    this.labelColor,
    this.verticalSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadiusSm,
      onTap: onTap,
      child: Column(
        spacing: verticalSpacing ?? context.spacingBase,
        mainAxisSize: .min,
        children: [
          Padding(
            padding: padding ?? context.insets.symmetricDp(horizontal: 12.px),
            child: GtSquareConstrainedBox(48, child: child),
          ),
          GtText(
            label,
            style: GtTextStyleOverrides.resolve(
              labelStyle,
              context.textStyles.body2Xs(color: context.palette.text.sub),
              labelColor,
            ),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
