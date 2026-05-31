import 'package:flutter/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A base class for spacers used in [GtViewStateWidget].
sealed class GtViewStateSpacer extends GtStatelessWidget {
  /// Creates a [GtViewStateSpacer].
  const GtViewStateSpacer({super.key});
}

/// A spacer that uses a [GtGap] to provide spacing.
final class GtViewStateGapSpacer extends GtViewStateSpacer {
  /// The [GtGap] used for spacing.
  final GtGap child;

  /// Creates a [GtViewStateGapSpacer].
  const GtViewStateGapSpacer(this.child, {super.key});

  @override
  Widget build(BuildContext context) => child;
}

/// A spacer that uses a [GtSizedBox] to provide spacing.
final class GtViewStateSizedBoxSpacer extends GtViewStateSpacer {
  /// The [GtSizedBox] used for spacing.
  final GtSizedBox child;

  /// Creates a [GtViewStateSizedBoxSpacer].
  const GtViewStateSizedBoxSpacer(this.child, {super.key});

  @override
  Widget build(BuildContext context) => child;
}

/// A spacer that expands to fill available space using a [Spacer].
final class GtViewStateFillSpacer extends GtViewStateSpacer {
  /// Creates a [GtViewStateFillSpacer].
  const GtViewStateFillSpacer({super.key});

  @override
  Widget build(BuildContext context) => const Spacer();
}

/// A widget that displays a generic view state.
///
/// This is typically used for empty states, error states, or other informational
/// states that require an icon, a title, a description, and optionally a
/// call-to-action button.
class GtViewStateWidget extends GtStatelessWidget {
  /// The primary title text of the view state.
  final String title;

  /// The callback to execute when the call-to-action button is pressed.
  ///
  /// If provided, [actionText] should typically be provided as well.
  final OnPressed? onActionPressed;

  /// The icon to display above the title.
  final AppImageData? icon;

  /// The descriptive text displayed below the title.
  final String? description;

  /// The text to display on the call-to-action button.
  final String? actionText;

  /// The spacing between the icon and the title.
  ///
  /// Defaults to `GtGap.yMd()`. Can be customized with a [GtViewStateSpacer].
  final GtViewStateSpacer? gapToTitle;

  /// The spacing between the title and the description.
  ///
  /// Defaults to `GtGap.yMd()`. Can be customized with a [GtViewStateSpacer].
  final GtViewStateSpacer? gapToDescription;

  /// The spacing between the description (or title) and the action button.
  ///
  /// Defaults to `GtGap.yLg()`. Can be customized with a [GtViewStateSpacer].
  final GtViewStateSpacer? gapToAction;

  /// The size of the icon.
  ///
  /// Defaults to 124.
  final double? iconSize;

  /// The alignment of the entire view state content within its parent.
  ///
  /// Defaults to `Alignment.center`.
  final AlignmentGeometry alignment;

  /// The text style to apply to the title.
  ///
  /// Defaults to `context.textStyles.h6()`.
  final TextStyle? titleStyle;

  /// The text style to apply to the description.
  ///
  /// Defaults to `context.textStyles.bodyS()` with a secondary color.
  final TextStyle? descriptionStyle;

  /// The visual variant of the call-to-action button.
  ///
  /// Defaults to `GtButtonVariant.primary`.
  final GtButtonVariant? actionVariant;

  /// The size of the call-to-action button.
  ///
  /// Defaults to `GtButtonSize.xsmall`.
  final GtButtonSize? actionSize;

  /// The alignment of the call-to-action button.
  final AlignmentGeometry? actionAlignment;

  /// Creates a [GtViewStateWidget].
  const GtViewStateWidget({
    super.key,
    this.gapToAction,
    this.gapToDescription,
    this.gapToTitle,
    this.description,
    required this.title,
    this.onActionPressed,
    this.icon,
    this.iconSize,
    this.alignment = .center,
    this.descriptionStyle,
    this.titleStyle,
    this.actionAlignment,
    this.actionSize,
    this.actionVariant,
    this.actionText,
  }) : assert(
         (onActionPressed == null) == (actionText == null),
         'onActionPressed and actionText must be provided together',
       );

  @override
  Widget build(BuildContext context) {
    final subStyle = context.textStyles.bodyS(
      color: context.palette.text.darkerSub,
    );

    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          if (icon != null) ...[
            GtImage(
              image: icon!,
              width: iconSize ?? 124,
              height: iconSize ?? 124,
              fit: .contain,
              alignment: .center,
            ),
            gapToTitle ?? const GtGap.yLg(),
          ],
          GtText(
            title.upper,
            style: titleStyle ?? context.textStyles.h6(),
            textAlign: .center,
            maxLines: 2,
            overflow: .ellipsis,
          ),
          if (description != null) ...[
            gapToDescription ?? const GtGap.yMd(),
            GtRichText(
              description!,
              style: descriptionStyle ?? subStyle,
              textAlign: .center,
              maxLines: 5,
            ),
          ],
          if (onActionPressed != null) ...[
            gapToAction ?? const GtGap.yLg(),
            GtRaisedButton(
              onPressed: onActionPressed!,
              text: actionText ?? "",
              variant: actionVariant ?? .primary,
              size: actionSize ?? .xsmall,
              alignment: actionAlignment,
            ),
          ],
        ],
      ),
    );
  }
}
