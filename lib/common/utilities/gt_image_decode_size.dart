import 'package:flutter/widgets.dart'
    show
        BoxFit,
        BuildContext,
        Image,
        IntrinsicHeight,
        LayoutBuilder,
        MediaQuery;
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The size, in physical pixels, a raster image is decoded at so that it costs
/// no more memory than the space it is drawn in.
///
/// An image decoded at its full resolution holds four bytes per source pixel
/// whatever size it is drawn at: a 2000 × 2000 logo in a 24 dp avatar costs
/// 16 MB. Image atoms hand this size to the decoder, as
/// `CachedNetworkImage.memCacheWidth` or [Image.cacheWidth] and their height
/// counterparts, so the decoded bitmap matches the drawn one instead.
///
/// Only one axis is ever set. Setting both resizes the decode to exactly that
/// box and stretches any source of a different shape, which the image's fit
/// then paints as is. With one axis set the other follows the source's aspect
/// ratio, and a source already smaller than the target is never scaled up.
///
/// The axis set is the longer side of the drawn box, and the height when the
/// box is square, since logos and wordmarks run wide more often than tall. Under
/// [BoxFit.contain] and [BoxFit.scaleDown] that is always sharp. Under
/// [BoxFit.cover] a source more extreme than the box on the other axis is drawn
/// slightly soft rather than cropped from a sharper decode; the memory saved is
/// worth that.
///
/// An image with no size of its own is capped at the screen's width, as
/// [GtImageDecodeSizeResolver.imageDecodeSize] explains.
///
/// See [GtNetworkImage], [GtMemoryImage] and [GtFileImage].
typedef GtImageDecodeSize = ({int? width, int? height});

/// Resolves a [GtImageDecodeSize] from the size an image is drawn at.
extension GtImageDecodeSizeResolver on BuildContext {
  /// The decode size for an image drawn [width] by [height] logical pixels,
  /// at the device pixel ratio of this context.
  ///
  /// A null or unbounded dimension is treated as unknown. When both are
  /// unknown, the width is capped at the screen's width instead. An image
  /// with no size of its own is rarely drawn wider than the screen, and
  /// capping the longer screen side would leave a 2000 px source on a
  /// 2556 px screen at full size. This reads no layout, so it stays safe
  /// under an [IntrinsicHeight], where a [LayoutBuilder] cannot report a
  /// size.
  GtImageDecodeSize imageDecodeSize({double? width, double? height}) {
    final ratio = MediaQuery.devicePixelRatioOf(this);
    final w = _bounded(width);
    final h = _bounded(height);
    if (w == null && h == null) {
      final screenWidth = MediaQuery.sizeOf(this).width;
      return (width: (screenWidth * ratio).ceil(), height: null);
    }

    if (h != null && (w == null || h >= w)) {
      return (width: null, height: (h * ratio).ceil());
    }
    return (width: (w! * ratio).ceil(), height: null);
  }

  /// [value], or null when it is missing, unbounded or not positive.
  double? _bounded(double? value) {
    if (value == null || !value.isFinite || value <= 0) return null;
    return value;
  }
}
