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

  /// Creates a new [GtMemoryImage] from the provided byte array.
  const GtMemoryImage(
    this.bytes, {
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
    return Image.memory(
      bytes,
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
