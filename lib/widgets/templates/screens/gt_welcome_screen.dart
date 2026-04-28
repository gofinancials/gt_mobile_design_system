import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/extensions/extensions.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen widget used for displaying a welcome screen.
///
/// It features an optional logo, a customizable title, a background, and
/// two standard action buttons (primary and secondary).
class GtWelcomeScreen extends GtStatelessWidget {
  /// Whether to display the default application logo at the top of the screen.
  final bool showLogo;

  /// The main headline or welcome message displayed on the screen.
  final String title;

  /// The alignment of the [title] within its container.
  /// Defaults to [Alignment.bottomLeft] if not provided.
  final AlignmentGeometry titleAlignment;

  /// The primary action button displayed at the bottom of the screen.
  final GtButton primaryButton;

  /// The secondary action button displayed just below the [primaryButton].
  final GtButton secondaryButton;

  /// The background color of the Welcome screen.
  final Color? color;

  /// The color of the [title] text. Defaults to white if not provided.
  final Color? titleColor;

  /// An optional background image to display behind the welcome screen content.
  final ImageProvider? backgroundImage;

  /// Creates a new [GtWelcomeScreen].
  const GtWelcomeScreen({
    super.key,
    required this.title,
    required this.primaryButton,
    required this.secondaryButton,
    this.color,
    this.titleColor,
    this.showLogo = true,
    this.titleAlignment = .bottomLeft,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    GtActionAppBar? appBar;

    if (showLogo) {
      appBar = GtActionAppBar(
        implyLeading: false,
        leading: GtSvg(GtVectors.sterling, width: 104),
      );
    }

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
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(image: decorationImage, color: bgColor),
        padding: context.insets.defaultHorizontalInsets,
        child: SafeArea(
          child: Column(
            mainAxisSize: .max,
            crossAxisAlignment: .stretch,
            children: [
              GtGap.ySectionMd(),
              Expanded(
                child: Align(
                  alignment: titleAlignment,
                  child: GtText(
                    title.upper,
                    textAlign: .start,
                    style: context.textStyles.welcome(
                      color: titleColor ?? context.palette.staticColors.white,
                    ),
                  ),
                ),
              ),
              GtGap.ySectionMd(),
              primaryButton,
              GtGap.yMd(),
              secondaryButton,
            ],
          ),
        ),
      ),
    );
  }
}
