import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtMemoryImage extends GtStatelessWidget {
  final Uint8List bytes;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;

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
