import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized list tile for displaying account information, typically
/// showing an account name, subtitle, and an avatar or leading icon.
class GtAccountListTile extends GtStatelessWidget {
  /// The primary name or title of the account.
  final String title;

  /// Secondary information, typically the account type or currency.
  final String subtitle;

  /// An icon or avatar displayed at the start of the tile.
  final Widget leading;

  /// An optional widget displayed at the end of the tile (e.g., balance, chevron, or switch).
  final Widget? trailing;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed? onTap;

  /// Whether the [subtitle] should be rendered with a bolder text style. Defaults to true.
  final bool hasBoldSubtitle;

  /// Creates a [GtAccountListTile].
  const GtAccountListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.leading,
    this.trailing,
    this.onTap,
    this.hasBoldSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final subStyle = switch (hasBoldSubtitle) {
      true => context.textStyles.subHeadXs(color: palette.text.sub),
      _ => context.textStyles.bodyXs(color: palette.text.sub),
    };

    return InkWell(
      onTap: () {
        if (onTap == null) return;
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingMd,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: leading,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  GtText(subtitle, style: subStyle),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// A list tile tailored for displaying contact information, showing a title,
/// subtitle, and a leading widget (usually an avatar).
class GtContactListTile extends GtStatelessWidget {
  /// The name or title of the contact.
  final String title;

  /// Secondary information, typically a username, email, or phone number.
  final String subtitle;

  /// An avatar or icon representing the contact.
  final Widget leading;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed onTap;

  /// Creates a [GtContactListTile].
  const GtContactListTile(
    this.title, {
    super.key,
    required this.subtitle,
    required this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final subStyle = context.textStyles.bodyXs(color: palette.text.sub);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap.call();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 12.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: leading,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GtText(title, style: context.textStyles.subHeadS()),
                  GtText(subtitle, style: subStyle),
                ],
              ),
            ),
            GtIcon(
              GtIcons.chevronRight,
              size: 16,
              alignment: Alignment.centerRight,
              variant: .soft,
            ),
          ],
        ),
      ),
    );
  }
}

/// A list tile to display stakeholder information, generating a circular
/// avatar with initials based on the provided [name].
class GtStakeHolderListTile extends GtStatelessWidget {
  /// The full name of the stakeholder, used to generate the avatar initials.
  final String name;

  /// The stakeholder's role or position.
  final String position;

  /// Additional details about the stakeholder, such as ownership percentage.
  final String footer;

  /// The callback triggered when the tile is tapped. Provides light haptic feedback.
  final OnPressed onTap;

  /// Creates a [GtStakeHolderListTile].
  const GtStakeHolderListTile(
    this.name, {
    super.key,
    required this.position,
    required this.footer,
    required this.onTap,
  });

  String get initials => AppHelpers.getInitials(name) ?? "";

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final leading = Row(
      crossAxisAlignment: .start,
      spacing: context.spacingBase,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tight(Size.square(36)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: .circle,
              color: palette.primary.alpha10,
            ),
            child: Center(
              child: GtText(
                initials.upper,
                style: context.textStyles.h7(color: palette.primary.base),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            spacing: context.spacingSm,
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            children: [
              GtText(name.upper, style: context.textStyles.h7()),
              GtText(
                position,
                style: context.textStyles.bodyS(color: palette.text.sub),
              ),
              GtText(
                footer,
                style: context.textStyles.bodyXs(color: palette.primary.dark),
              ),
            ],
          ),
        ),
      ],
    );

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            Expanded(child: leading),
            GtIcon(GtIcons.chevronRight, size: 16, variant: .soft),
          ],
        ),
      ),
    );
  }
}

/// A list tile that displays a stakeholder's verification status, featuring
/// a trailing status widget.
class GtStakeHolderStatusListTile extends GtStatelessWidget {
  /// The full name of the stakeholder, used to generate the avatar initials.
  final String name;

  /// The stakeholder's role or position.
  final String position;

  /// A widget displayed at the end of the tile, typically a status pill.
  final Widget trailing;

  /// Whether the stakeholder's status is verified. If true, the tile is visually disabled.
  final bool isVerified;

  /// Creates a [GtStakeHolderStatusListTile].
  const GtStakeHolderStatusListTile(
    this.name, {
    super.key,
    required this.position,
    required this.trailing,
    this.isVerified = false,
  });

  String get initials => AppHelpers.getInitials(name) ?? "";

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GtDisabledOverlay(
      isVerified,
      child: Padding(
        padding: context.insets.symmetricDp(vertical: 8.px),
        child: Row(
          spacing: context.spacingBase,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size.square(36)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: .circle,
                  color: palette.primary.alpha10,
                ),
                child: Center(
                  child: GtText(
                    initials.upper,
                    style: context.textStyles.h7(color: palette.primary.base),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: context.spacingSm,
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  GtText(name.upper, style: context.textStyles.h7()),
                  GtText(
                    position,
                    style: context.textStyles.bodyS(color: palette.text.sub),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}