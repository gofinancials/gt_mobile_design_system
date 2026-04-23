import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card widget used to display an overview of an inbox or message thread.
///
/// This card displays an icon, the [title], and [subtitle] of the message,
/// along with the total [messageCount] and a visual badge for the [ureadCount]
/// (unread messages).
class GtInboxCard extends GtStatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final subStyle = context.textStyles.bodyXs(
      color: context.palette.text.soft,
    );
    return InkWell(
      onTap: () {
        if (onTap == null) return;
        onTap?.call();
        HapticFeedback.lightImpact();
      },
      child: GtCard(
        padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 16.px),
        borderRadius: context.borderRadiusXl,
        child: GtBaseListTileTemplate(
          title: GtText(title, style: context.textStyles.bodyM()),
          spacing: context.spacingMd,
          subtitle: GtText(subtitle, style: subStyle),
          trailing: GtSquareConstrainedBox(
            25,
            child: Center(child: GtText("$messageCount", style: subStyle)),
          ),
          leading: GtSquareConstrainedBox(
            36,
            child: Stack(
              alignment: .center,
              children: [
                Positioned.fill(
                  child: GtIcon.withColor(
                    GtIcons.messages,
                    color: context.palette.primary.base,
                    size: 24,
                  ),
                ),
                if (ureadCount > 0)
                  Positioned(
                    top: 0,
                    right: -context.dp(4.px),
                    child: Transform.scale(
                      scale: .6,
                      child: GtCountIndicator(ureadCount),
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
