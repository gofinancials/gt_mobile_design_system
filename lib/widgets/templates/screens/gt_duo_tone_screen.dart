import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A template screen widget that features a prominent duotone gradient header with an illustration.
///
/// Typically used for onboarding, featured announcements, or success/completion states.
/// It includes a large top section with a gradient and image, followed by a title,
/// description, an optional footer, and a main action button.
class GtDuotoneScreen extends GtStatelessWidget {
  /// Overrides gradient. Null preserves the current default.
  final Gradient? gradient;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides description style. Null preserves the current default.
  final TextStyle? descriptionStyle;

  /// Overrides description color. Null preserves the current default.
  final Color? descriptionColor;

  /// Overrides content padding. Null preserves the current default.
  final EdgeInsetsGeometry? contentPadding;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides footer spacing in logical pixels. Null preserves the current default.
  final double? footerSpacing;

  /// The primary illustration or image displayed in the upper gradient section of the screen.
  final AppImageData illustration;

  /// The primary heading text displayed below the illustration.
  final String title;

  /// The secondary descriptive text displayed below the title.
  final String description;

  /// The visual variant determining the color scheme of the top gradient.
  final GtCardVariant variant;

  /// Variant of the bottom button
  final GtButtonVariant buttonVariant;

  /// The callback triggered when the main action button is pressed.
  final OnPressed onTap;

  /// The text displayed on the main action button.
  final String buttonText;

  /// An optional widget displayed below the description, typically used for extra information.
  final Widget? footer;

  /// The maximum number of lines for the title text.
  final int titleMaxLines;

  /// The overflow for the title text.
  final TextOverflow? titleOverflow;

  /// The size of the illustration image
  final Size? illustrationSize;

  /// Creates a [GtDuotoneScreen].
  const GtDuotoneScreen({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.buttonText,
    this.variant = .featured,
    this.buttonVariant = .primary,
    required this.onTap,
    this.titleMaxLines = 1,
    this.titleOverflow,
    this.illustrationSize,
    this.footer,
    this.gradient,
    this.titleStyle,
    this.titleColor,
    this.descriptionStyle,
    this.descriptionColor,
    this.contentPadding,
    this.verticalSpacing,
    this.footerSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = this.gradient ?? variant.getGradient(context);
    final bgColor = context.palette.bg.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      appBar: GtActionAppBar(
        implyLeading: false,
        trailing: GtOptionalWidgetPair(tail: GtCancelButton(color: bgColor)),
      ),
      bottomNavigationBar: GtButtonBottomNavBar(
        button: GtRaisedButton(
          onPressed: onTap,
          text: buttonText,
          variant: buttonVariant,
        ),
      ),
      key: ValueKey(('gt-duotone-screen', title, buttonText)),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(gradient: gradient),
              alignment: .bottomCenter,
              child: GtImage(
                image: illustration,
                height: illustrationSize?.height ?? context.dp(320.px),
                width: illustrationSize?.width,
                alignment: .bottomCenter,
                isDecorative: true,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: SingleChildScrollView(
              padding:
                  contentPadding ??
                  context.insets.fromLTRBDp(36.px, 40.px, 36.px, 10.px),
              child: Column(
                spacing: verticalSpacing ?? context.spacingMd,
                mainAxisAlignment: .start,
                crossAxisAlignment: .stretch,
                children: [
                  GtText(
                    title.upper,
                    style: GtTextStyleOverrides.resolve(
                      titleStyle,
                      context.textStyles.h4(),
                      titleColor,
                    ),
                    overflow: titleOverflow,
                    maxLines: titleMaxLines,
                    textAlign: .center,
                  ),
                  GtText(
                    description,
                    style: GtTextStyleOverrides.resolve(
                      descriptionStyle,
                      context.textStyles.subHeadS(
                        color: context.palette.text.darkerSub,
                      ),
                      descriptionColor,
                    ),
                    textAlign: .center,
                  ),
                  if (footer != null) ...[
                    (footerSpacing == null
                        ? const GtGap.yBase()
                        : SizedBox(height: footerSpacing)),
                    ?footer,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
