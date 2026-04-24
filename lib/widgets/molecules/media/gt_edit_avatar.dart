import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A specialized avatar widget that includes an overlay icon for editing.
///
/// This widget is typically used in profile editing screens where the user
/// needs a visual indicator that their avatar can be tapped and changed.
class GtEditAvatar extends GtStatelessWidget {
  /// The optional image data to display. If null, a default placeholder is used.
  final AppImageData? avatar;

  /// How the image should be inscribed into the avatar's bounding box.
  final BoxFit? fit;

  /// The alignment of the image within its bounding box. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Callback invoked when the avatar is tapped to initiate an edit action.
  final OnPressed onEdit;

  /// Indicates if this represents the primary user avatar.
  ///
  /// If `true`, the widget is wrapped in a [Hero] widget with the tag "user-avatar"
  /// for smooth transition animations across screens.
  final bool isUserAvatar;

  /// The size (width and height) of the square avatar box. Defaults to 180dp.
  final double? size;

  /// Creates a [GtEditAvatar].
  const GtEditAvatar({
    this.avatar,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    required this.onEdit,
    this.isUserAvatar = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    BoxFit defaultFit = BoxFit.cover;
    final hasAvatar = avatar != null;

    ImageProvider? image;
    DecorationImage? decoration;

    if (!hasAvatar) {
      image = CachedNetworkImageProvider(GtNetworkImages.avatar3d2);
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
        fit: fit ?? defaultFit,
        alignment: alignment,
      );
    }

    final computedSize = size ?? context.dp(180.px);

    Widget child = Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          onEdit();
        },
        child: GtSquareConstrainedBox(
          computedSize,
          child: ClipRRect(
            borderRadius: context.borderRadius4Xl,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: context.gradients.avatarGradient,
                image: decoration,
              ),
              child: Align(
                alignment: .topRight,
                child: Container(
                  alignment: .center,
                  width: computedSize * .17,
                  height: computedSize * .17,
                  margin: EdgeInsets.all(computedSize * .06),
                  padding: EdgeInsets.all(computedSize * .028),
                  decoration: BoxDecoration(
                    color: context.palette.bg.white,
                    borderRadius: context.borderRadiusMd,
                  ),
                  child: GtIcon(GtIcons.penSparkle, size: computedSize * .12),
                ),
              ),
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
