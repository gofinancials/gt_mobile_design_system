import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying prominent banners with a title, subtitle, and a close button.
class GtBannerCard extends GtStatefulWidget {
  /// The main title of the banner.
  final String title;

  /// The secondary text or subtitle of the banner.
  final String subtitle;

  /// If true, the banner will be hidden (faded out).
  final bool hidden;

  /// The visual variant of the card, which determines its background color and text color.
  final GtCardVariant variant;

  /// A callback function that is invoked when the close button is tapped.
  final OnPressed onClose;

  /// Creates a [GtBannerCard].
  const GtBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.hidden = false,
    this.variant = .normal,
    required this.onClose,
  });

  @override
  State<StatefulWidget> createState() => _GtBannerCardState();
}

class _GtBannerCardState extends State<GtBannerCard> {
  @override
  Widget build(BuildContext context) {
    final textColor = widget.variant.getTextColor(context.palette);

    return GtAnimatedFade(
      showFirst: !widget.hidden,
      child2: const Offstage(),
      child1: GtCard(
        borderRadius: context.borderRadiusXl,
        padding: context.insets.allDp(16.px),
        variant: widget.variant,
        child: Column(
          spacing: context.spacingBase,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: context.spacingSectionLg,
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: GtText(
                    widget.title,
                    style: context.textStyles.h6(color: textColor),
                  ),
                ),
                GtCancelButton(onTap: widget.onClose),
              ],
            ),
            GtText(
              widget.subtitle,
              style: context.textStyles.bodyXs(
                color: context.palette.text.darkerSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
