import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card that prompts the user to take one or two actions (e.g., a primary
/// action and a dismiss option).
class GtActionCard extends GtStatelessWidget {
  /// The main title of the action card.
  final String title;

  /// The secondary text or subtitle of the action card.
  final String subtitle;

  /// The icon to display in the action card.
  final IconData? _icon;

  /// The icon to display in the action card.
  final Widget? _trailing;

  /// If true, the card will be hidden (faded out).
  final bool hidden;

  /// The visual variant of the card, which determines its background and button styles.
  final GtCardVariant variant;

  /// A callback function that is invoked when the primary action button is tapped.
  final OnPressed onActionTap;

  /// The text to display on the primary action button.
  final String actionText;

  /// An optional callback function for a dismiss action.
  final OnPressed? onDismiss;

  /// Optional text for the dismiss button. Required if [onDismiss] is provided.
  final String? dismissText;

  /// Creates an action card with a primary action button.
  const GtActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required IconData icon,
    this.hidden = false,
    this.variant = .away,
    required this.onActionTap,
    required this.actionText,
  }) : _icon = icon,
       _trailing = null,
       dismissText = null,
       onDismiss = null;

  /// Creates an action card with both a primary action button and a dismissible text button.
  const GtActionCard.dismissible({
    super.key,
    required this.title,
    required this.subtitle,
    required IconData icon,
    this.hidden = false,
    this.variant = .away,
    required this.onActionTap,
    required this.actionText,
    required this.onDismiss,
    required this.dismissText,
  }) : _icon = icon,
       _trailing = null;

  /// Creates an action card with both a primary action button and a dismissible text button.
  const GtActionCard.dismissibleTrailing({
    super.key,
    required this.title,
    required this.subtitle,
    required Widget trailing,
    this.hidden = false,
    this.variant = .away,
    required this.onActionTap,
    required this.actionText,
    required this.onDismiss,
    required this.dismissText,
  }) : _icon = null,
       _trailing = trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = switch (variant) {
      .away => palette.away.darker,
      _ => variant.getIconColor(palette),
    };

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtCard(
        padding: context.insets.allDp(12.px),
        variant: variant,
        child: Row(
          spacing: context.spacingsectionMd,
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: Column(
                spacing: context.spacingSm,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  GtText(
                    subtitle,
                    style: context.textStyles.bodyS(color: palette.text.sub),
                  ),
                  const GtGap.yXl(),
                  Row(
                    spacing: context.spacingSm,
                    mainAxisAlignment: .start,
                    children: [
                      GtRaisedButton(
                        onPressed: onActionTap,
                        variant: variant.buttonVariant,
                        text: actionText,
                        size: .xsmall,
                      ),
                      if (onDismiss != null)
                        GtTextButton(
                          onPressed: onDismiss!,
                          variant: variant.buttonVariant,
                          text: dismissText,
                          size: .xsmall,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (_icon != null)
              GtIcon.withColor(
                _icon,
                color: iconColor,
                size: 32,
                alignment: .topLeft,
              ),
            ?_trailing,
          ],
        ),
      ),
    );
  }
}
