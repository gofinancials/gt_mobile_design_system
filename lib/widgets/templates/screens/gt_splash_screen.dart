import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen widget used for displaying a splash screen.
///
/// It supports a customizable background color, background image, and a central logo.
class GtSplashScreen extends GtStatelessWidget {
  /// The image to be displayed in the center of the splash screen.
  final AppImageData? logo;

  /// The background color of the splash screen.
  final Color? color;

  /// An optional background image to display behind the splash screen content.
  final ImageProvider? backgroundImage;

  /// An asynchronous task to be executed while the splash screen is active.
  final OnPressedAsync task;

  /// Creates a new [GtSplashScreen].
  const GtSplashScreen({
    super.key,
    required this.task,
    this.color,
    this.backgroundImage,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final center = logo ?? AppImageData(imageData: GtVectors.whiteLogo);
    final bgColor = color ?? context.palette.primary.darker;
    ImageProvider? bgImage = backgroundImage;
    DecorationImage? decorationImage;

    if (bgImage is NetworkImage) {
      bgImage = CachedNetworkImageProvider(bgImage.url);
    }

    if (bgImage != null) {
      decorationImage = DecorationImage(image: bgImage, fit: BoxFit.cover);
    }

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      body: Container(
        alignment: .center,
        decoration: BoxDecoration(image: decorationImage, color: bgColor),
        child: Center(
          child: GtImage(
            image: center,
            width: context.dp(80.px),
            height: context.dp(80.px),
          ),
        ),
      ),
    );
  }
}
