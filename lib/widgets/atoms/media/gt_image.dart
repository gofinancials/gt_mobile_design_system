import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A unified image widget that dynamically renders different image types.
///
/// Based on the properties of the provided [image] data, this widget delegates
/// rendering to [GtNetworkImage] (for URLs), [GtAssetImage] (for local asset strings),
/// or [GtFileImage] (for local device files). If no valid image data is provided,
/// it gracefully falls back to an empty placeholder box.
class GtImage extends GtStatelessWidget {
  /// The data source for the image, wrapping either a URL, asset path, or [File].
  final AppImageData? image;

  /// The optional width to constrain the image.
  final double? width;

  /// The optional height to constrain the image.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds. Defaults to [Alignment.center].
  final Alignment alignment;

  /// An optional scaffold key.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Whether to apply a default size of 40dp when [width] or [height] are null.
  ///
  /// Defaults to true. If false, the image will size itself based on its intrinsic
  /// dimensions or parent constraints.
  final bool useDefaultSize;

  /// An optional color filter to apply to the image.
  final Color? color;

  /// Whether a network image draws a [GtImageShimmer] while it loads.
  ///
  /// Forwarded to [GtNetworkImage] and ignored for every other source, since
  /// they resolve without a round trip. Set it to `false` where something is
  /// already painted behind the image; see [GtNetworkImage.showLoadingIndicator].
  final bool showLoadingIndicator;

  /// An optional widget to display if the image fails to load.
  ///
  /// Forwarded to whichever widget draws [image], so it covers a failed
  /// download, an unreachable SVG, a missing asset or file, and bytes that
  /// cannot be decoded. Give it the same footprint as the image, since it is
  /// laid out where the image would have been.
  ///
  /// If null, a failed image draws the same empty placeholder box as a
  /// missing one. It does not stand in for a missing [image] either way: with
  /// no valid data there is nothing to fail. Ignored for icon data, which
  /// cannot fail.
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

  /// Creates a new [GtImage].
  ///
  /// The [alignment] defaults to [Alignment.center] and [useDefaultSize] defaults
  /// to true.
  const GtImage({
    this.image,
    this.scaffoldKey,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
    this.color,
    this.useDefaultSize = true,
    this.showLoadingIndicator = true,
    this.errorWidget,
    this.semanticsLabel,
    this.isDecorative = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSize = useDefaultSize ? context.dp(40.px) : null;
    final emptyBox = Align(
      alignment: alignment,
      child: FittedBox(
        fit: fit ?? BoxFit.cover,
        child: SizedBox(
          width: width ?? defaultSize,
          height: height ?? defaultSize,
        ),
      ),
    );
    final fallback = errorWidget ?? emptyBox;

    return Align(
      alignment: alignment,
      child: Builder(
        builder: (_) {
          if (image?.isUrl ?? false) {
            return GtNetworkImage(
              image?.fileUrl ?? "",
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
              showLoadingIndicator: showLoadingIndicator,
              errorWidget: fallback,
              semanticsLabel: semanticsLabel,
              isDecorative: isDecorative,
            );
          }
          if (image?.isString ?? false) {
            return GtAssetImage(
              image?.filePath ?? "",
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorWidget: fallback,
              semanticsLabel: semanticsLabel,
              isDecorative: isDecorative,
            );
          }
          if (image?.isBytes ?? false) {
            return GtMemoryImage(
              image!.bytesData ?? Uint8List(0),
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorWidget: fallback,
              semanticsLabel: semanticsLabel,
              isDecorative: isDecorative,
            );
          }
          if (image?.isIcon ?? false) {
            return GtIcon.withColor(
              image?.iconData ?? GtIcons.anchor,
              alignment: alignment,
              size: width ?? context.dp(24.px),
              color: color ?? context.palette.icon.strong,
              semanticsLabel: isDecorative ? null : semanticsLabel,
            );
          }
          if (image?.isFile ?? false) {
            return GtFileImage(
              image?.file,
              alignment: alignment,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorWidget: fallback,
              semanticsLabel: semanticsLabel,
              isDecorative: isDecorative,
            );
          }
          return emptyBox;
        },
      ),
    );
  }
}
