import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A simple card for displaying a physical address.
class GtAddressCard extends GtStatelessWidget {
  /// Overrides background color. Null preserves the current default.
  final Color? backgroundColor;

  /// Overrides padding. Null preserves the current default.
  final EdgeInsetsGeometry? padding;

  /// Overrides the existing border colour without changing [borderStyle].
  final Color? borderColor;

  /// Overrides line1 color. Null preserves the current default.
  final Color? line1Color;

  /// Overrides line2 color. Null preserves the current default.
  final Color? line2Color;

  /// Overrides vertical spacing in logical pixels. Null preserves the current default.
  final double? verticalSpacing;

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
    this.backgroundColor,
    this.padding,
    this.borderColor,
    this.line1Color,
    this.line2Color,
    this.verticalSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderColor = variant.getBorderColor(palette);

    return GtCard(
      color: backgroundColor,
      padding: padding ?? context.insets.allDp(16.px),
      variant: variant,
      onPressed: onPressed,
      border: BorderSide(
        color: this.borderColor ?? borderColor,
        style: borderStyle,
      ),
      child: Column(
        spacing: verticalSpacing ?? context.spacingSm,
        crossAxisAlignment: .stretch,
        children: [
          GtText(
            line1,
            style: GtTextStyleOverrides.resolve(
              line1Style,
              context.textStyles.bodyM(),
              line1Color,
            ),
          ),
          GtText(
            line2,
            style: GtTextStyleOverrides.resolve(
              line2Style,
              context.textStyles.bodyS(),
              line2Color,
            ),
          ),
        ],
      ),
    );
  }
}
