import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// The standard help action button used across app bars and screens.
///
/// Renders a small [GtRaisedButton] with a predefined spark icon and localized "HELP" label.
class GtHelpButton extends GtStatelessWidget {
  /// Creates a [GtHelpButton].
  const GtHelpButton({
    super.key,
    required this.onPressed,
    this.variant = .secondary,
    this.backgroundColor,
    this.textColor,
  });

  /// Callback invoked when the button is tapped.
  final OnPressed onPressed;

  /// The visual style variant of the button.
  ///
  /// Defaults to [GtButtonVariant.secondary].
  final GtButtonVariant variant;

  /// An optional background color to override the default color.
  final Color? backgroundColor;

  /// An optional custom text color to override the default text color.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GtRaisedButton(
      text: "help".utr(),
      leading: GtIcons.spark,
      size: .small,
      onPressed: onPressed,
      variant: variant,
      color: backgroundColor,
      textColor: textColor,
      cornerRadius: context.borderRadiusMd,
    );
  }
}

/// An interactive pill button used for account or profile switching.
///
/// Displays the account [text] in uppercase followed by a chevron down icon,
/// providing visual feedback on tap via [GtInkWell].
class GtAccountSwitchButton extends GtStatelessWidget {
  /// Creates a [GtAccountSwitchButton].
  const GtAccountSwitchButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.alignment,
  });

  /// The account name, number, or identifier label displayed on the button.
  final String text;

  /// Callback invoked when the button is tapped.
  final OnPressed onPressed;

  /// An optional background color to override the default container color.
  final Color? backgroundColor;

  /// An optional custom text and chevron icon color to override the default text color.
  final Color? textColor;

  /// An optional alignment for the button's content.
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final bgColor = context.palette.primary.dark;
    final txtColor = context.palette.text.white;

    Widget child = GtInkWell(
      role: .button,
      onTap: onPressed,
      child: GtTapTarget(
        child: Container(
          padding: context.insets.symmetricDp(horizontal: 8.px, vertical: 4.px),
          decoration: BoxDecoration(
            color: backgroundColor ?? bgColor,
            borderRadius: context.borderRadiusSm,
          ),
          child: Text.rich(
            TextSpan(
              text: text.upper,
              children: [
                const WidgetSpan(child: GtGap.hBase()),
                WidgetSpan(
                  alignment: .middle,
                  child: GtIcon.withColor(
                    GtIcons.chevronDown,
                    size: context.dp(10.px),
                    color: textColor ?? txtColor,
                  ),
                ),
              ],
            ),
            style: context.textStyles.button2s(color: textColor ?? txtColor),
            textAlign: .center,
          ),
        ),
      ),
    );

    if (alignment case AlignmentGeometry alignment) {
      child = Align(alignment: alignment, child: child);
    }

    return child;
  }
}
