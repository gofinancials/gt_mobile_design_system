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

  /// An optional color filter to apply to the image.
  final Color? color;

  /// A description of what this image conveys, for screen readers.
  ///
  /// Supply this whenever the image carries information the surrounding text
  /// does not. When both this and [isDecorative] are omitted the image is
  /// excluded from the semantics tree, because an image node with no label is
  /// a stop the user must swipe past only to learn nothing.
  final String? semanticsLabel;

  /// Whether this image is purely decorative.
  ///
  /// Decorative images are excluded from the semantics tree. Prefer setting
  /// this explicitly over simply omitting [semanticsLabel], so the intent is
  /// visible to readers and to the lint that flags unlabelled images.
  final bool isDecorative;

  /// Creates a new [GtAssetImage].
  const GtAssetImage(
    this.imageUrl, {
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
    this.color,
    this.semanticsLabel,
    this.isDecorative = false,
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
        color: color,
        semanticsLabel: semanticsLabel,
        isDecorative: isDecorative,
      );
    }
    return Image.asset(
      imageUrl,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      color: color,
      semanticLabel: semanticsLabel,
      // Image defaults to contributing an "image" node even with no label.
      // Excluding unlabelled images keeps them from becoming empty stops.
      excludeFromSemantics: isDecorative || semanticsLabel == null,
    );
  }
}
