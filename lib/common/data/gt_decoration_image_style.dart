import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/common/styling/gt_colors.dart';

class GtDecorationImageStyle {
  final ImageErrorListener? onError;
  final ColorFilter? colorFilter;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final Rect? centerSlice;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final double scale;
  final double opacity;
  final FilterQuality filterQuality;
  final bool invertColors;
  final bool isAntiAlias;

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
