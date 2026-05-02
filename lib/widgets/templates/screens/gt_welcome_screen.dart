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
  ///
  /// If true, renders a [GtActionAppBar] containing the default logo.
  final bool showLogo;

  /// The main headline or welcome message displayed on the screen.
  final String _title;

  /// An optional custom widget to use in place of the standard text title.
  final Widget? _titleWidget;

  /// The alignment of the title (or title widget) within its container.
  ///
  /// Defaults to [Alignment.bottomLeft] in the standard constructor, and
  /// [Alignment.topCenter] when using [GtWelcomeScreen.withTitleWidget].
  final AlignmentGeometry titleAlignment;

  /// The primary action button displayed at the bottom of the screen.
  final GtButton primaryButton;

  /// The secondary action button displayed just below the [primaryButton].
  final GtButton secondaryButton;

  /// The background color of the Welcome screen.
  ///
  /// If null, defaults to the primary darker color from the current theme palette.
  final Color? color;

  /// The color of the standard title text.
  ///
  /// If null, defaults to static white. Ignored when using [GtWelcomeScreen.withTitleWidget].
  final Color? titleColor;

  /// An optional background image to display behind the welcome screen content.
  ///
  /// If a [NetworkImage] is provided, it is automatically cached using [CachedNetworkImageProvider].
  final ImageProvider? backgroundImage;

  /// Creates a new [GtWelcomeScreen].
  const GtWelcomeScreen({
    super.key,
    required String title,
    required this.primaryButton,
    required this.secondaryButton,
    this.color,
    this.titleColor,
    this.showLogo = true,
    this.titleAlignment = .bottomLeft,
    this.backgroundImage,
  }) : _title = title,
       _titleWidget = null;

  /// Creates a new [GtWelcomeScreen.withTitleWidget].
  const GtWelcomeScreen.withTitleWidget({
    super.key,
    required Widget title,
    required this.primaryButton,
    required this.secondaryButton,
    this.color,
    this.showLogo = true,
    this.titleAlignment = .topCenter,
    this.backgroundImage,
  }) : _title = "",
       _titleWidget = title,
       titleColor = null;

  @override
  Widget build(BuildContext context) {
    GtActionAppBar? appBar;
    Widget? title = _titleWidget;
    title ??= GtText(
      _title.upper,
      textAlign: .start,
      style: context.textStyles.welcome(
        color: titleColor ?? context.palette.staticColors.white,
      ),
    );

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
              if (_titleWidget == null) GtGap.ySectionMd(),
              Expanded(
                child: Align(alignment: titleAlignment, child: title),
              ),
              GtGap.ySectionMd(),
              primaryButton,
              GtGap.yMd(),
              secondaryButton,
              if (!context.isIos) GtGap.ySectionSm(),
            ],
          ),
        ),
      ),
    );
  }
}
