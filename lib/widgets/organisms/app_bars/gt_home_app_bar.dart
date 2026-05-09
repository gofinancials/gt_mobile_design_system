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
  final OnPressed onClickSearch;

  /// Callback triggered when the hide/visibility icon is pressed.
  final OnPressed onClickHide;

  /// Callback triggered when the notification icon is pressed.
  final OnPressed? onClickNotification;

  /// Creates a [GtHomeAppBar].
  const GtHomeAppBar({
    this.avatar,
    required this.onClickSearch,
    required this.onClickHide,
    this.onClickNotification,
    this.userFullName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final btnColor = switch (context.isIos) {
      true => context.palette.primary.alpha16,
      _ => Colors.transparent,
    };
    GtIconButtonShape btnShape = switch (context.isIos) {
      true => .round,
      _ => .square,
    };
    final gradient = switch (context.isIos) {
      true => null,
      _ => context.gradients.ghostGradient,
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
              gradient: context.gradients.appbarAvatarGradient,
              initialsColor: context.palette.text.white,
            ),
            const Spacer(),
            GtIconButton(
              icon: GtIcons.magnifier,
              onPressed: onClickSearch,
              shape: btnShape,
              color: btnColor,
              variant: .neutral,
              size: .medium,
              gradient: gradient,
            ),
            GtIconButton(
              icon: GtIcons.hide,
              onPressed: onClickHide,
              shape: btnShape,
              color: btnColor,
              variant: .neutral,
              gradient: gradient,
              size: .medium,
            ),
            if (onClickNotification != null)
              GtIconButton(
                icon: GtIcons.bell,
                onPressed: onClickNotification!,
                shape: btnShape,
                color: btnColor,
                variant: .neutral,
                gradient: gradient,
                size: .medium,
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
