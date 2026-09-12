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

/// A **stacked action button**: a tappable circular tile with an optional
/// caption underneath.
///
/// Used for quick-action strips — the row of "Send", "Top up" or "Pay bills"
/// affordances on a dashboard or account screen.
///
/// The tile is filled with [backgroundColor] and carries either:
/// - a centered icon, tinted with [iconColor] and sized by [iconSize] — see
///   [GtActionButton.new]; or
/// - an image painted across the whole circle, such as a merchant logo or a
///   beneficiary avatar — see [GtActionButton.image].
///
/// The tile is square-constrained to [size] (defaulting to 44dp, the platform
/// minimum interactive dimension) and inset by [padding]; an icon larger than
/// the space left over is scaled down rather than clipped. The whole button is
/// wrapped in a [GtTapTarget], so the touch-responsive area never falls below
/// [GtTapTarget.defaultMinSize] even on screens where the tile itself scales
/// down. [label] is clipped to a single line with an ellipsis, so keep captions
/// to one or two words.
class GtActionButton extends GtStatelessWidget {
  /// The platform-recommended minimum interactive dimension, in logical pixels.
  ///
  /// Matches the width of [GtTapTarget.defaultMinSize] and is the floor
  /// enforced on [size].
  static const double minTapTargetSize = 44;

  /// Creates a [GtActionButton] that displays [icon] on a [backgroundColor]
  /// circle.
  ///
  /// [size] must be at least [minTapTargetSize], and [iconSize] must not exceed
  /// the tile it is drawn in. Both are asserted in debug builds.
  const GtActionButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required IconData icon,
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
       ),
       _icon = icon,
       _image = null;

  /// Creates a [GtActionButton] that paints [image] across the tile instead of
  /// an icon — for a merchant logo, beneficiary avatar or similar artwork.
  ///
  /// [backgroundColor] shows through wherever the image does not cover the
  /// circle, so it doubles as the placeholder while the image loads. Give the
  /// [DecorationImage] a `fit` of [BoxFit.cover] to fill the tile.
  ///
  /// [iconColor] and [iconSize] have no effect on this variant, though
  /// [iconSize] is still asserted against [size].
  const GtActionButton.image({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required DecorationImage image,
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
       ),
       _icon = null,
       _image = image;

  /// Callback invoked when the button is tapped.
  final OnPressed onPressed;

  /// The fill color of the circular tile.
  ///
  /// For [GtActionButton.image] this shows behind the artwork, standing in
  /// while the image loads and filling any area it does not cover.
  final Color backgroundColor;

  /// An optional caption rendered beneath the tile.
  ///
  /// Limited to a single line and ellipsized when it overflows, so prefer one
  /// or two words. When `null`, the button is the tile alone and needs an
  /// accessible name from its surroundings.
  final String? label;

  /// The icon centered inside the tile, supplied by [GtActionButton.new].
  ///
  /// `null` when the button was built with [GtActionButton.image].
  final IconData? _icon;

  /// The artwork painted across the tile, supplied by [GtActionButton.image].
  ///
  /// `null` when the button was built with the default constructor. The two
  /// are mutually exclusive.
  final DecorationImage? _image;

  /// An optional color to override the default icon tint.
  ///
  /// Defaults to [GtPalette.staticColors.white]. Ignored by
  /// [GtActionButton.image], which paints artwork rather than an icon.
  final Color? iconColor;

  /// The rendered size of the icon, in logical pixels.
  ///
  /// Defaults to 24dp and must not exceed [size]; see [minTapTargetSize]. The
  /// icon is scaled down further if [padding] leaves less room than this.
  /// Ignored by [GtActionButton.image].
  final double? iconSize;

  /// The diameter of the circular tile, in logical pixels.
  ///
  /// Defaults to 44dp and must not be smaller than [minTapTargetSize].
  final double? size;

  /// The inset between the tile’s edge and the icon it contains.
  ///
  /// Defaults to 10dp on every side. Has no bearing on
  /// [GtActionButton.image], whose artwork is painted as the tile’s
  /// decoration and so ignores padding.
  final EdgeInsetsGeometry? padding;

  /// An optional text style to override the default [label] style.
  ///
  /// Defaults to [GtTextStyles.subHeadXs].
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (_icon case IconData icon) {
      child = FittedBox(
        fit: .scaleDown,
        child: GtIcon.withColor(
          icon,
          size: iconSize ?? 24,
          color: iconColor ?? context.palette.staticColors.white,
        ),
      );
    }
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
              width: size ?? minTapTargetSize,
              height: size ?? minTapTargetSize,
              constraints: BoxConstraints.tight(Size.square(minTapTargetSize)),
              padding: padding ?? context.insets.allDp(10.px),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: .circle,
                image: _image,
              ),
              duration: GtMotion.adaptiveDuration(context, 500.milliseconds),
              curve: Curves.decelerate,
              child: child,
            ),
            if (label case String label)
              Flexible(
                child: GtText(
                  label,
                  style: labelStyle ?? context.textStyles.subHeadXs(),
                  textAlign: .center,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
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
