import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtNetworkImage extends GtStatelessWidget {
  final String? placeHolderPath;
  final String imageUrl;
  final double? width;
  final Color? color;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final Widget? errorWidget;

  const GtNetworkImage(
    this.imageUrl, {
    super.key,
    this.placeHolderPath,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.color,
    this.height,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const Offstage();

    if (imageUrl.startsWith("data:")) {
      final base64String = imageUrl.replaceAll("data:", "");
      return GtMemoryImage(
        base64Decode(base64String),
        height: height,
        width: width,
        alignment: alignment,
        fit: fit,
      );
    }

    if (imageUrl.endsWith(".svg")) {
      return GtSvg(
        imageUrl,
        height: height,
        width: width,
        alignment: alignment,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      alignment: alignment,
      fit: fit,
      color: color,
      errorWidget: (_, message, data) {
        return errorWidget ?? SizedBox(height: height, width: width);
      },
      placeholder: (context, _) {
        if (placeHolderPath == null) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: CircularProgressIndicator(
              color: context.palette.primary.dark,
            ),
          );
        }
        return GtAssetImage(
          placeHolderPath!,
          width: width,
          height: height,
          alignment: alignment,
        );
      },
    );
  }
}
