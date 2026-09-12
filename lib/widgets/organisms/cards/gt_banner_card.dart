import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card for displaying prominent banners with a title, subtitle, and a close button.
class GtBannerCard extends GtStatefulWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

  /// Overrides close button spacing in logical pixels. Null preserves the current default.
  final double? closeButtonSpacing;

  /// Overrides title style. Null preserves the current default.
  final TextStyle? titleStyle;

  /// Overrides title color. Null preserves the current default.
  final Color? titleColor;

  /// Overrides subtitle style. Null preserves the current default.
  final TextStyle? subtitleStyle;

  /// Overrides subtitle color. Null preserves the current default.
  final Color? subtitleColor;

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
    this.backgroundColor,
    this.padding,
    this.verticalSpacing,
    this.closeButtonSpacing,
    this.titleStyle,
    this.titleColor,
    this.subtitleStyle,
    this.subtitleColor,
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
        padding: widget.padding ?? context.insets.allDp(16.px),
        variant: widget.variant,
        color: widget.backgroundColor,
        child: Column(
          spacing: widget.verticalSpacing ?? context.spacingBase,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: widget.closeButtonSpacing ?? context.spacingSectionLg,
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: GtText(
                    widget.title,
                    style: GtTextStyleOverrides.resolve(
                      widget.titleStyle,
                      context.textStyles.h6(color: textColor),
                      widget.titleColor,
                    ),
                  ),
                ),
                GtCancelButton(onTap: widget.onClose),
              ],
            ),
            GtText(
              widget.subtitle,
              style: GtTextStyleOverrides.resolve(
                widget.subtitleStyle,
                context.textStyles.bodyXs(
                  color: context.palette.text.darkerSub,
                ),
                widget.subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
