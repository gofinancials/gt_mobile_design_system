import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen for debit-card related entry states.
///
/// This layout intentionally omits a textual app-bar title and keeps a
/// close ("X") action at the top-right, followed by vertically stacked content:
/// illustration, title, subtitle, and a primary action button.
class GtDebitCardScreen extends GtStatelessWidget {
  /// The top illustration displayed above text content.
  ///
  /// When `null` or without a resolvable source, the hero image and its trailing
  /// gap are omitted.
  final AppImageData? image;

  /// The main heading shown beneath the [image].
  final String title;

  /// Supporting description shown below [title].
  final String subtitle;

  /// Primary call-to-action button rendered at the bottom of the content stack.
  final GtButton button;

  /// Optional callback for the top-right close action.
  ///
  /// If omitted, [GtCancelButton] falls back to default pop behavior.
  final OnPressed? onClose;

  /// Background color of the screen surface.
  ///
  /// Defaults to the semantic primary background from the active palette.
  final Color? backgroundColor;

  /// Color of the texts on the screen.
  ///
  /// Defaults to the semantic white color from the active palette.
  final Color? textColor;

  /// An optional image painted over the [backgroundColor], such as a texture.
  ///
  /// It fills the whole screen, behind the illustration, and the colour shows
  /// through wherever the image is transparent.
  final DecorationImage? backgroundImage;

  /// Overrides the [title]'s style. Null preserves the default Display 1.
  ///
  /// Replaces the default wholesale; an explicit [textColor] still wins over
  /// its colour.
  final TextStyle? titleStyle;

  /// Overrides the [subtitle]'s style. Null preserves the default Body S.
  ///
  /// Replaces the default wholesale; an explicit [textColor] still wins over
  /// its colour.
  final TextStyle? subtitleStyle;

  /// Horizontal alignment of the [title] and [subtitle].
  ///
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Creates a [GtDebitCardScreen].
  const GtDebitCardScreen({
    super.key,
    this.image,
    required this.title,
    required this.subtitle,
    required this.button,
    this.textColor,
    this.onClose,
    this.backgroundColor,
    this.backgroundImage,
    this.titleStyle,
    this.subtitleStyle,
    this.textAlign = .start,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.palette.primary.base;
    final computedTextColor = textColor ?? context.palette.staticColors.white;
    final computedImage = image ?? AppImageData.asset(GtVectors.sterlingCard);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: GtActionAppBar(
        implyLeading: false,
        trailing: GtOptionalWidgetPair(
          tail: GtCancelButton(
            onTap: onClose,
            color: context.palette.text.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (backgroundImage case DecorationImage image)
            Positioned.fill(
              child: DecoratedBox(decoration: BoxDecoration(image: image)),
            ),
          Positioned(
            right: 0,
            top: context.dp(140.px),
            child: GtImage(
              image: computedImage,
              width: min(context.fractionalShortest(.8), 358),
              height: max(context.fractionalLongest(.35), 280),
              alignment: .centerRight,
              fit: .contain,
              isDecorative: true,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: context.insets.defaultHorizontalInsets,
                child: Column(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .stretch,
                  children: [
                    GtText(
                      title.upper,
                      textAlign: textAlign,
                      style: GtTextStyleOverrides.resolve(
                        titleStyle,
                        context.textStyles.d1(
                          color: computedTextColor,
                          heightPx: 52,
                        ),
                        textColor,
                      ),
                    ),
                    GtGap.yLg(),
                    // Subtitle block.
                    GtText(
                      subtitle.capitalise(),
                      textAlign: textAlign,
                      style: GtTextStyleOverrides.resolve(
                        subtitleStyle,
                        context.textStyles.bodyS(color: computedTextColor),
                        textColor,
                      ),
                    ),
                    GtGap.yXl(),
                    button,
                    GtGap.yLg(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
