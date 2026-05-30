import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/common/styling/gt_colors.dart';

/// A configuration class that encapsulates styling and behavior parameters
/// for a [DecorationImage].
///
/// This class acts as a reusable blueprint, allowing you to define image
/// styling rules (like fit, alignment, and filters) once, and easily apply
/// them to different [ImageProvider]s using [toDecorationImage].
class GtDecorationImageStyle {
  /// An optional error callback for errors emitted when loading the image.
  final ImageErrorListener? onError;

  /// A color filter to apply to the image before painting it.
  final ColorFilter? colorFilter;

  /// How the image should be inscribed into the box.
  final BoxFit? fit;

  /// How to align the image within its bounds.
  final AlignmentGeometry alignment;

  /// The center slice for a nine-patch image.
  final Rect? centerSlice;

  /// How to paint any portions of the box that would not otherwise be covered by the image.
  final ImageRepeat repeat;

  /// Whether to paint the image in the direction of the [TextDirection].
  final bool matchTextDirection;

  /// Defines the image pixels to be shown per logical pixels.
  final double scale;

  /// The opacity of the image.
  final double opacity;

  /// The quality of the image filter when scaling.
  final FilterQuality filterQuality;

  /// Whether the colors of the image should be inverted.
  final bool invertColors;

  /// Whether to paint the image with anti-aliasing.
  final bool isAntiAlias;

  /// Creates a [GtDecorationImageStyle] instance.
  GtDecorationImageStyle({
    this.onError,
    this.colorFilter,
    this.fit,
    this.alignment = Alignment.center,
    this.centerSlice,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.scale = 1.0,
    this.opacity = 1.0,
    this.filterQuality = FilterQuality.medium,
    this.invertColors = false,
    this.isAntiAlias = false,
  });

  /// Converts this styling configuration into a functional [DecorationImage]
  /// using the provided [provider].
  DecorationImage toDecorationImage(ImageProvider provider) => DecorationImage(
    image: provider,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
    matchTextDirection: matchTextDirection,
    scale: scale,
    opacity: opacity,
    colorFilter: colorFilter,
    centerSlice: centerSlice,
    filterQuality: filterQuality,
    invertColors: invertColors,
    isAntiAlias: isAntiAlias,
  );

  /// A predefined "pro" styling configuration commonly used across the app.
  ///
  /// Features a cover fit and a maroon-tinted color filter.
  static GtDecorationImageStyle get pro {
    return GtDecorationImageStyle(
      fit: .cover,
      // alignment: .center,
      colorFilter: ColorFilter.mode(
        GtColors.maroon600.value.setOpacity(.65),
        .srcATop,
      ),
    );
  }
}
