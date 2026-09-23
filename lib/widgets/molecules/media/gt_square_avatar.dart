import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A specialized avatar widget that includes an overlay icon for editing.
///
/// This widget is typically used in profile editing screens where the user
/// needs a visual indicator that their avatar can be tapped and changed.
///
/// With no image to show it falls back the way [GtAvatar] does: [initials]
/// first, then the [isUserAvatar] placeholder icon, then the default avatar
/// artwork.
class GtSquareAvatar extends GtStatelessWidget {
  /// The optional image data to display.
  ///
  /// With nothing valid here the widget falls back to [initials], then to the
  /// [isUserAvatar] placeholder icon, then to the default avatar artwork.
  final AppImageData? avatar;

  /// How the image should be inscribed into the avatar's bounding box.
  final BoxFit? fit;

  /// The alignment of the image within its bounding box. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Callback invoked when the avatar is tapped to initiate an edit action.
  final OnPressed? onEdit;

  /// An accessible name for the edit action, already localised.
  ///
  /// Only announced when [onEdit] makes the avatar interactive.
  final String? semanticsLabel;

  /// Indicates if this represents the primary user avatar.
  ///
  /// If `true`, the widget is wrapped in a [Hero] widget with the tag "user-avatar"
  /// for smooth transition animations across screens.
  ///
  /// It also decides what an empty avatar falls back to. A user avatar with no
  /// image and no [initials] draws the user glyph, and never requests the
  /// default artwork over the network; a non-user avatar with no image and no
  /// initials is the one case that falls back to that artwork.
  final bool isUserAvatar;

  /// The size (width and height) of the square avatar box. Defaults to 180dp.
  final double? size;

  /// The border radius of the square avatar box. Defaults to [context.borderRadius4Xl].
  final BorderRadius? borderRadius;

  /// Whether to draw a white border around the outer edge of the avatar.
  final bool showBorder;

  /// Whether to paint [GtGradients.avatarGradient] behind the image.
  ///
  /// Defaults to `true`. [BoxDecoration] ignores [bgColor] while a gradient is
  /// set, so turn it off to show a plain background color.
  final bool showGradient;

  /// The background color of the box that holds the image.
  ///
  /// Only visible when [showGradient] is `false`.
  final Color? bgColor;

  /// The size (width and height) of the edit pen badge shown when [onEdit] is
  /// set. The pen icon scales with the badge. Defaults to 17% of the avatar
  /// size.
  final double? editPenSize;

  /// The size of the placeholder user icon shown when [isUserAvatar] is `true`
  /// and there is no image. Defaults to the [GtIcon] default size.
  final double? userIconSize;

  /// The text initials to display centered in the avatar when there is no image.
  ///
  /// Initials take precedence over both fallbacks: the default avatar artwork
  /// and the [isUserAvatar] placeholder icon stay hidden while they are set.
  final String? initials;

  /// The color of the [initials]. Defaults to the base primary color.
  ///
  /// Ignored once [initialsStyle] is supplied, since that style carries its
  /// own color.
  final Color? initialsColor;

  /// The text style of the [initials].
  ///
  /// Replaces the scaled default outright rather than merging with it, so it
  /// also overrides [initialsColor] — fold the color into this style when both
  /// matter. Supply it only when the initials need a family or weight the
  /// default cannot express.
  final TextStyle? initialsStyle;

  /// Creates a [GtSquareAvatar].
  const GtSquareAvatar({
    this.avatar,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.borderRadius,
    this.showBorder = false,
    this.showGradient = true,
    this.bgColor,
    this.editPenSize,
    this.userIconSize,
    this.initials,
    this.initialsColor,
    this.initialsStyle,
    this.onEdit,
    this.semanticsLabel,
    this.isUserAvatar = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    BoxFit defaultFit = BoxFit.cover;
    final hasAvatar = avatar != null && avatar.hasValidData;

    // An avatar that fails validation is not something to draw. Dropping it
    // here is what lets the initials and the user glyph below stay reachable,
    // since both are guarded on there being no image.
    AppImageData? image = hasAvatar ? avatar : null;

    Border? border;
    if (showBorder) {
      border = Border.all(color: context.palette.stroke.white, width: 1.5);
    }

    // The default artwork is the last fallback, not the first: initials and
    // the user glyph both outrank it, and a user avatar never reaches for the
    // network when the glyph is what the empty state calls for.
    if (!hasAvatar && !initials.hasValue && !isUserAvatar) {
      image = AppImageData(GtNetworkImages.avatar3d2);
    }

    final computedSize = size ?? context.dp(180.px);
    final computedPenSize = editPenSize ?? computedSize * .17;

    Gradient? gradient;
    if (showGradient) {
      gradient = context.gradients.avatarGradient;
    }

    Widget? initialsLabel;

    if (initials.hasValue && image == null) {
      final style =
          initialsStyle ??
          context.textStyles.title(
            color: initialsColor ?? context.palette.primary.base,
            weight: .w700,
          );

      initialsLabel = Padding(
        // FittedBox only shrinks, so the padding is what keeps three or four
        // initials off the rounded corners once they stop scaling.
        padding: .all(computedSize * .1),
        child: Center(
          child: FittedBox(
            fit: .scaleDown,
            child: GtText(initials, style: style, textAlign: .center),
          ),
        ),
      );
    }

    Widget? editPen;

    if (onEdit != null) {
      editPen = Align(
        alignment: .topRight,
        child: Container(
          alignment: .center,
          width: computedPenSize,
          height: computedPenSize,
          margin: .all(computedSize * .06),
          padding: .all(computedPenSize * .165),
          decoration: BoxDecoration(
            color: context.palette.bg.white,
            borderRadius: context.borderRadiusMd,
          ),
          child: GtIcon(GtIcons.penSparkle, size: computedPenSize * .7),
        ),
      );
    }

    Widget child = Align(
      alignment: alignment,
      child: GtInkWell(
        // GestureDetector took no focus and reported no semantics, and it
        // registered a tap handler even when onEdit was null, leaving a dead
        // target that still swallowed touches.
        role: onEdit == null ? .none : .button,
        semanticsLabel: onEdit == null ? null : semanticsLabel,
        excludeDescendantSemantics: true,
        hapticFeedbackType: .light,
        onTap: onEdit,
        child: GtSquareConstrainedBox(
          computedSize,
          child: Container(
            clipBehavior: .hardEdge,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? context.borderRadius4Xl,
              gradient: gradient,
              color: bgColor ?? context.palette.bg.weak,
              border: border,
            ),
            child: Stack(
              children: [
                if (initialsLabel case Widget label)
                  Positioned.fill(child: label),
                if (image != null)
                  Positioned.fill(
                    child: GtImage(
                      image: image,
                      fit: fit ?? defaultFit,
                      isDecorative: true,
                      width: computedSize,
                      height: computedSize,
                    ),
                  ),
                if (editPen case Widget edit)
                  Positioned(top: 0, right: 0, child: edit),
                if (isUserAvatar && (image == null && !initials.hasValue))
                  Positioned.fill(
                    child: GtIcon(
                      GtIcons.userSolid,
                      alignment: .center,
                      variant: .strong,
                      size: userIconSize ?? computedSize * .2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isUserAvatar) {
      child = Hero(tag: "user-avatar", child: child);
    }

    return child;
  }
}
