import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized app bar for the home screen featuring a user avatar and quick action icons.
class GtHomeAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  /// Optional avatar image data for the current user.
  final AppImageData? avatar;

  /// The full name of the user, used to generate initials if [avatar] is absent.
  final String? userFullName;

  /// Callback triggered when the search icon is pressed.
  final OnPressed? onClickSearch;

  /// Callback triggered when the hide/visibility icon is pressed.
  final OnPressed? onClickHide;

  /// Callback triggered when the notification icon is pressed.
  final OnPressed? onClickNotification;

  /// Callback triggered when the messages icon is pressed.
  final OnPressed? onClickHelp;

  /// Callback triggered when the account toggle button is pressed.
  final OnPressed? onToggleAccounts;

  /// Callback triggered when the avatar is pressed.
  final OnPressed? onClickAvatar;

  /// The label shown on the account toggle button.
  ///
  /// Required whenever [onToggleAccounts] is supplied — the two together form
  /// the account switcher, and the button would otherwise render unlabelled.
  final String? toggleAccountText;

  /// Creates a [GtHomeAppBar].
  ///
  /// [toggleAccountText] must be supplied whenever [onToggleAccounts] is; this
  /// is asserted in debug builds.
  const GtHomeAppBar({
    this.avatar,
    this.onClickSearch,
    this.onClickHide,
    this.onClickNotification,
    this.userFullName,
    this.onClickAvatar,
    this.onClickHelp,
    this.onToggleAccounts,
    this.toggleAccountText,
    super.key,
  }) : assert(
         onToggleAccounts == null || toggleAccountText != null,
         'GtHomeAppBar.toggleAccountText must be provided when '
         'onToggleAccounts is set, otherwise the account toggle renders '
         'without a label.',
       );

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final btnColor = context.palette.primary.alpha16;
    final avatarColor = context.palette.primary.dark;
    final iconColor = switch (context.isInDarkMode) {
      true => context.palette.primary.base,
      _ => context.palette.primary.darker,
    };

    return Material(
      type: .transparency,
      child: Container(
        padding: (context.insets.defaultHorizontalInsets).add(
          EdgeInsets.only(top: toolbarHeight),
        ),
        color: Colors.transparent,
        child: Row(
          spacing: context.spacingBase,
          children: [
            GtAvatar(
              avatar: avatar,
              alignment: .centerLeft,
              initials: AppHelpers.getInitials(userFullName),
              bgColor: avatarColor,
              initialsColor: context.palette.text.white,
              forceGradiant: false,
              onPressed: onClickAvatar,
              size: context.dp(42.px),
            ),
            const Spacer(),
            if (onClickHelp != null)
              GtIconButton(
                icon: GtIcons.messages,
                iconColor: iconColor,
                onPressed: onClickHelp!,
                shape: .round,
                color: btnColor,
                variant: .neutral,
                size: .medium,
              ),
            if (onClickSearch != null)
              GtIconButton(
                icon: GtIcons.magnifier,
                iconColor: iconColor,
                onPressed: onClickSearch!,
                shape: .round,
                color: btnColor,
                variant: .neutral,
                size: .medium,
              ),
            if (onClickHide != null)
              GtIconButton(
                icon: GtIcons.hide,
                iconColor: iconColor,
                onPressed: onClickHide!,
                shape: .round,
                color: btnColor,
                variant: .neutral,
                size: .medium,
              ),
            if (onClickNotification != null)
              GtIconButton(
                icon: GtIcons.bell,
                iconColor: iconColor,
                onPressed: onClickNotification!,
                shape: .round,
                color: btnColor,
                variant: .neutral,
                size: .medium,
              ),
            if (onToggleAccounts != null)
              GtRaisedButton(
                text: toggleAccountText,
                trailing: GtIcons.chevronDownOutline,
                onPressed: onToggleAccounts!,
                cornerRadius: context.borderRadiusFull,
                color: btnColor,
                textColor: iconColor,
                variant: .neutral,
                size: .medium,
                textCase: .title,
                style: context.textStyles.subHeadS(
                  color: iconColor,
                  weight: .w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}
