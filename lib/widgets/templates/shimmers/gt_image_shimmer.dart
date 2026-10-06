import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A shimmering block standing in for an image while it loads.
///
/// [GtNetworkImage] draws one by default while its request is in flight, and a
/// skeleton draws one wherever a screen has an image slot but no image yet.
///
/// Inside an enabled [GtSkeleton] it joins that skeleton's sweep. On its own it
/// runs a sweep of its own and announces nothing, because an image that is
/// still loading is not news to a screen reader.
///
/// A null [width] or [height] fills the incoming constraint along that axis,
/// and collapses to zero where that constraint is unbounded.
class GtImageShimmer extends GtStatelessWidget {
  /// The width of the block. Null fills the available width.
  final double? width;

  /// The height of the block. Null fills the available height.
  final double? height;

  /// The shape of the block. Defaults to [BoxShape.rectangle].
  final BoxShape shape;

  /// The corners of the block.
  ///
  /// Defaults to [GtBone]'s own default. Ignored when [shape] is
  /// [BoxShape.circle].
  final BorderRadiusGeometry? borderRadius;

  /// Creates a [GtImageShimmer].
  const GtImageShimmer({
    super.key,
    this.width,
    this.height,
    this.shape = .rectangle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget block = GtBone(
      shape: shape,
      borderRadius: borderRadius,
      child: LimitedBox(
        maxWidth: width ?? 0,
        maxHeight: height ?? 0,
        child: SizedBox(width: width ?? .infinity, height: height ?? .infinity),
      ),
    );

    if (!context.inSkeleton) {
      block = GtSkeleton(child: block);
    }

    return block;
  }
}
