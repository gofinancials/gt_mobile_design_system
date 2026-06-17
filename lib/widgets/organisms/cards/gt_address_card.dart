import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A simple card for displaying a physical address.
class GtAddressCard extends GtStatelessWidget {
  /// The first line of the address.
  final String line1;

  /// The text style to apply to [line1].
  ///
  /// If null, defaults to the body medium text style from the theme.
  final TextStyle? line1Style;

  /// The second line of the address (e.g., city, state, zip).
  final String line2;

  /// The text style to apply to [line2].
  ///
  /// If null, defaults to the standard text style.
  final TextStyle? line2Style;

  /// The visual variant of the card, which determines its background and border colors.
  final GtCardVariant variant;

  /// The style of the border drawn around the card.
  ///
  /// Defaults to [BorderStyle.solid].
  final BorderStyle borderStyle;

  /// Callback invoked when the user taps on the card.
  ///
  /// If null, the card will not be interactive.
  final OnPressed? onPressed;

  /// Creates a [GtAddressCard].
  const GtAddressCard({
    super.key,
    required this.line1,
    required this.line2,
    this.onPressed,
    this.line1Style,
    this.line2Style,
    this.variant = .normal,
    this.borderStyle = .solid,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);

    return GtCard(
      padding: context.insets.allDp(16.px),
      variant: variant,
      onPressed: onPressed,
      border: BorderSide(color: borderColor, style: borderStyle),
      child: Column(
        spacing: context.spacingSm,
        crossAxisAlignment: .stretch,
        children: [
          GtText(line1, style: line1Style ?? context.textStyles.bodyM()),
          GtText(line2, style: line2Style),
        ],
      ),
    );
  }
}
