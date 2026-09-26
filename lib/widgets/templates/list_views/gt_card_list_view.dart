import 'package:flutter/widgets.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Builds the content of one row, given the [item] it renders and its [index]
/// in the collection.
///
/// The returned widget is the row's content only; the surrounding card surface
/// comes from the [GtCardListTile] the list wraps it in.
typedef GtCardListItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);

/// Derives a stable [Key] from an item.
///
/// The key has to come from the item's identity, never its position: these
/// lists filter and paginate live, and a key derived from an index addresses a
/// different row — or none — the moment the collection changes underneath it.
typedef GtCardListItemKey<T> = Key Function(T item);

/// Lazily builds a grouped card list: rows stitched into one continuous card
/// surface by [GtCardListTile], with [separator] between them.
///
/// Every row is wrapped in a [GtCardListTile] whose [GtCardListTileType] comes
/// from [GtCardListTileType.fromIndex], so the group reads as a single rounded
/// card. The separator is itself a [GtCardListTile] of type
/// [GtCardListTileType.divider] — that type carries the square corners and the
/// horizontal padding that keep the card surface unbroken behind the gap. A
/// separator drawn as a bare [GtGap] or `Divider` falls outside the card, and
/// the group renders as two boxes with a strip of page background between them.
///
/// Inside a [CustomScrollView], use [GtCardListSliver] instead: a
/// shrink-wrapped [ListView] builds all of its children eagerly, which gives
/// back exactly the problem this widget removes. Pagination composes on top by
/// wrapping the host scroll view in a [GtInfiniteListView].
class GtCardListView<T> extends GtStatelessWidget {
  /// The collection to list, one row each.
  final List<T> items;

  /// Builds the content of a row.
  final GtCardListItemBuilder<T> itemBuilder;

  /// Derives a row's key from its item.
  final GtCardListItemKey<T> itemKey;

  /// The content of the divider tile drawn between two rows.
  final Widget separator;

  /// The variant applied to every tile in the group.
  final GtCardVariant variant;

  /// Overrides the surface color of every tile in the group, including the
  /// separators between them.
  ///
  /// Null keeps the color [variant] resolves to. A color given here is applied
  /// to the separators as well, since a gap left on the variant's default would
  /// show as a stripe through the group.
  final Color? backgroundColor;

  /// Overrides the horizontal padding of every tile in the group.
  final double? horizontalPadding;

  /// Overrides the vertical padding of the group's outer edges.
  final double? verticalPadding;

  /// Overrides the radius of the group's rounded corners.
  final Radius? edgeRadius;

  /// Padding around the list itself, outside the card surface.
  final EdgeInsetsGeometry? padding;

  /// An optional controller for the underlying scroll view.
  ///
  /// Supply one when the list is wrapped in a [GtInfiniteListView], which
  /// observes the same controller to paginate.
  final ScrollController? controller;

  /// Overrides the scroll physics of the underlying scroll view.
  final ScrollPhysics? physics;

  /// Whether the list sizes itself to its contents.
  final bool shrinkWrap;

  /// Creates a [GtCardListView].
  const GtCardListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemKey,
    this.separator = const GtGap.yBase(),
    this.variant = .normal,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.edgeRadius,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      findItemIndexCallback: (key) => items.itemIndexForKey(key, itemKey),
      itemCount: items.length,
      itemBuilder: (context, index) => _GtCardListRow<T>(
        key: itemKey(items[index]),
        item: items[index],
        index: index,
        length: items.length,
        itemBuilder: itemBuilder,
        variant: variant,
        backgroundColor: backgroundColor,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        edgeRadius: edgeRadius,
      ),
      separatorBuilder: (context, index) => _GtCardListSeparator(
        variant: variant,
        backgroundColor: backgroundColor,
        horizontalPadding: horizontalPadding,
        child: separator,
      ),
    );
  }
}

/// The sliver form of [GtCardListView], for use inside a [CustomScrollView].
///
/// This is the form that matters on long collections: it builds only the rows
/// the viewport reaches, and composes with whatever else the host scroll view
/// holds. See [GtCardListView] for why the separator is a tile.
class GtCardListSliver<T> extends GtStatelessWidget {
  /// The collection to list, one row each.
  final List<T> items;

  /// Builds the content of a row.
  final GtCardListItemBuilder<T> itemBuilder;

