import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A versatile network image widget for the Go Tech design system.
///
/// This widget intelligently handles different types of network image sources:
/// - Base64 encoded strings (starting with "data:") are routed to [GtMemoryImage].
/// - SVG URLs (ending with ".svg") are routed to [GtSvg].
/// - Standard image URLs are handled by [CachedNetworkImage] for efficient caching.
///
/// Raster images are decoded at the size they are drawn, not at their full
/// resolution: from [width] and [height] when given, or else no wider than
/// the screen. See [GtImageDecodeSize].
///
/// Inside an enabled [GtSkeleton] the image is painted as a [GtBone] block.
class GtNetworkImage extends GtStatelessWidget {
  /// An optional local asset path to display while the network image is loading.
  ///
  /// Takes precedence over [showLoadingIndicator]: supplied artwork stands in
  /// for the image whether or not a shimmer would otherwise be drawn.
  final String? placeHolderPath;

  /// Whether to draw a [GtImageShimmer] while the image loads.
  ///
  /// The placeholder is laid out at this widget's full size and paints over
  /// whatever sits behind it. Set it to `false` where the caller has already
  /// drawn something worth keeping — an avatar's initials, a card's artwork —
  /// so the image fades in over that rather than replacing it with a shimmer.
  /// A standalone image with nothing behind it should leave this `true`, or a
  /// slow network reads as a blank rectangle.
  ///
  /// `flutter_test` refuses network requests, so under test the shimmer is
  /// never replaced by the image. It holds still whenever
  /// [MediaQueryData.disableAnimations] is set, which is what lets a test that
  /// sets that flag `pumpAndSettle`; see [GtSkeleton].
  ///
  /// Ignored when [placeHolderPath] supplies still artwork instead.
  final bool showLoadingIndicator;

  /// The source URL or base64 data URI of the image to display.
  final String imageUrl;

  /// The optional width to constrain the image.
  ///
  /// With [height], it also sets the size a raster image is decoded at. When
  /// both are null, the decode is capped at the screen's width instead. Pass
  /// the drawn size wherever it is known, above all in lists, so the decode
  /// matches it. See [GtImageDecodeSize].
  final double? width;

  /// An optional color filter to apply to the image.
  final Color? color;

  /// The optional height to constrain the image.
  ///
  /// See [width] for how it sizes the decode.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// An optional widget to display if the image fails to load.
  ///
  /// Covers every source this widget handles: a failed download, an SVG that
  /// cannot be fetched or compiled, and a base64 data URI that cannot be
  /// decoded. If null, an empty [SizedBox] of [width] by [height] stands in.
  final Widget? errorWidget;

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

  /// Creates a new [GtNetworkImage].
  const GtNetworkImage(
    this.imageUrl, {
    super.key,
    this.placeHolderPath,
    this.showLoadingIndicator = true,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.color,
    this.height,
    this.errorWidget,
    this.semanticsLabel,
    this.isDecorative = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          if (imageUrl.isEmpty) return const Offstage();

          if (imageUrl.startsWith("data:")) {
            final base64String = imageUrl.replaceAll("data:", "");
            final Uint8List bytes;
            try {
              bytes = base64Decode(base64String);
            } on FormatException {
              return _annotate(context, _errorBox);
            }
            return GtMemoryImage(
              bytes,
              height: height,
              width: width,
              alignment: alignment,
              fit: fit,
              errorWidget: errorWidget,
              semanticsLabel: semanticsLabel,
              isDecorative: isDecorative,
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
              errorWidget: errorWidget,
              semanticsLabel: semanticsLabel,
              isDecorative: isDecorative,
            );
          }

          final decode = context.imageDecodeSize(width: width, height: height);
          return _annotate(context, _cachedImage(decode));
        },
      ),
    );
  }

  /// The [CachedNetworkImage] for [imageUrl], decoded at [decode].
  Widget _cachedImage(GtImageDecodeSize decode) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      memCacheWidth: decode.width,
      memCacheHeight: decode.height,
      alignment: alignment,
      fit: fit,
      color: color,
      errorWidget: (_, _, _) => _errorBox,
      placeholder: (context, _) {
        if (placeHolderPath == null) {
          if (!showLoadingIndicator) {
            return SizedBox(height: height, width: width);
          }
          return GtImageShimmer(width: width, height: height);
        }
        return GtAssetImage(
          placeHolderPath!,
          width: width,
          height: height,
          alignment: alignment,
          // The placeholder stands in for the real image and must not
          // announce itself alongside it.
          isDecorative: true,
        );
      },
    );
  }

  /// What stands in for an image that fails: [errorWidget], or an empty box
  /// holding the image's place.
  Widget get _errorBox => errorWidget ?? SizedBox(height: height, width: width);

  /// Wraps [image] in the skeleton bone and semantics the other image atoms
  /// apply themselves, for children that cannot: [CachedNetworkImage], and
  /// the [_errorBox] drawn when a data URI cannot be decoded.
  Widget _annotate(BuildContext context, Widget image) {
    if (context.inSkeleton) {
      image = GtBone(child: image);
    }

    // CachedNetworkImage exposes no semantics parameters of its own, so
    // the annotation has to be applied from outside. An unlabelled image
    // is decoration as far as the user is concerned; announcing it as an
    // anonymous image only adds a stop with no payload.
    if (isDecorative || semanticsLabel == null) {
      return ExcludeSemantics(child: image);
    }

    return GtSemantics(role: .image, label: semanticsLabel, child: image);
  }
}
