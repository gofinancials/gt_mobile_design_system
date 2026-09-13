import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget used to display an overview of an inbox or message thread.
///
/// This card displays an icon, the [title], and [subtitle] of the message,
/// along with the total [messageCount] and a visual badge for the [ureadCount]
/// (unread messages).
class GtInboxCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

  /// Overrides message count style. Null preserves the current default.
  final TextStyle? messageCountStyle;

  /// Overrides message count color. Null preserves the current default.
  final Color? messageCountColor;

  /// Overrides icon color. Null preserves the current default.
  final Color? iconColor;

  /// Overrides horizontal spacing in logical pixels. Null preserves the current default.
  final double? horizontalSpacing;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides content padding. Null preserves the current default.
  final EdgeInsetsGeometry? contentPadding;

  /// Overrides unread background color. Null preserves the current default.
  final Color? unreadBackgroundColor;

  /// Overrides unread text color. Null preserves the current default.
  final Color? unreadTextColor;

  /// Overrides unread text style. Null preserves the current default.
  final TextStyle? unreadTextStyle;

  /// The primary title of the inbox item.
  final String title;

  /// The subtitle or preview text of the inbox item.
  final String subtitle;

  /// The number of unread messages.
  ///
  /// If greater than 0, a [GtCountIndicator] badge will be displayed.
  final int ureadCount;

  /// The total number of messages in the thread to display at the trailing edge.
  final int messageCount;

  /// The callback triggered when the card is tapped.
  final OnPressed? onTap;

  /// Creates a [GtInboxCard].
  const GtInboxCard({
    required this.title,
    required this.subtitle,
    required this.ureadCount,
    required this.messageCount,
    this.onTap,
    super.key,
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
    this.messageCountStyle,
    this.messageCountColor,
    this.iconColor,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.contentPadding,
    this.unreadBackgroundColor,
    this.unreadTextColor,
    this.unreadTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final subStyle = context.textStyles.bodyXs(
      color: context.palette.text.soft,
    );
    return GtInkWell(
      role: .button,
      borderRadius: context.borderRadiusXl,
      onTap: onTap,
      child: GtCard(
        color: backgroundColor,
        padding:
            padding ??
            context.insets.symmetricDp(horizontal: 8.px, vertical: 16.px),
        borderRadius: context.borderRadiusXl,
        child: GtBaseListTileTemplate(
          spacingToSubTitle: verticalSpacing,
          padding: contentPadding,
          title: GtText(
            title,
            style: GtTextStyleOverrides.resolve(
              titleStyle,
              context.textStyles.bodyM(),
              titleColor,
            ),
          ),
          spacing: horizontalSpacing ?? context.spacingMd,
          subtitle: GtText(
            subtitle,
            style: GtTextStyleOverrides.resolve(
              subtitleStyle,
              subStyle,
              subtitleColor,
            ),
          ),
          trailing: GtSquareConstrainedBox(
            25,
            child: Center(
              child: GtText(
                "$messageCount",
                style: GtTextStyleOverrides.resolve(
                  messageCountStyle,
                  subStyle,
                  messageCountColor,
                ),
              ),
            ),
          ),
          leading: GtSquareConstrainedBox(
            36,
            child: Stack(
              alignment: .center,
              children: [
                Positioned.fill(
                  child: GtIcon.withColor(
                    GtIcons.messages,
                    color: iconColor ?? context.palette.primary.base,
                    size: 24,
                  ),
                ),
                if (ureadCount > 0)
                  Positioned(
                    top: 0,
                    right: -context.dp(4.px),
                    child: Transform.scale(
                      scale: .6,
                      child: GtCountIndicator(
                        ureadCount,
                        backgroundColor: unreadBackgroundColor,
                        textColor: unreadTextColor,
                        style: unreadTextStyle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
