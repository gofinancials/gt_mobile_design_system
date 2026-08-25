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

  /// The label displayed by the action button.
  final String actionLabel;

  /// The visual variant used by the action button.
  ///
  /// Defaults to [GtButtonVariant.white].
  final GtButtonVariant actionVariant;

  /// Called when the action button is pressed.
  final OnPressed onPressed;

  /// Called when the dismiss icon is tapped.
  final OnPressed onDismiss;

  @override
  Widget build(BuildContext context) {
    final iconColor = context.palette.staticColors.white;
    final txtColor = textColor ?? iconColor;

    return GtCard(
      constraints: .tightFor(
        width: context.dp(180.px),
        height: context.dp(270.px),
      ),
      color: color,
      padding: context.insets.fromLTRBDp(12.px, 16.px, 12.px, 24.px),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: context.spacingMd,
        children: [
          Align(
            alignment: .topRight,
            child: GtInkWell(
              role: .button,
              onTap: onDismiss,
              child: GtIcon.withColor(
                GtIcons.xmark,
                color: dismissIconColor ?? iconColor,
                size: context.dp(16.px),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: context.insets.symmetricDp(horizontal: 9.01.px),
              child: Column(
                mainAxisSize: .min,
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  GtImage(
                    isDecorative: true,
                    image: illustration,
                    fit: .contain,
                    alignment: .topCenter,
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
              style: context.textStyles.buttonXs(),
            ),
          ),
        ],
      ),
    );
  }
}
