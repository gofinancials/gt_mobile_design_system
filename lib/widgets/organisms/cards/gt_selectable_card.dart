import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A generic card widget that represents a selectable item within a group or list.
///
/// When [selected] is true, it displays a prominent border using the color
/// derived from the specified [variant]. It automatically scrolls into view
/// when tapped and triggers the [onSelect] callback with its assigned [value].
class GtSelectableCard<T> extends GtStatelessWidget {
  /// Whether this card is currently selected.
  final bool selected;

  /// The callback triggered when the card is tapped. Passes the [value] associated with this card.
  final OnChanged<T> onSelect;

  /// The underlying data value associated with this card.
  final T value;

  /// The widget displayed inside the card.
  final Widget child;

  /// The visual variant determining the card's color scheme, particularly the border color when selected.
  ///
  /// Defaults to [GtCardVariant.featured].
  final GtCardVariant variant;

  /// The internal padding applied around the [child] to accommodate the selection border without clipping.
  final double selectedMargin;

  /// Creates a [GtSelectableCard].
  const GtSelectableCard({
    required this.selected,
    required this.onSelect,
    required this.value,
    required this.child,
    this.variant = .featured,
    this.selectedMargin = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final selectedColor = variant.getIconColor(palette);

    BorderSide border = .none;
    if (selected) border = BorderSide(color: selectedColor, width: 2);

    return GtCard(
      onPressed: () {
        onSelect(value);
        context.scrollIntoViewNow();
      },
      borderRadius: context.borderRadiusXl,
      padding: .zero,
      margin: .zero,
      border: border,
      color: Colors.transparent,
      child: FittedBox(
        fit: .cover,
        child: Padding(padding: .all(selectedMargin), child: child),
      ),
    );
  }
}

/// A specialized [GtSelectableCard] designed specifically for selecting user avatars.
///
/// It wraps a [GtImage] and applies specific border radii and dimensions suitable for avatars.
class GtAvatarSelectionCard extends GtStatelessWidget {
  /// Whether this avatar is currently selected.
  final bool selected;

  /// The callback triggered when the avatar is tapped. Passes the [image] data.
  final OnChanged<AppImageData> onSelect;

  /// The image data representing the avatar.
  final AppImageData image;

  /// Creates a [GtAvatarSelectionCard].
  const GtAvatarSelectionCard(
    this.image, {
    required this.selected,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GtSelectableCard(
      selectedMargin: 2,
      selected: selected,
      onSelect: onSelect,
      value: image,
      child: ClipRRect(
        borderRadius: context.borderRadiusMd,
        child: GtImage(image: image, width: 80, height: 120),
      ),
    );
  }
}
