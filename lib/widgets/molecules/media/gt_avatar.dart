import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GtAvatar extends GtStatelessWidget {
  final AppImageData? avatar;
  final double? size;
  final BoxFit? fit;
  final Alignment alignment;
  final OnPressed? onPressed;
  final bool isUserAvatar;
  final String? initials;
  final Widget? tag;
  final bool showBorder;

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
