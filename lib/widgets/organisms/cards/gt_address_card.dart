import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A simple card for displaying a physical address.
class GtAddressCard extends GtStatelessWidget {
  /// The first line of the address.
  final String line1;

  /// The second line of the address (e.g., city, state, zip).
  final String line2;

  /// The visual variant of the card, which determines its background and border colors.
  final GtCardVariant variant;

  /// Creates a [GtAddressCard].
  const GtAddressCard({
    super.key,
    required this.line1,
    required this.line2,
    this.variant = .normal,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);

    return GtCard(
      padding: context.insets.allDp(16.px),
      border: BorderSide(color: borderColor),
      variant: variant,
      child: Column(
        spacing: context.spacingSm,
        crossAxisAlignment: .stretch,
        children: [
          GtText(line1, style: context.textStyles.bodyM()),
          GtText(line2),
        ],
      ),
    );
  }
}