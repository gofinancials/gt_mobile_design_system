import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Standardized **profile header**: a person's name with an optional
/// supporting line on the leading edge and their avatar on the trailing edge,
/// such as the header of a team member's profile.
///
/// Layout follows the profile-header spec:
/// - **Title:** uppercase, 24px, weight 700 ([GtTextStyles.h5] on a 24px
///   line), in [GtPalette.text.strong].
/// - **Subtitle:** 12px, weight 500 ([GtTextStyles.bodyXs]), in
///   [GtPalette.text.sub] — typically the email and status
///   (`'foluke.c@gmail.com • Active'`).
/// - **Avatar:** a 48dp [GtAvatar] showing the [avatar] image, or [initials]
///   in [GtPalette.primary.darker] over the avatar gradient.
/// - **Tag:** an optional label pill below the row, such as the member's role
///   (`'Account owner'`).
///
/// The title takes the remaining width, so a long name wraps rather than
/// pushing the avatar off-screen. The header renders no padding of its own —
/// wrap it or rely on the padding of the surrounding screen.
///
/// For the centred header of the signed-in user's own profile, use
/// [GtProfileHeroHeader].
class GtProfileHeader extends GtStatelessWidget {
  /// The person's name (shown in **uppercase**).
  final String title;

  /// Optional supporting line below the [title], such as the person's email
  /// and status.
  final String? subtitle;

  /// Optional label shown in a pill below the header, such as the person's
  /// role (shown in **uppercase**).
  final String? tag;

  /// Optional image data for the person's avatar.
  ///
  /// When absent or invalid, the avatar shows [initials] instead.
  final AppImageData? avatar;

  /// The initials shown in the avatar behind any [avatar] image.
  ///
  /// Defaults to the initials of [title].
  final String? initials;

  /// Callback triggered when the avatar is pressed.
  ///
  /// The avatar is decorative and takes no taps when this is `null`.
  final OnPressed? onClickAvatar;

  /// An accessible name for the avatar, already localised.
  ///
  /// Only announced when [onClickAvatar] makes the avatar interactive.
  final String? avatarSemanticsLabel;

  /// Creates a [GtProfileHeader].
  const GtProfileHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.tag,
    this.avatar,
    this.initials,
    this.onClickAvatar,
    this.avatarSemanticsLabel,
  });

  /// Creates a skeleton of a profile header, standing in for one whose
  /// person is still loading.
  const factory GtProfileHeader.skeleton({Key? key}) = _GtProfileHeaderSkeleton;

  /// [initials], else the initials of [title].
  String? get _initials => initials ?? title.initials;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    Widget child = Row(
      crossAxisAlignment: .center,
      spacing: context.spacingMd,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              GtText(
                title.upper,
                style: context.textStyles.h5(
                  heightPx: 24,
                  color: palette.text.strong,
                ),
              ),
              if (subtitle.hasValue)
                GtText(
                  subtitle,
                  style: context.textStyles.bodyXs(
                    weight: .w500,
                    color: palette.text.sub,
                  ),
                ),
            ],
          ),
        ),
        GtAvatar(
          avatar: avatar,
          size: context.dp(48.px),
          initials: _initials,
          initialsStyle: context.textStyles.avatar(
            size: 24,
            heightPx: 32,
            weight: .w700,
            color: palette.primary.darker,
          ),
          onPressed: onClickAvatar,
          semanticsLabel: avatarSemanticsLabel,
        ),
      ],
    );

    if (tag.hasValue) {
      child = Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: context.spacingXs,
        children: [
          child,
          GtPill(
            text: tag.value.upper,
            variant: .primary,
            bgColor: palette.primary.alpha10,
            textColor: palette.text.strong,
            padding: context.insets.symmetricDp(
              horizontal: 12.px,
              vertical: 8.px,
            ),
            borderRadius: context.borderRadiusMd,
            alignment: .centerLeft,
          ),
        ],
      );
    }

    return child;
  }
}

/// Standardized **profile hero header**: the centred header of the signed-in
/// user's own profile screen.
///
/// Layout follows the profile-hero spec, stacked and centred with a 12px gap:
/// - **Avatar:** a 64dp rounded-square [GtSquareAvatar] on
///   [GtPalette.bg.soft], showing the [avatar] image or, without one, the user
///   glyph.
/// - **Name:** uppercase, 32px, weight 700 ([GtTextStyles.d4] on a 32px line).
/// - **Account pill:** an optional pill naming the account the user is acting
///   for, with its initials, raised on the brand pill shadow. With
///   [onSwitchAccount] it becomes a button and gains a chevron, so it opens an
///   account switcher.
///
/// The avatar is a user avatar, so it is wrapped in the `"user-avatar"` [Hero]
/// shared with the app bar avatars; keep it off routes that already show one.
///
/// For the header of another person's profile, use [GtProfileHeader].
class GtProfileHeroHeader extends GtStatelessWidget {
  /// The user's name (shown in **uppercase**).
  final String name;

  /// Optional image data for the user's avatar.
  ///
  /// When absent or invalid, the avatar shows the user glyph instead.
  final AppImageData? avatar;

  /// Optional name of the account the user is acting for, such as their
  /// business (shown in **uppercase**).
  ///
  /// The account pill is only shown when this has a value.
  final String? accountName;

  /// The initials shown in the account pill.
  ///
  /// Defaults to the initials of [accountName].
  final String? accountInitials;

