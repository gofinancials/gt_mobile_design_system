import 'package:flutter/material.dart';
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

  /// An accessible name for the edit action, already localised.
  ///
  /// Only announced when [onEdit] makes the avatar interactive.
  final String? semanticsLabel;

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
    this.onEdit,
    this.semanticsLabel,
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

    if (!hasAvatar && !isUserAvatar) {
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
    final computedPenSize = editPenSize ?? computedSize * .17;

    Gradient? gradient;
    if (showGradient) {
      gradient = context.gradients.avatarGradient;
    }

    Widget? editPen;

    if (onEdit != null) {
      editPen = Align(
        alignment: .topRight,
        child: Container(
          alignment: .center,
          width: computedPenSize,
          height: computedPenSize,
          margin: EdgeInsets.all(computedSize * .06),
          padding: EdgeInsets.all(computedPenSize * .165),
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
              image: decoration,
              border: border,
            ),
            child: Stack(
              children: [
                if (editPen case Widget edit)
                  Positioned(top: 0, right: 0, child: edit),
                if (isUserAvatar && image == null)
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
