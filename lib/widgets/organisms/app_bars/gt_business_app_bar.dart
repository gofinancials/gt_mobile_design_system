import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:gt_mobile_ui/widgets/molecules/media/gt_avatar.dart';

/// A specialized app bar for the home screen featuring a user avatar and quick action icons.
class GtProAppBar extends GtStatelessWidget implements PreferredSizeWidget {
  /// Optional avatar image data for the current user.
  final AppImageData? avatar;

  /// The full name of the user, used to generate initials if [avatar] is absent.
  final String fullName;

  /// The name of the users business.
  final String businessName;

  /// Callback triggered when the hide/visibility icon is pressed.
  final OnPressed onClickStat;

  /// Callback triggered when the notification icon is pressed.
  final OnPressed onClickNotification;

  /// Flags the business as verified or not to show the verified badge
  final bool verified;

  /// Creates a [GtProAppBar].
  const GtProAppBar({
    this.avatar,
    required this.onClickStat,
    required this.onClickNotification,
    required this.fullName,
    required this.businessName,
    this.verified = false,
    super.key,
  });

  String get _firstName {
    if (!fullName.hasValue) return "User";
    final names = fullName.split(" ");
    return names.first.hasValue ? names.first : "User";
  }

  @override
  Widget build(BuildContext context) {
    final toolbarHeight = MediaQuery.paddingOf(context).top;
    final btnColor = Colors.transparent;

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
              initials: AppHelpers.getInitials(fullName),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                spacing: context.spacingXs,
                children: [
                  GtText(
                    "$_firstName,".upper,
                    style: context.textStyles.h6(),
                    maxLines: 1,
                  ),
                  if (businessName.hasValue)
                    Text.rich(
                      TextSpan(
                        text: businessName.upper,
                        children: [
                          if (verified)
                            WidgetSpan(
                              child: GtIcon.withColor(
                                GtIcons.star,
                                size: 10,
                                color: context.palette.information.base,
                              ),
                            ),
                        ],
                        style: context.textStyles.buttonXs(
                          color: context.palette.text.soft,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            GtIconButton(
              icon: GtIcons.chartBarTrendUp,
              onPressed: onClickStat,
              shape: .square,
              color: btnColor,
              variant: .stable,
              gradient: context.gradients.ghostGradient,
              size: .medium,
            ),
            GtIconButton(
              icon: GtIcons.bell,
              onPressed: onClickNotification,
              shape: .square,
              color: btnColor,
              variant: .stable,
              gradient: context.gradients.ghostGradient,
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
