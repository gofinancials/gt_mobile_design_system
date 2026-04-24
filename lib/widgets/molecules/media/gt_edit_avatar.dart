import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GtEditAvatar extends GtStatelessWidget {
  final AppImageData? avatar;
  final BoxFit? fit;
  final Alignment alignment;
  final OnPressed onEdit;
  final bool isUserAvatar;
  final double? size;

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
