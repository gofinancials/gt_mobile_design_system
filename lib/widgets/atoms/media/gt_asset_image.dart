import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:flutter/material.dart';

class GtAssetImage extends GtStatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;

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
