import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A dismissible promotional card with an illustration and primary action.
///
/// Use [GtAdvertCard] for prominent, short-lived content such as feature
/// announcements, product promotions, or suggested actions. The card presents
/// a dismiss control, an [illustration], a [title] and [subtitle], followed by
/// a raised action button.
///
/// The supplied [color] is used as the card background. By default, the text
/// and dismiss icon use the theme's static white color, while [textColor] and
/// [dismissIconColor] can override them independently.
class GtAdvertCard extends GtStatelessWidget {
  /// Creates an advert card.
  ///
  /// The [color], [illustration], [title], [subtitle], [actionLabel],
  /// [onPressed], and [onDismiss] arguments are required.
  const GtAdvertCard({
    super.key,
    required this.color,
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onPressed,
    required this.onDismiss,
    this.dismissIconColor,
    this.textColor,
    this.actionVariant = .white,
    this.actionTextColor,
  });

  /// The card's background color.
  final Color color;

  /// The dismiss icon color.
  ///
  /// Defaults to the theme's static white color when omitted.
  final Color? dismissIconColor;

  /// The title and subtitle color.
  ///
  /// Defaults to the theme's static white color when omitted.
  final Color? textColor;

  /// The illustration displayed above the card's text content.
  final AppImageData illustration;

  /// The card's primary heading.
  ///
  /// The rendered value is converted to uppercase and limited to one line.
  final String title;

  /// The supporting message displayed below [title].
  ///
  /// The rendered value is limited to three lines.
  final String subtitle;

  /// The visual variant used by the action button.
  final GtButtonVariant actionVariant;

  /// The label displayed by the action button.
  final String actionLabel;

  /// The color of the action button text.
  final Color? actionTextColor;

  /// Called when the action button is pressed.
  final OnPressed onPressed;

  /// Called when the dismiss icon is tapped.
  final OnPressed onDismiss;

  @override
  Widget build(BuildContext context) {
    final iconColor = context.palette.staticColors.white;
    final txtColor = textColor ?? iconColor;
    final maxWidth = context.fractionalShortest(.5);
    final maxHeight = maxWidth * 1.5;

    return GtCard(
      color: color,
      padding: context.insets.fromLTRBDp(12.px, 16.px, 12.px, 24.px),
      constraints: .loose(Size(maxWidth, maxHeight)),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: context.spacingMd,
        children: [
          Align(
            alignment: .topRight,
            child: GtInkWell(
              role: .button,
              onTap: onDismiss,
              child: Transform.scale(
                alignment: .centerRight,
                scale: 1.2,
                child: GtIcon.withColor(
                  GtIcons.xmark,
                  color: dismissIconColor ?? iconColor,
                  size: context.dp(16.px),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: context.insets.symmetricDp(horizontal: 9.01.px),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  GtImage(
                    isDecorative: true,
                    image: illustration,
                    fit: .contain,
                    alignment: .center,
                    useDefaultSize: false,
                    width: context.dp(92.px),
                    height: context.dp(92.px),
                  ),
                  GtText(
                    title.upper,
                    textAlign: .center,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: context.textStyles.subHeadS(
                      color: txtColor,
                      weight: .w600,
                      heightPx: 16,
                    ),
                  ),
                  const GtGap.ySm(),
                  GtText(
                    subtitle,
                    textAlign: .center,
                    maxLines: 3,
                    overflow: .ellipsis,
                    style: context.textStyles.subHeadXs(color: txtColor),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: context.insets.onlyDp(top: 2.px),
            child: GtRaisedButton(
              onPressed: onPressed,
              text: actionLabel,
              variant: actionVariant,
              size: .pill,
              alignment: .center,
              cornerRadius: context.borderRadiusMd,
              style: context.textStyles.buttonXs(
                color: actionTextColor ?? context.palette.staticColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A horizontally scrollable list of [GtAdvertCard] widgets.
///
/// Use [GtAdvertCardCarousel] to display multiple promotional cards in a
/// horizontally scrolling list. The carousel automatically adapts to the
/// screen width, ensuring that the cards are always visible.
///
/// By default, the cards are separated by [context.spacingBase] (8px).
/// This spacing can be customized using the [spacing] parameter.
class GtAdvertCardCarousel extends GtStatelessWidget {
  const GtAdvertCardCarousel({super.key, required this.children, this.spacing});

  final List<GtAdvertCard> children;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(spacing: spacing ?? context.spacingBase, children: children),
    );
  }
}
