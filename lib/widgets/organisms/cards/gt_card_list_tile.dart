import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Defines the structural position of a [GtCardListTile] within a list.
///
/// This determines how the tile's border radius and padding are applied
/// to visually group items together.
enum GtCardListTileType {
  /// The first item in a list. Typically has rounded top corners.
  starter,

  /// A middle item in a list. Typically has square corners.
  medial,

  /// The last item in a list. Typically has rounded bottom corners.
  terminus,

  /// An item acting as a divider.
  divider,

  /// The only item in a list. Typically has all corners rounded.
  sole;

  /// Determines the tile type based on its [index] within a list of a given [length].
  factory GtCardListTileType.fromIndex({
    required int index,
    required int length,
  }) {
    if (length == 1) return .sole;
    if (index == 0) return .starter;
    if (index == length - 1) return .terminus;
    return .medial;
  }

  /// Returns the appropriate [BorderRadius] for this tile type based on the [context].
  BorderRadius borderRadius(BuildContext context) {
    return switch (this) {
      .divider || medial => .zero,
      .starter => BorderRadius.vertical(top: context.radiusXl),
      .terminus => BorderRadius.vertical(bottom: context.radiusXl),
      .sole => context.borderRadiusXl,
    };
  }

  /// Returns the appropriate [EdgeInsetsGeometry] for this tile type.
  EdgeInsetsGeometry padding(GtInsets insets) {
    final defualtPadding = insets.defaultHorizontalInsets;
    final EdgeInsetsGeometry addend = switch (this) {
      .starter => insets.onlyDp(top: 12.px),
      .terminus => insets.onlyDp(bottom: 12.px),
      .sole => insets.symmetricDp(vertical: 12.px),
      _ => .zero,
    };
    return defualtPadding.add(addend);
  }
}

/// A wrapper widget that styles its [child] as a card list tile.
///
/// It automatically adjusts its border radius and padding based on its [type],
/// making it ideal for creating cohesive, grouped lists.
class GtCardListTile extends GtStatelessWidget {
  /// The positional type of the tile within a list. Defaults to [GtCardListTileType.medial].
  final GtCardListTileType type;

  /// The primary content of the card list tile.
  final Widget child;

  /// Creates a [GtCardListTile].
  const GtCardListTile({super.key, this.type = .medial, required this.child});

  @override
  Widget build(BuildContext context) {
    return GtCard(
      padding: type.padding(context.insets),
      borderRadius: type.borderRadius(context),
      child: child,
    );
  }
}
