import 'package:flutter/gestures.dart';
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

/// A **stacked icon action button**: a square, tappable icon tile with an
/// optional caption underneath.
///
/// Used for quick-action strips — the row of "Send", "Top up" or "Pay bills"
/// affordances on a dashboard or account screen.
///
/// The icon sits inside a square tile of [size] (defaulting to 44dp, the
/// platform minimum interactive dimension), inset by [padding] and scaled down
/// to fit whenever [iconSize] and [padding] together exceed that box. The whole
/// button is wrapped in a [GtTapTarget], so the touch-responsive area never
/// falls below [GtTapTarget.defaultMinSize] even on screens where the tile
/// itself scales down.
class GtActionButton extends GtStatelessWidget {
  /// The platform-recommended minimum interactive dimension, in logical pixels.
  ///
  /// Matches the width of [GtTapTarget.defaultMinSize] and is the floor
  /// enforced on [size].
  static const double minTapTargetSize = 44;

  /// Creates a [GtActionButton].
  ///
  /// [size] must be at least [minTapTargetSize], and [iconSize] must not exceed
  /// the tile it is drawn in. Both are asserted in debug builds.
  const GtActionButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    this.label,
    this.size,
    this.iconSize,
    this.padding,
    this.iconColor,
    this.labelStyle,
  }) : assert(
         size == null || size >= minTapTargetSize,
         'GtActionButton.size must be at least $minTapTargetSize logical '
         'pixels to remain a valid tap target.',
       ),
       assert(
         iconSize == null || iconSize <= (size ?? minTapTargetSize),
         'GtActionButton.iconSize must not exceed size (or '
         '$minTapTargetSize when size is null); the icon would otherwise be '
         'scaled down to fit its tile.',
       );

  /// Callback invoked when the button is tapped.
  final OnPressed onPressed;

  /// The background color intended for the icon tile.
  ///
  /// *Note: This property is declared but currently unused in the standard
  /// build method — the tile paints no decoration, so the icon renders on a
  /// transparent background.*
  final Color backgroundColor;

  /// An optional caption rendered beneath the icon tile.
  ///
  /// When `null`, the button is the icon tile alone.
  final String? label;

  /// The icon displayed inside the tile.
  final IconData icon;

  /// An optional color to override the default icon color.
  ///
  /// Defaults to [GtPalette.staticColors.white].
  final Color? iconColor;

  /// The rendered size of [icon] in logical pixels.
  ///
  /// Defaults to 24dp. Must not be larger than [size]; see [minTapTargetSize].
  final double? iconSize;

  /// The width and height of the square icon tile, in logical pixels.
  ///
  /// Defaults to 44dp and must not be smaller than [minTapTargetSize].
  final double? size;

  /// The inset between the tile’s edge and [icon].
  ///
  /// Defaults to 10dp on every side.
  final EdgeInsetsGeometry? padding;

  /// An optional text style to override the default [label] style.
  ///
  /// Defaults to [GtTextStyles.subHeadXs].
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return GtTapTarget(
      child: GtInkWell(
        role: .button,
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          spacing: context.spacingBase,
          children: [
            AnimatedContainer(
              width: size ?? context.dp(44.px),
              height: size ?? context.dp(44.px),
              padding: padding ?? context.insets.allDp(10.px),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: .circle
              ),
              duration: GtMotion.adaptiveDuration(context, 500.milliseconds),
              curve: Curves.decelerate,
              child: FittedBox(
                fit: .scaleDown,
                child: GtIcon.withColor(
                  icon,
                  size: iconSize ?? context.dp(24.px),
                  color: iconColor ?? context.palette.staticColors.white,
                ),
              ),
            ),
            if (label case String label)
              GtText(
                label,
                style: labelStyle ?? context.textStyles.subHeadXs(),
                textAlign: .center,
              ),
          ],
        ),
      ),
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
    final txtColor = context.palette.staticColors.white;

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
          child: Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            spacing: context.spacingBase,
            children: [
              GtText(
                text.upper,
                style: context.textStyles.button2s(
                  color: textColor ?? txtColor,
                ),
                textAlign: .center,
              ),
              GtIcon.withColor(
                GtIcons.chevronDownOutline,
                size: context.dp(16.px),
                color: textColor ?? txtColor,
              ),
            ],
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

/// An interactive text button combining a question or prompt with a clickable action.
///
/// Commonly used for navigation and authentication prompts (e.g., "Don't have an account? Sign up"),
/// rendering the prompt with a subtle text style and the action with prominent styling.
class GtQuestionTextButton extends GtStatelessWidget {
  /// Creates a [GtQuestionTextButton].
  const GtQuestionTextButton(
    this.question, {
    super.key,
    required this.action,
    required this.onPressed,
    this.questionStyle,
    this.actionStyle,
    this.textAlign,
  });

  /// The question or prompt text displayed before the action.
  final String question;

  /// The action text displayed after the question.
  final String action;

  /// Callback invoked when the button or action text is tapped.
  final OnPressed onPressed;

  /// An optional text style to override the default question style.
  final TextStyle? questionStyle;

  /// An optional text style to override the default action style.
  final TextStyle? actionStyle;

  /// An optional alignment for the button's content.
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final questionColor = context.palette.text.darkerSub;
    final defaultStyle = context.textStyles.subHeadS();
    final defaultQuesStyle = defaultStyle.copyWith(color: questionColor);

    return GtInkWell(
      role: .button,
      onTap: onPressed,
      child: GtTapTarget(
        child: Text.rich(
          TextSpan(
            text: question,
            children: [
              TextSpan(text: " $action", style: actionStyle ?? defaultStyle),
            ],
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            style: questionStyle ?? defaultQuesStyle,
          ),
          textAlign: textAlign ?? .center,
        ),
      ),
    );
  }
}
