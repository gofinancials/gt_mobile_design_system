import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/data/constants/regex.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:lottie/lottie.dart';

class GtLottie extends GtStatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;
  final AlignmentGeometry alignment;

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
