import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  /// Indicates whether this avatar represents the primary user.
  ///
  /// If `true`, it provides a default placeholder asset if [avatar] is null, applies
  /// a specific background color, and wraps the widget in a [Hero] with the tag "user-avatar"
  /// for smooth transition animations across screens.
  final bool isUserAvatar;

  /// The text initials to display centered in the avatar if [avatar] is null.
  final String? initials;

  /// An optional miniature widget to overlay at the bottom-right corner of the avatar.
  /// 
  /// Commonly used for status badges (e.g., online/offline dots) or small action icons.
  final Widget? tag;

  /// Whether to draw a white border around the outer edge of the avatar.
  final bool showBorder;

  /// Creates a [GtAvatar].
  const GtAvatar({
    this.avatar,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.size,
    this.onPressed,
    this.initials,
    this.isUserAvatar = false,
    this.tag,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSize = context.dp(36.px);
    final computedSize = size ?? defaultSize;
    final hasAvatar = avatar != null;

    Border? border;
    ImageProvider? image;
    DecorationImage? decoration;

    if (!hasAvatar && isUserAvatar) {
      image = AssetImage(GtAssetImages.avatar);
    }

    if (hasAvatar && avatar!.isString) {
      image = AssetImage(avatar?.filePath ?? "");
    }

    if (hasAvatar && avatar!.isUrl) {
      image = CachedNetworkImageProvider(avatar?.fileUrl ?? "");
    }

    if (hasAvatar && avatar!.isFile) {
      image = FileImage(avatar!.file!);
    }

    if (image != null) {
      decoration = DecorationImage(
        image: image,
        fit: fit ?? .cover,
        alignment: alignment,
      );
    }

    if (showBorder) border = Border.all(color: context.palette.stroke.white);

    Widget child = Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        child: Container(
          width: computedSize,
          height: computedSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: context.gradients.avatarGradient,
            color: isUserAvatar ? context.palette.bg.sub : null,
            image: decoration,
            border: border,
          ),
          child: Stack(
            children: [
              if (!hasAvatar && initials.hasValue)
                Positioned.fill(
                  child: Center(
                    child: GtText(
                      initials,
                      style: context.textStyles.h7(
                        color: context.palette.staticColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (tag != null)
                FractionalTranslation(
                  translation: Offset(.9, .8),
                  child: GtSquareConstrainedBox(computedSize * 0.4, child: tag),
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
