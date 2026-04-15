import 'package:flutter/material.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';

class GtImage extends GtStatelessWidget {
  final AppImageData? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool useDefaultSize;

  const GtImage({
    this.image,
    this.scaffoldKey,
    super.key,
    this.alignment = Alignment.center,
    this.fit,
    this.width,
    this.height,
    this.useDefaultSize = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSize = useDefaultSize ? context.dp(40.px) : null;
    return Align(
      alignment: alignment,
      child: Builder(
        builder: (_) {
          if (image?.isUrl ?? false) {
            return GtNetworkImage(
              image?.fileUrl ?? "",
              alignment: Alignment.center,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
            );
          }
          if (image?.isString ?? false) {
            return GtAssetImage(
              image?.filePath ?? "",
              alignment: Alignment.center,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
            );
          }
          if (image?.isFile ?? false) {
            return GtFileImage(
              image?.file,
              alignment: Alignment.center,
              width: width ?? defaultSize,
              height: height ?? defaultSize,
              fit: fit ?? BoxFit.cover,
            );
          }
          return Align(
            alignment: alignment,
            child: FittedBox(
              fit: fit ?? BoxFit.cover,
              child: SizedBox(
                width: width ?? defaultSize,
                height: height ?? defaultSize,
              ),
            ),
          );
        },
      ),
    );
  }
}
