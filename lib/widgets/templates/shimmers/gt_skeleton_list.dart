import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A list of skeleton rows, standing in for a list that is still loading.
///
/// Each row is built by [itemBuilder], typically the `skeleton` constructor of
/// the row the list will show once it loads, so the skeleton has the real
/// list's rhythm:
///
/// ```dart
/// GtAsyncStateBody(
///   task: controller.transactions,
///   loading: GtSkeletonList(
///     semanticsLabel: 'Loading transactions',
///     itemBuilder: (context, i) => GtTransactionListTile.skeleton(),
///   ),
///   ...
/// )
/// ```
///
/// The default constructor builds a box that does not scroll and clips
/// whatever rows do not fit, so it can stand in the loading arm of a screen of
/// any height. [GtSkeletonList.sliver] builds a [SliverList] for a
/// [CustomScrollView], such as the loading arm of a [GtAsyncStateSliver].
class GtSkeletonList extends GtStatelessWidget {
  /// How many rows to draw. Defaults to 6.
  final int itemCount;

  /// Builds the row at an index.
  final IndexedWidgetBuilder itemBuilder;

  /// The gap between rows, in logical pixels. Null leaves no gap, for rows that
  /// carry their own padding.
  final double? spacing;

  /// The padding around the list. Null pads nothing.
  final EdgeInsetsGeometry? padding;

  /// What is announced while the list is on screen, such as "Loading
  /// transactions". See [GtSkeleton.semanticsLabel].
  final String? semanticsLabel;

  /// Whether this list is built as a sliver.
  final bool _asSliver;

  /// Creates a [GtSkeletonList] that lays its rows out as a box.
  const GtSkeletonList({
    super.key,
    required this.itemBuilder,
    this.itemCount = 6,
    this.spacing,
    this.padding,
    this.semanticsLabel,
  }) : _asSliver = false;

  /// Creates a [GtSkeletonList] that lays its rows out as a sliver.
  ///
  /// Each row is its own [GtSkeleton], since a skeleton is a box; every row
  /// sweeps in step with the others all the same. Only the first row carries
  /// [semanticsLabel], so it is announced once.
  const GtSkeletonList.sliver({
    super.key,
    required this.itemBuilder,
    this.itemCount = 6,
    this.spacing,
    this.padding,
    this.semanticsLabel,
  }) : _asSliver = true;

  @override
  Widget build(BuildContext context) {
    return switch (_asSliver) {
      true => _GtSkeletonSliverList(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        spacing: spacing,
        padding: padding,
        semanticsLabel: semanticsLabel,
      ),
      false => _GtSkeletonBoxList(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        spacing: spacing,
        padding: padding,
        semanticsLabel: semanticsLabel,
      ),
    };
  }
}

/// A private widget that lays a [GtSkeletonList] out as a box under one
/// [GtSkeleton].
class _GtSkeletonBoxList extends GtStatelessWidget {
  /// See [GtSkeletonList.itemCount].
  final int itemCount;

  /// See [GtSkeletonList.itemBuilder].
  final IndexedWidgetBuilder itemBuilder;

  /// See [GtSkeletonList.spacing].
  final double? spacing;

  /// See [GtSkeletonList.padding].
  final EdgeInsetsGeometry? padding;

  /// See [GtSkeletonList.semanticsLabel].
  final String? semanticsLabel;

  /// Creates a [_GtSkeletonBoxList].
  const _GtSkeletonBoxList({
    required this.itemCount,
    required this.itemBuilder,
    required this.spacing,
    required this.padding,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GtSkeleton(
      semanticsLabel: semanticsLabel,
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ?? .zero,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (_, _) => SizedBox(height: spacing ?? 0),
      ),
    );
  }
}

/// A private widget that lays a [GtSkeletonList] out as a sliver, one
/// [GtSkeleton] per row.
class _GtSkeletonSliverList extends GtStatelessWidget {
  /// See [GtSkeletonList.itemCount].
  final int itemCount;

  /// See [GtSkeletonList.itemBuilder].
  final IndexedWidgetBuilder itemBuilder;

  /// See [GtSkeletonList.spacing].
  final double? spacing;

  /// See [GtSkeletonList.padding].
  final EdgeInsetsGeometry? padding;

  /// See [GtSkeletonList.semanticsLabel].
  final String? semanticsLabel;

  /// Creates a [_GtSkeletonSliverList].
  const _GtSkeletonSliverList({
    required this.itemCount,
    required this.itemBuilder,
    required this.spacing,
    required this.padding,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? .zero,
      sliver: SliverList.separated(
        itemCount: itemCount,
        itemBuilder: (context, i) => GtSkeleton(
          semanticsLabel: i == 0 ? semanticsLabel : null,
          child: itemBuilder(context, i),
        ),
        separatorBuilder: (_, _) => SizedBox(height: spacing ?? 0),
      ),
    );
  }
}
