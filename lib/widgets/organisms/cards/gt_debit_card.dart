import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// Debit-card selection card with top text content and a bottom-stacked image.
///
/// Layout structure:
/// - Foreground row (title/subtitle + trailing chevron).
/// - Decorative/preview image pinned to the bottom-right.
class GtDebitCard extends GtStatelessWidget {
  /// Main card title.
  final String title;

  /// Optional supporting subtitle below the title.
  final String? subtitle;

  /// Card preview/illustration displayed at the bottom-right of the container.
  final AppImageData? image;

  /// Tap callback for the whole card.
  final OnPressed? onPressed;

  /// Optional custom background color.
  ///
  /// Defaults to [GtPaletteBgColors.weak].
  final Color? backgroundColor;

  /// Optional fee badge text (e.g. "N1000" or "FREE").
  final String? feeLabel;

  /// Creates a [GtDebitCard].
  const GtDebitCard({
    super.key,
    required this.title,
    this.subtitle,
    this.image,
    this.onPressed,
    this.backgroundColor,
    this.feeLabel,
  });

  /// Button style token for the card title.
  TextStyle _titleStyle(BuildContext context) {
    return context.textStyles.button(color: context.palette.text.strong);
  }

  /// Body 2XS style token for the optional subtitle.
  TextStyle _subtitleStyle(BuildContext context) {
    return context.textStyles
        .body2Xs(color: GtColors.neutral400.value)
        .copyWith(height: 1.45);
  }

  /// White label text shown inside the fee badge.
  TextStyle _feeLabelStyle(BuildContext context) {
    return context.textStyles.buttonXs(color: context.palette.text.white);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.palette.bg.weak;
    final radius = context.borderRadius2Xl;
    final borderRadius = BorderRadius.only(
      topLeft: radius.topLeft,
      topRight: radius.topRight,
      bottomLeft: radius.bottomLeft,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: bgColor,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: BoxConstraints(minHeight: context.dp(190.px)),
            child: Stack(
              children: [
                Padding(
                  padding: context.insets.allDp(16.px),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .start,
                              children: [
                                GtText(
                                  title.upper,
                                  style: _titleStyle(context),
                                ),
                                if (subtitle.hasValue) ...[
                                  GtGap.yXs(),
                                  GtText(
                                    subtitle.value.capitalise(true),
                                    style: _subtitleStyle(context),
                                  ),
                                ],
                                GtGap.yMd(),
                                Container(
                                  padding: context.insets.symmetricDp(
                                    horizontal: 5.px,
                                    vertical: 3.px,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.palette.bg.strong,
                                    borderRadius: BorderRadius.circular(
                                      context.dp(5.px),
                                    ),
                                  ),
                                  child: GtText(
                                    feeLabel!,
                                    style: _feeLabelStyle(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GtGap.hBase(),
                          GtIcon(
                            GtIcons.chevronRight,
                            variant: .soft,
                            size: context.dp(15.px),
                            alignment: Alignment.topRight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (image != null)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GtImage(
                      image: image,
                      width: context.dp(132.px),
                      height: context.dp(98.px),
                      fit: BoxFit.contain,
                      useDefaultSize: false,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
