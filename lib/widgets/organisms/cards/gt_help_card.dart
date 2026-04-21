import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A card that links to a help or support section, often with a message icon.
class GtHelpCard extends GtStatelessWidget {
  /// The main title text of the help card.
  final String title;

  /// Optional subtitle text displayed below the title.
  final String? subtitle;

  /// The visual variant of the card, which determines its background and icon colors.
  final GtCardVariant variant;

  /// An optional callback function that is invoked when the card is tapped.
  final OnPressed? onTap;

  /// Creates a [GtHelpCard].
  const GtHelpCard({
    super.key,
    required this.title,
    this.subtitle,
    this.variant = .normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconColor = switch (variant) {
      .error => palette.text.strong,
      _ => variant.getIconColor(palette),
    };
    Widget? footer;

    if (subtitle.hasValue) {
      footer = GtText(
        subtitle,
        style: context.textStyles.bodyXs(color: palette.text.soft),
      );
    }

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: GtCard(
        padding: context.insets.allDp(12.px),
        borderRadius: context.borderRadiusXl,
        variant: variant,
        child: GtBaseListTileTemplate(
          padding: context.insets.zero,
          spacing: context.spacingLg,
          spacingToSubTitle: 0,
          subtitle: footer,
          crossAxisAlignment: .center,
          title: GtText(title, style: context.textStyles.bodyM()),
          leading: GtIcon.withColor(
            GtIcons.messages,
            size: 24,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
