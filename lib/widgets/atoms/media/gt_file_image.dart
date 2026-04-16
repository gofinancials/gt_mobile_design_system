import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays an image from a local [File].
///
/// If the provided [imageFile] is null, this widget gracefully degrades by
/// rendering an empty space that respects the provided [width], [height],
/// [fit], and [alignment] properties.
class GtFileImage extends GtStatelessWidget {
  /// The local file containing the image data. If null, a blank space is rendered.
  final File? imageFile;

  /// The optional width to constrain the image.
  final double? width;

  /// The optional height to constrain the image.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Creates a new [GtFileImage].
  const GtFileImage(
    this.imageFile, {
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return Align(
        alignment: alignment,
        child: FittedBox(
          fit: fit ?? BoxFit.contain,
          child: SizedBox(height: height, width: width),
        ),
      );
    }
    return Image.file(
      imageFile!,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
    );
  }
}
