import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A generic list tile used for rendering items in a menu or dropdown.
///
/// Returns a strongly-typed [value] via the [onSelect] callback when tapped.
class GtMenuListTile<T> extends StatelessWidget {
  /// The primary text to display in the menu tile.
  final String text;

  /// The icon to display at the end of the menu tile.
  final IconData icon;

  /// The value to return when this menu item is selected.
  final T value;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnChanged<T> onSelect;

  /// Creates a [GtMenuListTile].
  const GtMenuListTile(
    this.text, {
    super.key,
    required this.icon,
    required this.value,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onSelect(value);
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 4.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: GtText(text, style: context.textStyles.subHeadS())),
            GtIcon.withColor(
              icon,
              size: 20,
              color: context.palette.primary.dark,
            ),
          ],
        ),
      ),
    );
  }
}

/// A generic list tile used for selection from a list of options.
///
/// Displays a prominent checkmark when [isSelected] is true.
class GtSelectionListTile<T> extends GtStatelessWidget {
  /// The value represented by this selection tile.
  final T value;

  /// The primary text or label to display.
  final String text;

  /// An optional widget, typically an icon or avatar, to display at the start of the tile.
  final Widget? leading;

  /// Whether this tile is currently selected, which controls the visibility of the checkmark.
  final bool isSelected;

  /// The callback triggered when the tile is tapped.
  final OnChanged<T> onSelect;

  /// Creates a standard [GtSelectionListTile].
  const GtSelectionListTile(
    this.text, {
    super.key,
    required this.value,
    required this.isSelected,
    required this.onSelect,
    this.leading,
  });

  /// Creates a [GtSelectionColumnListTile] that displays a secondary [description]
  /// below the primary text.
  const factory GtSelectionListTile.withDescription(
    String text, {
    Key? key,
    required T value,
    required bool isSelected,
    required OnChanged<T> onSelect,
    required String description,
    Widget? leading,
  }) = GtSelectionColumnListTile;

  /// Creates a [GtRoleSelectionListTile] specifically designed for assigning
  /// roles or permissions, featuring a checkbox and an optional footer.
  const factory GtSelectionListTile.forRole(
    String text, {
    Key? key,
    required T value,
    required bool isSelected,
    required OnChanged<T> onSelect,
    required String description,
    Widget? footer,
    bool? asCard,
  }) = GtRoleSelectionListTile;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    TextStyle labelStyle = textStyles.bodyM();

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(value);
      },
      child: Row(
        spacing: context.spacingMd,
        children: [
          if (leading != null) GtSquareConstrainedBox(30, child: leading),
          Expanded(child: GtText(text, style: labelStyle)),
          GtSquareConstrainedBox(
            30,
            child: Visibility(
              visible: isSelected,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: GtIcon(
                GtIcons.checkSolid,
                variant: .success,
                size: 28,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A variant of [GtSelectionListTile] that displays a description below the
/// primary text, formatted in a column.
class GtSelectionColumnListTile<T> extends GtSelectionListTile<T> {
  /// The secondary text providing more details about the selection option.
  final String description;

  /// Creates a [GtSelectionColumnListTile].
  const GtSelectionColumnListTile(
    super.text, {
    super.key,
    required super.value,
    required super.isSelected,
    required super.onSelect,
    required this.description,
    super.leading,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    TextStyle textStyle = textStyles.h7();
    TextStyle descriptionStyle = textStyles.subHeadS(
      color: context.palette.text.sub,
    );

    Widget child = Row(
      spacing: context.spacingMd,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: context.spacingBase,
            children: [
              GtText(text.upper, style: textStyle),
              GtText(description, style: descriptionStyle),
            ],
          ),
        ),
        GtSquareConstrainedBox(
          30,
          child: Visibility(
            visible: isSelected,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: GtIcon(
              GtIcons.checkSolid,
              size: 24,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );

    if (leading != null) {
      child = Row(
        spacing: context.spacingMd,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GtSquareConstrainedBox(30, child: leading),
          Expanded(child: child),
        ],
      );
    }

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(value);
      },
      child: child,
    );
  }
}

/// A selection tile styled specifically for assigning roles or permissions.
///
/// Incorporates a leading checkbox and an optional footer widget.
class GtRoleSelectionListTile<T> extends GtSelectionListTile<T> {
  /// An optional widget to display at the bottom of the tile.
  final Widget? footer;

  /// The secondary text explaining the role or permission in detail.
  final String description;
  final bool _asCard;

  /// Creates a [GtRoleSelectionListTile].
  const GtRoleSelectionListTile(
    super.text, {
    super.key,
    required super.value,
    required super.isSelected,
    required super.onSelect,
    required this.description,
    this.footer,
    bool? asCard,
  }) : _asCard = asCard ?? false;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    TextStyle textStyle = textStyles.subHeadM();
    TextStyle descriptionStyle = textStyles.bodyS(
      color: context.palette.text.sub,
    );

    Widget child = Row(
      spacing: context.spacingMd,
      crossAxisAlignment: .start,
      children: [
        GtCheckBox(
          value: value,
          onChanged: onSelect,
          isActive: isSelected,
          activeColor: context.palette.staticColors.black,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: context.spacingSm,
            children: [
              GtText(text, style: textStyle),
              GtText(description, style: descriptionStyle),
              if (footer != null) ...[const GtGap.yBase(), ?footer],
            ],
          ),
        ),
      ],
    );

    if (_asCard) {
      child = GtCard(
        padding: context.insets.allDp(12.px),
        borderRadius: 8.circularBorderRadius,
        child: child,
      );
    }

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(value);
      },
      child: child,
    );
  }
}

/// A specialized selection tile for choosing countries.
///
/// Displays the country's flag and name, along with a checkmark if selected.
class GtCountrySelectionListTile extends GtStatelessWidget {
  /// The country data represented by this tile.
  final Country value;

  /// Whether this country is currently selected.
  final bool isSelected;

  /// The callback triggered when the tile is tapped.
  final OnChanged<Country> onSelect;

  /// Creates a [GtCountrySelectionListTile].
  const GtCountrySelectionListTile(
    this.value, {
    super.key,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(value);
      },
      child: Row(
        spacing: context.spacingBase,
        children: [
          ClipRRect(
            borderRadius: context.borderRadiusFull,
            child: GtNetworkImage(
              value.pngFlagUrl,
              fit: BoxFit.cover,
              height: 40,
              width: 40,
            ),
          ),
          Expanded(child: GtText(value.displayName.capitalise())),
          if (isSelected)
            GtIcon(GtIcons.checkSolid, alignment: Alignment.centerRight),
        ],
      ),
    );
  }
}
