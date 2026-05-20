import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A specialized avatar widget that includes an overlay icon for editing.
///
/// This widget is typically used in profile editing screens where the user
/// needs a visual indicator that their avatar can be tapped and changed.
class GtSquareAvatar extends GtStatelessWidget {
  /// The optional image data to display. If null, a default placeholder is used.
  final AppImageData? avatar;

  /// How the image should be inscribed into the avatar's bounding box.
  final BoxFit? fit;

  /// The alignment of the image within its bounding box. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Callback invoked when the avatar is tapped to initiate an edit action.
  final OnPressed? onEdit;

  /// Indicates if this represents the primary user avatar.
  ///
  /// If `true`, the widget is wrapped in a [Hero] widget with the tag "user-avatar"
  /// for smooth transition animations across screens.
  final bool isUserAvatar;

  /// The size (width and height) of the square avatar box. Defaults to 180dp.
  final double? size;

  /// The border radius of the square avatar box. Defaults to [context.borderRadius4Xl].
  final BorderRadius? borderRadius;

  /// Whether to draw a white border around the outer edge of the avatar.
  final bool showBorder;

  /// Creates a [GtSquareAvatar].
  const GtSquareAvatar({
    this.avatar,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.borderRadius,
    this.showBorder = false,
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

    Border? border;
    if (showBorder) {
      border = Border.all(color: context.palette.stroke.white, width: 1.5);
    }

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

    Widget? editPen;

    if (onEdit != null) {
      editPen = Align(
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
      );
    }

    Widget child = Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          onEdit?.call();
        },
        child: GtSquareConstrainedBox(
          computedSize,
          child: Container(
            clipBehavior: .hardEdge,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? context.borderRadius4Xl,
              gradient: context.gradients.avatarGradient,
              image: decoration,
              border: border,
            ),
            child: editPen,
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