  /// Derives a row's key from its item.
  final GtCardListItemKey<T> itemKey;

  /// The content of the divider tile drawn between two rows.
  final Widget separator;

  /// The variant applied to every tile in the group.
  final GtCardVariant variant;

  /// Overrides the surface color of every tile in the group, including the
  /// separators between them.
  ///
  /// Null keeps the color [variant] resolves to. A color given here is applied
  /// to the separators as well, since a gap left on the variant's default would
  /// show as a stripe through the group.
  final Color? backgroundColor;

  /// Overrides the horizontal padding of every tile in the group.
  final double? horizontalPadding;

  /// Overrides the vertical padding of the group's outer edges.
  final double? verticalPadding;

  /// Overrides the radius of the group's rounded corners.
  final Radius? edgeRadius;

  /// Creates a [GtCardListSliver].
  const GtCardListSliver({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemKey,
    this.separator = const GtGap.yBase(),
    this.variant = .normal,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.edgeRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      findItemIndexCallback: (key) => items.itemIndexForKey(key, itemKey),
      itemCount: items.length,
      itemBuilder: (context, index) => _GtCardListRow<T>(
        key: itemKey(items[index]),
        item: items[index],
        index: index,
        length: items.length,
        itemBuilder: itemBuilder,
        variant: variant,
        backgroundColor: backgroundColor,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        edgeRadius: edgeRadius,
      ),
      separatorBuilder: (context, index) => _GtCardListSeparator(
        variant: variant,
        backgroundColor: backgroundColor,
        horizontalPadding: horizontalPadding,
        child: separator,
      ),
    );
  }
}

/// Resolves the index of a keyed item, so that an element survives the
/// collection changing underneath it.
extension _GtCardListLookup<T> on List<T> {
  /// Returns the index of the item [itemKey] maps [key] to, or null when no
  /// item carries that key any more.
  ///
  /// This retains the element for a keyed row when filtering or pagination
  /// moves its index; without it the framework rebuilds the row from scratch
  /// and its state is dropped.
  int? itemIndexForKey(Key key, GtCardListItemKey<T> itemKey) {
    final index = indexWhere((item) => itemKey(item) == key);
    return index < 0 ? null : index;
  }
}

/// One row of a grouped card list, wrapped in the [GtCardListTile] that gives
/// it its share of the card surface.
class _GtCardListRow<T> extends GtStatelessWidget {
  /// The item this row renders.
  final T item;

  /// The row's position in the collection.
  final int index;

  /// The size of the collection, which decides the tile's type alongside
  /// [index].
  final int length;

  /// Builds the row's content.
  final GtCardListItemBuilder<T> itemBuilder;

  /// The variant of the tile.
  final GtCardVariant variant;

  /// Overrides the tile's surface color.
  final Color? backgroundColor;

  /// Overrides the tile's horizontal padding.
  final double? horizontalPadding;

  /// Overrides the tile's vertical padding.
  final double? verticalPadding;

  /// Overrides the radius of the tile's rounded corners.
  final Radius? edgeRadius;

  /// Creates a [_GtCardListRow].
  const _GtCardListRow({
    super.key,
    required this.item,
    required this.index,
    required this.length,
    required this.itemBuilder,
    required this.variant,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.edgeRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GtCardListTile(
      type: .fromIndex(index: index, length: length),
      variant: variant,
      backgroundColor: backgroundColor,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      edgeRadius: edgeRadius,
      child: itemBuilder(context, item, index),
    );
  }
}

/// The gap between two rows, drawn as a [GtCardListTileType.divider] tile.
///
/// This is the part that keeps the card surface continuous behind the gap, and
/// the part a call site gets wrong first.
class _GtCardListSeparator extends GtStatelessWidget {
  /// The variant of the tile, matching the rows it separates.
  final GtCardVariant variant;

  /// Overrides the tile's surface color, matching the rows it separates.
  final Color? backgroundColor;

  /// Overrides the tile's horizontal padding, matching the rows it separates.
  final double? horizontalPadding;

  /// The content of the gap, sized by the caller.
  final Widget child;

  /// Creates a [_GtCardListSeparator].
  const _GtCardListSeparator({
    required this.variant,
    required this.child,
    this.backgroundColor,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GtCardListTile(
      type: .divider,
      variant: variant,
      backgroundColor: backgroundColor,
      horizontalPadding: horizontalPadding,
      child: child,
    );
  }
}