  /// Callback triggered when the account pill is pressed, typically to open an
  /// account switcher.
  ///
  /// When `null`, the pill is a plain label without a chevron.
  final OnPressed? onSwitchAccount;

  /// An accessible name for the account pill, already localised.
  ///
  /// Replaces [accountName] for screen readers; when absent, the visible name
  /// is announced instead. Supply it when the name alone doesn't say what the
  /// pill does (e.g. "Switch account").
  final String? switchAccountSemanticsLabel;

  /// Creates a [GtProfileHeroHeader].
  const GtProfileHeroHeader({
    super.key,
    required this.name,
    this.avatar,
    this.accountName,
    this.accountInitials,
    this.onSwitchAccount,
    this.switchAccountSemanticsLabel,
  });

  /// Creates a skeleton of a profile hero header, standing in for one whose
  /// user is still loading.
  const factory GtProfileHeroHeader.skeleton({Key? key}) =
      _GtProfileHeroHeaderSkeleton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      spacing: context.spacingMd,
      children: [
        GtSquareAvatar(
          avatar: avatar,
          size: context.dp(64.px),
          borderRadius: context.borderRadius2Xl,
          showGradient: false,
          bgColor: context.palette.bg.soft,
          userIconSize: context.dp(32.px),
          isUserAvatar: true,
        ),
        GtText(
          name.upper,
          style: context.textStyles.d4(heightPx: 32),
          textAlign: .center,
        ),
        if (accountName.hasValue)
          _GtProfileAccountPill(
            name: accountName.value,
            initials: accountInitials ?? accountName.initials,
            onTap: onSwitchAccount,
            semanticsLabel: switchAccountSemanticsLabel,
          ),
      ],
    );
  }
}

/// A private pill naming the account a [GtProfileHeroHeader] user is acting
/// for, led by the account's initials.
class _GtProfileAccountPill extends GtStatelessWidget {
  /// See [GtProfileHeroHeader.accountName].
  final String name;

  /// See [GtProfileHeroHeader.accountInitials].
  final String? initials;

  /// See [GtProfileHeroHeader.onSwitchAccount].
  final OnPressed? onTap;

  /// See [GtProfileHeroHeader.switchAccountSemanticsLabel].
  final String? semanticsLabel;

  /// Creates a [_GtProfileAccountPill].
  const _GtProfileAccountPill({
    required this.name,
    this.initials,
    this.onTap,
    this.semanticsLabel,
  });

  /// The pill's fill: [GtPalette.primary] alpha-10 flattened onto
  /// [GtPalette.bg.white].
  ///
  /// A [BoxShadow] is painted beneath its box as well as around it, so a
  /// translucent fill would let the pill's own shadow darken it.
  Color _bgColor(GtPalette palette) {
    return Color.alphaBlend(palette.primary.alpha10, palette.bg.white);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = palette.primary.darker;

    Widget? chevron;

    if (onTap != null) {
      chevron = GtIcon.withColor(
        GtIcons.chevronDownOutline,
        color: color,
        size: context.dp(14.px),
      );
    }

    final pill = GtPill(
      text: name.upper,
      variant: .primary,
      bgColor: _bgColor(palette),
      borderColor: palette.primary.alpha10,
      textColor: color,
      textStyle: context.textStyles.button2s(color: color),
      icon: GtAvatar(
        size: context.dp(32.px),
        initials: initials,
        gradient: context.gradients.ghostGradient,
        initialsStyle: context.textStyles.avatar(
          size: 12,
          heightPx: 16,
          widthPct: 5,
          weight: .w700,
          color: color,
        ),
      ),
      trailing: chevron,
      padding: context.insets.onlyDp(
        left: 4.px,
        top: 4.px,
        right: 12.px,
        bottom: 4.px,
      ),
      spacingPx: 8,
      borderRadius: context.borderRadiusFull,
      showShadow: true,
      semanticsLabel: onTap == null ? semanticsLabel : null,
    );

    if (onTap == null) return pill;

    return GtTapTarget(
      child: GtInkWell(
        role: .button,
        borderRadius: context.borderRadiusFull,
        onTap: onTap,
        semanticsLabel: semanticsLabel,
        excludeDescendantSemantics: semanticsLabel != null,
        child: pill,
      ),
    );
  }
}

/// A private skeleton of [GtProfileHeader], laid out with placeholder data
/// under its own [GtSkeleton].
class _GtProfileHeaderSkeleton extends GtProfileHeader {
  /// Creates a [_GtProfileHeaderSkeleton].
  const _GtProfileHeaderSkeleton({super.key})
    : super(title: 'Profile name', subtitle: 'name@example.com • Active');

  @override
  Widget build(BuildContext context) {
    return GtSkeleton(
      child: Builder(builder: (context) => super.build(context)),
    );
  }
}

/// A private skeleton of [GtProfileHeroHeader], laid out with placeholder data
/// under its own [GtSkeleton].
class _GtProfileHeroHeaderSkeleton extends GtProfileHeroHeader {
  /// Creates a [_GtProfileHeroHeaderSkeleton].
  const _GtProfileHeroHeaderSkeleton({super.key})
    : super(name: 'Profile name', accountName: 'Account name');

  @override
  Widget build(BuildContext context) {
    return GtSkeleton(
      child: Builder(builder: (context) => super.build(context)),
    );
  }
}
