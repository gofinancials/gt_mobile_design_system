import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card that prompts the user to take one or two actions — a primary action
/// and, in the dismissible forms, a dismiss option.
///
/// A title and subtitle sit beside an icon — or, with
/// [GtActionCard.dismissibleTrailing], any trailing widget — above a row
/// holding an extra-small [GtRaisedButton] and, when [onDismiss] is set, a
/// [GtTextButton].
///
/// [variant] themes the whole card: its background, the icon colour and,
/// through [GtCardVariant.buttonVariant], both buttons. Each can be broken out
/// on its own — [backgroundColor] for the fill, [buttonVariant] for the
/// buttons' palette, and the `actionButton*` and `dismissButton*` fields for a
/// single button's colours and label style.
class GtActionCard extends GtStatelessWidget {
  /// The main title of the action card.
  final String title;

  /// The secondary text or subtitle of the action card.
  final String subtitle;

  /// Optional style override for the [title].
  ///
  /// Defaults to [GtTextStyles.subHeadS].
  final TextStyle? titleStyle;

  /// Optional style override for the [subtitle].
  ///
  /// Defaults to [GtTextStyles.bodyS] in the palette's sub text colour.
  final TextStyle? subtitleStyle;

  /// The icon drawn beside the text at 32dp, tinted from [variant].
  ///
  /// `null` for [GtActionCard.dismissibleTrailing], which draws [_trailing]
  /// instead.
  final IconData? _icon;

  /// The widget drawn at the top right, beside the text.
  ///
  /// Only [GtActionCard.dismissibleTrailing] sets it, in place of [_icon].
  final Widget? _trailing;

  /// If true, the card will be hidden (faded out).
  final bool hidden;

  /// The visual variant that themes the card.
  ///
  /// Defaults to [GtCardVariant.away]. It decides the background, the icon
  /// colour and the buttons' palette; [backgroundColor] and [buttonVariant]
  /// override the first and the last.
  final GtCardVariant variant;

  /// Overrides the card's background colour.
  ///
  /// Defaults to the [variant]'s tint from [GtCardVariant.getBgColor]. Only
  /// the fill changes — the icon and the buttons still follow [variant] and
  /// [buttonVariant], so pick a colour they read against.
  final Color? backgroundColor;

  /// Overrides the variant both buttons take their colours from.
  ///
  /// Defaults to [variant]'s [GtCardVariant.buttonVariant], which keeps the
  /// buttons in the card's palette. Set it when the buttons should break from
  /// the card, such as a [GtButtonVariant.primary] action on a neutral card.
  /// The per-button colours below win over it.
  final GtButtonVariant? buttonVariant;

  /// A callback function that is invoked when the primary action button is tapped.
  final OnPressed onActionTap;

  /// The text to display on the primary action button.
  final String actionText;

  /// Overrides the action button's background colour.
  ///
  /// Defaults to the resolved [buttonVariant]'s fill. For most variants the
  /// pressed, hovered and focused colour still comes from that variant, so an
  /// override far from it flashes the variant's colour on tap — pair it with
  /// a [buttonVariant] close to it.
  final Color? actionButtonColor;

  /// Overrides the action button's label colour.
  ///
  /// Defaults to the resolved [buttonVariant]'s text colour. Ignored by the
  /// label once [actionButtonStyle] is set, since that style replaces the
  /// default wholesale.
  final Color? actionButtonTextColor;

  /// Replaces the action button's label style outright.
  ///
  /// Defaults to [GtTextStyles.buttonS] tinted with the resolved label colour.
  /// It is a replacement rather than a merge, so a style passed here must
  /// carry its own colour.
  final TextStyle? actionButtonStyle;

  /// An optional callback function for a dismiss action.
  ///
  /// The dismiss button is drawn only while this is non-null, which only the
  /// dismissible constructors allow.
  final OnPressed? onDismiss;

  /// Optional text for the dismiss button. Required if [onDismiss] is provided.
  final String? dismissText;

