import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A banner for reminders that includes a call-to-action button.
class GtReminderBanner extends GtStatelessWidget {
  /// The main title of the reminder banner.
  final String title;

  /// The secondary text or subtitle of the reminder banner.
  final String subtitle;

  /// The icon to display in the banner.
  final Widget icon;

  /// If true, the banner will be hidden (faded out).
  final bool hidden;

  /// The text to display on the action button.
  final String actionText;

  /// A callback function that is invoked when the action button is tapped.
  final OnPressed onActionTap;

  /// The visual variant of the card, which determines its background color.
  final GtCardVariant variant;

  /// The visual variant of the button.
  final GtButtonVariant buttonVariant;

  /// A callback function that is invoked when the close button is tapped.
  final OnPressed onClose;

  /// Creates a [GtReminderBanner].
  const GtReminderBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .away,
    this.buttonVariant = .primary,
    required this.icon,
    required this.onClose,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bgColor = variant.getBorderColor(palette);

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtCard(
        padding: context.insets.allDp(12.px),
        color: bgColor,
        child: Row(
          crossAxisAlignment: .start,
          spacing: context.spacingBase,
          children: [
            GtSquareConstrainedBox(48, child: icon),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  GtText(title.upper, style: context.textStyles.h7()),
                  const GtGap.ySm(),
                  GtText(subtitle, style: context.textStyles.subHeadS()),
                  const GtGap.yBase(),
                  GtRaisedButton(
                    onPressed: onActionTap,
                    text: actionText,
                    variant: buttonVariant,
                    size: .small,
                  ),
                ],
              ),
            ),
            const GtGap.hBase(),
            GtCancelButton(onTap: onClose, size: .small, alignment: .topRight),
          ],
        ),
      ),
    );
  }
}
