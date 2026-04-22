import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A banner for alerts, with a title, subtitle, icon, and close button.
class GtAlertBanner extends GtStatelessWidget {
  /// The main title of the alert banner.
  final String title;

  /// The secondary text or subtitle of the alert banner.
  final String subtitle;

  /// The icon to display in the banner.
  final Widget icon;

  /// If true, the banner will be hidden (faded out).
  final bool hidden;

  /// The visual variant of the card, which determines its background color.
  final GtCardVariant variant;

  /// A callback function that is invoked when the close button is tapped.
  final OnPressed onClose;

  /// Creates a [GtAlertBanner].
  const GtAlertBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .away,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bgColor = variant.getIconColor(palette);

    return GtAnimatedFade(
      showFirst: !hidden,
      child2: const Offstage(),
      child1: GtCard(
        padding: context.insets.allDp(12.px),
        color: bgColor,
        child: Column(
          spacing: context.spacingSm,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: context.spacingBase,
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              children: [
                GtSquareConstrainedBox(84, child: icon),
                GtCancelButton(onTap: onClose, size: 20, alignment: .topRight),
              ],
            ),
            GtText(title.upper, style: context.textStyles.buttonS()),
            GtText(subtitle, style: context.textStyles.subHeadS()),
          ],
        ),
      ),
    );
  }
}
