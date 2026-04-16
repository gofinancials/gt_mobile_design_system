import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/data/constants/regex.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:lottie/lottie.dart';

/// A widget that seamlessly renders Lottie animations from either a network URL or a local asset.
///
/// This widget analyzes the provided [path] using [AppRegex.urlRegex] to determine
/// if it should load the animation over the network via [LottieBuilder.network]
/// or from the local asset bundle via [LottieBuilder.asset].
class GtLottie extends GtStatelessWidget {
  /// The source path for the Lottie animation. This can be a valid HTTP(S) URL or a local asset path.
  final String path;

  /// The optional width to constrain the animation.
  final double? width;

  /// The optional height to constrain the animation.
  final double? height;

  /// How the animation should be inscribed into the space allocated during layout. Defaults to [BoxFit.contain].
  final BoxFit fit;

  /// Whether the animation should play repeatedly. Defaults to true.
  final bool repeat;

  /// How to align the animation within its bounds. Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  /// Creates a new [GtLottie] animation widget.
  const GtLottie(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (AppRegex.urlRegex.hasMatch(path)) {
      return LottieBuilder.network(
        path,
        height: height,
        alignment: alignment,
        repeat: repeat,
        fit: fit,
        width: width,
      );
    }
    return LottieBuilder.asset(
      path,
      height: height,
      alignment: alignment,
      repeat: repeat,
      fit: fit,
      width: width,
    );
  }
}