  /// Overrides the dismiss button's label colour.
  ///
  /// Defaults to the resolved [buttonVariant]'s text-button colour. A text
  /// button has no fill, so there is no background to override. Ignored by the
  /// label once [dismissButtonStyle] is set. Only the dismissible constructors
  /// take it.
  final Color? dismissButtonTextColor;

  /// Replaces the dismiss button's label style outright.
  ///
  /// Defaults to [GtTextStyles.buttonS] tinted with the resolved label colour,
  /// and like [actionButtonStyle] must carry its own colour. Only the
  /// dismissible constructors take it.
  final TextStyle? dismissButtonStyle;

  /// Creates an action card with an icon and a primary action button.
  const GtActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required IconData icon,
    this.hidden = false,
    this.variant = .away,
    required this.onActionTap,
    required this.actionText,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.buttonVariant,
    this.actionButtonColor,
    this.actionButtonTextColor,
    this.actionButtonStyle,
  }) : _icon = icon,
       _trailing = null,
       dismissText = null,
       onDismiss = null,
       dismissButtonTextColor = null,
       dismissButtonStyle = null;

  /// Creates an action card with an icon, a primary action button and a
  /// dismiss text button.
  const GtActionCard.dismissible({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    required IconData icon,
    this.hidden = false,
    this.variant = .away,
    required this.onActionTap,
    required this.actionText,
    required this.onDismiss,
    required this.dismissText,
    this.backgroundColor,
    this.buttonVariant,
    this.actionButtonColor,
    this.actionButtonTextColor,
    this.actionButtonStyle,
    this.dismissButtonTextColor,
    this.dismissButtonStyle,
  }) : _icon = icon,
       _trailing = null;

  /// Creates an action card with a [trailing] widget in place of the icon,
  /// alongside a primary action button and a dismiss text button.
  const GtActionCard.dismissibleTrailing({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    required Widget trailing,
    this.hidden = false,
    this.variant = .away,
    required this.onActionTap,
    required this.actionText,
    required this.onDismiss,
    required this.dismissText,
    this.backgroundColor,
    this.buttonVariant,
    this.actionButtonColor,
    this.actionButtonTextColor,
    this.actionButtonStyle,
    this.dismissButtonTextColor,
    this.dismissButtonStyle,
  }) : _icon = null,
       _trailing = trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mainStyle = context.textStyles.subHeadS();
    final subStyle = context.textStyles.bodyS(color: palette.text.sub);
    final iconColor = switch (variant) {
      .away => palette.away.darker,
      _ => variant.getIconColor(palette),
    };
    final btnVariant = buttonVariant ?? variant.buttonVariant;

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtCard(
        padding: context.insets.allDp(12.px),
        variant: variant,
        color: backgroundColor,
        child: Column(
          children: [
            Row(
              spacing: context.spacingSectionMd,
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    spacing: context.spacingSm,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GtText(title, style: titleStyle ?? mainStyle),
                      GtText(subtitle, style: subtitleStyle ?? subStyle),
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
                if (_trailing != null)
                  Flexible(
                    child: Align(alignment: .topRight, child: _trailing),
                  ),
              ],
            ),
            const GtGap.yXl(),
            Row(
              spacing: context.spacingSm,
              mainAxisAlignment: .start,
              children: [
                Flexible(
                  child: GtRaisedButton(
                    onPressed: onActionTap,
                    variant: btnVariant,
                    text: actionText,
                    size: .xsmall,
                    color: actionButtonColor,
                    textColor: actionButtonTextColor,
                    style: actionButtonStyle,
                  ),
                ),
                if (onDismiss != null)
                  Flexible(
                    child: GtTextButton(
                      onPressed: onDismiss!,
                      variant: btnVariant,
                      text: dismissText,
                      size: .xsmall,
                      textColor: dismissButtonTextColor,
                      style: dismissButtonStyle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
