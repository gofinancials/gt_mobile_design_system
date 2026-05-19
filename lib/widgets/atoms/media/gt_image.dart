import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A unified image widget that dynamically renders different image types.
///
/// Based on the properties of the provided [image] data, this widget delegates
/// rendering to [GtNetworkImage] (for URLs), [GtAssetImage] (for local asset strings),
/// or [GtFileImage] (for local device files). If no valid image data is provided,
/// it gracefully falls back to an empty placeholder box.
class GtImage extends GtStatelessWidget {
  /// The data source for the image, wrapping either a URL, asset path, or [File].
  final AppImageData? image;

  /// The optional width to constrain the image.
  final double? width;

  /// The optional height to constrain the image.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// An optional scaffold key.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Whether to apply a default size of 40dp when [width] or [height] are null.
  ///
  /// Defaults to true. If false, the image will size itself based on its intrinsic
  /// dimensions or parent constraints.
  final bool useDefaultSize;

  /// An optional color filter to apply to the image.
  final Color? color;

  /// Creates a new [GtImage].
  ///
  /// The [alignment] defaults to [Alignment.center] and [useDefaultSize] defaults
  /// to true.
  const GtImage({
    this.image,
    this.scaffoldKey,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
    this.color,
    this.useDefaultSize = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSize = useDefaultSize ? context.dp(40.px) : null;
    return Align(
      alignment: alignment,
      child: Builder(
        builder: (_) {
          if (image?.isUrl ?? false) {
            return GtNetworkImage(
              image?.fileUrl ?? "",
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
            );
          }
          if (image?.isString ?? false) {
            return GtAssetImage(
              image?.filePath ?? "",
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
            );
          }
          if (image?.isBytes ?? false) {
            return GtMemoryImage(
              image!.bytesData ?? Uint8List(0),
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
            );
          }
          if (image?.isIcon ?? false) {
            return GtIcon.withColor(
              image?.iconData ?? GtIcons.anchor,
              alignment: alignment,
              size: width ?? context.dp(24.px),
              color: color ?? context.palette.icon.strong,
            );
          }
          if (image?.isFile ?? false) {
            return GtFileImage(
              image?.file,
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
            );
          }
          return Align(
            alignment: alignment,
            child: FittedBox(
              fit: fit ?? BoxFit.cover,
              child: SizedBox(
                width: width ?? defaultSize,
                height: height ?? defaultSize,
              ),
            ),
          );
        },
      ),
    );
  }
}
