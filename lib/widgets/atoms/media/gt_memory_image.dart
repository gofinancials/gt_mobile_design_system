import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A widget that displays an image from a [Uint8List] of memory bytes.
///
/// This is a standardized wrapper around [Image.memory] for the Go Tech design system.
class GtMemoryImage extends GtStatelessWidget {
  /// The raw image data represented as a list of bytes.
  final Uint8List bytes;

  /// The optional width to constrain the image.
  final double? width;

  /// The optional height to constrain the image.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Creates a new [GtMemoryImage] from the provided byte array.
  const GtMemoryImage(
    this.bytes, {
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      bytes,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
    );
  }
}
