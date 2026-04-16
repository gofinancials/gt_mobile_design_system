import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A versatile network image widget for the Go Tech design system.
///
/// This widget intelligently handles different types of network image sources:
/// - Base64 encoded strings (starting with "data:") are routed to [GtMemoryImage].
/// - SVG URLs (ending with ".svg") are routed to [GtSvg].
/// - Standard image URLs are handled by [CachedNetworkImage] for efficient caching.
class GtNetworkImage extends GtStatelessWidget {
  /// An optional local asset path to display while the network image is loading.
  ///
  /// If null, a circular progress indicator is shown by default.
  final String? placeHolderPath;

  /// The source URL or base64 data URI of the image to display.
  final String imageUrl;

  /// The optional width to constrain the image.
  final double? width;

  /// An optional color filter to apply to the image.
  final Color? color;

  /// The optional height to constrain the image.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// An optional widget to display if the image fails to load.
  /// If null, an empty [SizedBox] is rendered.
  final Widget? errorWidget;

  /// Creates a new [GtNetworkImage].
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
