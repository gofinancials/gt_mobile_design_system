import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

/// A versatile widget for displaying images from the local asset bundle.
///
/// This widget automatically detects if the provided [imageUrl] is an SVG file
/// (by checking the ".svg" extension) and delegates to [GtSvg] for vector rendering.
/// For all other formats, it falls back to the standard [Image.asset].
class GtAssetImage extends GtStatelessWidget {
  /// The path to the image asset (e.g., 'assets/images/logo.png' or 'assets/icons/home.svg').
  final String imageUrl;

  /// The optional width to constrain the image.
  final double? width;

  /// The optional height to constrain the image.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Creates a new [GtAssetImage].
  const GtAssetImage(
    this.imageUrl, {
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.endsWith("svg")) {
      return GtSvg(
        imageUrl,
        fit: fit ?? BoxFit.contain,
        alignment: alignment,
        width: width,
        height: height,
      );
    }
    return Image.asset(
      imageUrl,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
    );
  }
}
