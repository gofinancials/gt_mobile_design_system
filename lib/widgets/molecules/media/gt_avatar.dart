import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

/// A versatile circular avatar widget for displaying user profile pictures, initials, or placeholders.
///
/// [GtAvatar] supports multiple image sources via [AppImageData], including network URLs,
/// local files, and asset strings. It can also display text [initials] as a fallback,
/// and optionally overlay a [tag] widget (like a status badge) at the bottom-right corner.
class GtAvatar extends GtStatelessWidget {
  /// The image data to display in the avatar. If null, [initials] or a placeholder is shown.
  final AppImageData? avatar;

  /// The diameter of the circular avatar. Defaults to 36dp if not provided.
  final double? size;

  /// How the image should be inscribed into the circular bounding box. Defaults to [BoxFit.cover].
  final BoxFit? fit;

  /// The alignment of the widget within its parent. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Optional callback invoked when the avatar is tapped.
  final OnPressed? onPressed;

  /// An accessible name for the avatar, already localised.
  ///
  /// Supply the person or entity the avatar represents. Only announced when
  /// [onPressed] makes the avatar interactive; a decorative avatar beside a
  /// name that is already on screen should stay silent.
  final String? semanticsLabel;

  /// Indicates whether this avatar represents the primary user.
  ///
  /// If `true`, it falls back to the bundled placeholder asset when there is no
  /// valid [avatar] and no [initials], applies a specific background color, and
  /// wraps the widget in a [Hero] with the tag "user-avatar" for smooth
  /// transition animations across screens.
  final bool isUserAvatar;

  /// The text initials to display centered in the avatar, behind any image.
  ///
  /// Painted whenever they are set, so they show while a network [avatar]
  /// loads and through any transparency once it has.
  ///
  /// Initials outrank the [isUserAvatar] placeholder asset, which stays hidden
  /// while they are set. An [avatar] that fails validation does not count as an
  /// image, so a blank URL falls through to these rather than covering them.
  final String? initials;

  /// An optional miniature widget to overlay at the bottom-right corner of the avatar.
  ///
  /// Commonly used for status badges (e.g., online/offline dots) or small action icons.
  final Widget? tag;

  /// The size of the square [tag] overlay. Defaults to 40% of [size].
  final double? tagSize;

  /// Whether to draw a white border around the outer edge of the avatar.
  final bool showBorder;

  /// Whether to force present a default gradient
  final bool forceGradiant;

  /// Avatar container background gradient
  final Gradient? gradient;

  /// The color of the [initials]. Defaults to the base primary color.
  ///
  /// Ignored once [initialsStyle] is supplied, since that style carries its
  /// own color.
  final Color? initialsColor;

  /// Whether a spinner is drawn while a network [avatar] loads.
  ///
  /// Defaults to `false`, because the gradient and any [initials] are already
  /// painted underneath, and a spinner would cover an answer the customer can
  /// read. Set it to `true` where the avatar is large enough that a spinner
  /// reads as progress rather than clutter, or where nothing meaningful sits
  /// behind the image.
  final bool showLoadingIndicator;

  /// The text style of the [initials].
  ///
  /// Replaces the default outright rather than merging with it, so it also
  /// overrides [initialsColor] — fold the color into this style when both
  /// matter. Supply it only when the initials need a family, size or weight
  /// the default cannot express.
  final TextStyle? initialsStyle;

  /// Avatar background color
  final Color? bgColor;

  /// Avatar border color
  final Color? borderColor;

  /// Creates a [GtAvatar].
  const GtAvatar({
    this.avatar,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.size,
    this.onPressed,
    this.semanticsLabel,
    this.initials,
    this.isUserAvatar = false,
    this.showLoadingIndicator = false,
    this.tag,
    this.tagSize,
    this.showBorder = false,
    this.forceGradiant = true,
    this.gradient,
    this.bgColor,
    this.initialsColor,
    this.initialsStyle,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSize = context.dp(36.px);
    final computedSize = size ?? defaultSize;
    final computedTagSize = tagSize ?? computedSize * 0.4;
    final hasAvatar = avatar != null && avatar.hasValidData;
    final style = context.textStyles.subHeadS(
      color: initialsColor ?? context.palette.primary.base,
      weight: .w700,
    );
    final defaultGradient = forceGradiant
        ? context.gradients.avatarGradient
        : null;

    Border? border;
    // An avatar that fails validation is not something to draw, and leaving it
    // in would paint an empty image over the initials below.
    AppImageData? image = hasAvatar ? avatar : null;

    // Initials outrank the placeholder asset, so it only stands in when there
    // is nothing else to show.
    if (!hasAvatar && !initials.hasValue && isUserAvatar) {
      image = AppImageData(GtAssetImages.avatar);
    }

    if (showBorder) {
      border = Border.all(
        color: borderColor ?? context.palette.stroke.white,
        width: 1.5,
      );
    }

    Color? backgroundColor = bgColor;

    if (backgroundColor == null && isUserAvatar) {
      backgroundColor = context.palette.bg.sub;
    }

    Widget child = Align(
      alignment: alignment,
      child: GtInkWell(
        // GestureDetector took no focus and reported no semantics, and it
        // registered a tap handler even when onPressed was null, leaving a
        // dead target that still swallowed touches.
        role: onPressed == null ? .none : .button,
        semanticsLabel: onPressed == null ? null : semanticsLabel,
        excludeDescendantSemantics: true,
        customBorder: const CircleBorder(),
        onTap: onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!.call();
              },
        child: Container(
          width: computedSize,
          height: computedSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient ?? defaultGradient,
            color: backgroundColor,
            border: border,
          ),
          child: Stack(
            children: [
              if (initials.hasValue)
                Positioned.fill(
                  child: Center(
                    child: FittedBox(
                      fit: .scaleDown,
                      child: GtText(
                        initials,
                        style: initialsStyle ?? style,
                        textAlign: .center,
                      ),
                    ),
                  ),
                ),
              if (image != null)
                Positioned.fill(
                  child: ClipOval(
                    child: GtImage(
                      image: image,
                      fit: fit ?? .cover,
                      alignment: alignment,
                      width: computedSize,
                      height: computedSize,
                      isDecorative: true,
                      showLoadingIndicator: showLoadingIndicator,
                    ),
                  ),
                ),
              if (tag != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: FractionalTranslation(
                    translation: Offset(.1, .1),
                    child: GtSquareConstrainedBox(computedTagSize, child: tag),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (isUserAvatar) child = Hero(tag: "user-avatar", child: child);

    return child;
  }
}
