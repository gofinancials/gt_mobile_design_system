import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

class GalleryBrokenImages {
  GalleryBrokenImages._();

  // The .test TLD is reserved and never resolves, so these fail fast. Unlike
  // .invalid it is short enough for AppRegex.urlRegex, so these are routed as
  // URLs rather than as asset paths.
  static const url = 'https://images.example.test/stash.webp';
  static const svgUrl = 'https://images.example.test/stash.svg';
  static const dataUri = 'data:not base64!';
  static const asset = 'assets/missing/stash.png';
  static const svgAsset = 'assets/missing/stash.svg';
  static const filePath = '/missing/stash.png';
  static final bytes = Uint8List.fromList([1, 2, 3, 4]);
}

class GalleryErrorFallback extends GtStatelessWidget {
  final double size;

  const GalleryErrorFallback({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.palette.bg.weak,
        borderRadius: context.borderRadiusMd,
      ),
      child: GtIcon(
        GtIcons.imageMountain,
        size: size * .4,
        variant: GtIconVariant.sub,
      ),
    );
  }
}

@widgetbook.UseCase(name: 'Error fallbacks', type: GtImage)
Widget playgroundImageErrorFallbackUseCase(BuildContext context) {
  return const _ErrorFallbackPlayground();
}

class _ErrorFallbackPlayground extends GtStatelessWidget {
  const _ErrorFallbackPlayground();

  @override
  Widget build(BuildContext context) {
    final useCustom = context.knobs.boolean(
      label: 'Pass errorWidget',
      initialValue: false,
    );
    final size = context.knobs.double.slider(
      label: 'Size',
      min: 40,
      max: 120,
      initialValue: 72,
    );

    final fallback = useCustom ? GalleryErrorFallback(size: size) : null;

    return GtWidgetDocPage(
      title: 'Error fallbacks',
      description:
          'Every image below points at a source that fails. Without an '
          'errorWidget each widget draws what it would with no image at all; '
          'turn on "Pass errorWidget" to see a custom fallback take its place. '
          'Atoms are outlined so an empty box is still visible.',
      code:
          '''
GtImage(
  image: AppImageData(stash.pictureUrl),
  width: $size,
  height: $size,${useCustom ? '\n  errorWidget: const StashPicturePlaceholder(),' : ''}
)

GtTransferParticipantData(
  label: "From",
  name: stash.name,
  image: AppImageData(stash.pictureUrl),
  imageType: .image,
  errorImage: AppImageData(GtAssetImages.avatar),
  validate: true,
)''',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Section(
            title: 'Atoms',
            caption:
                'Default: an empty box the size of the image. A malformed data '
                'URI no longer throws, and a failed SVG no longer shimmers.',
            size: size,
            items: [
              (
                'Network URL',
                GtNetworkImage(
                  GalleryBrokenImages.url,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              (
                'Network SVG',
                GtNetworkImage(
                  GalleryBrokenImages.svgUrl,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              (
                'Data URI',
                GtNetworkImage(
                  GalleryBrokenImages.dataUri,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              (
                'Asset',
                GtAssetImage(
                  GalleryBrokenImages.asset,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              (
                'Asset SVG',
                GtAssetImage(
                  GalleryBrokenImages.svgAsset,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              (
                'GtSvg',
                GtSvg(
                  GalleryBrokenImages.svgAsset,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              (
                'Memory',
                GtMemoryImage(
                  GalleryBrokenImages.bytes,
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
              // Image.file is unsupported on the web.
              if (!kIsWeb)
                (
                  'File',
                  GtFileImage(
                    File(GalleryBrokenImages.filePath),
                    width: size,
                    height: size,
                    errorWidget: fallback,
                    isDecorative: true,
                  ),
                ),
              (
                'GtImage',
                GtImage(
                  image: const AppImageData(GalleryBrokenImages.url),
                  width: size,
                  height: size,
                  errorWidget: fallback,
                  isDecorative: true,
                ),
              ),
            ],
            outlined: true,
          ),
          const GtGap.ySectionSm(),
          _Section(
            title: 'GtAvatar',
            caption:
                'Default: what an empty avatar shows. Initials first, then the '
                'placeholder asset on a user avatar, then the bare gradient.',
            size: size,
            items: [
              (
                'Initials',
                GtAvatar(
                  avatar: const AppImageData(GalleryBrokenImages.url),
                  initials: 'HS',
                  size: size,
                  errorWidget: fallback,
                ),
              ),
              (
                'User avatar',
                GtAvatar(
                  avatar: const AppImageData(GalleryBrokenImages.url),
                  isUserAvatar: true,
                  size: size,
                  errorWidget: fallback,
                ),
              ),
              (
                'Neither',
                GtAvatar(
                  avatar: const AppImageData(GalleryBrokenImages.url),
                  size: size,
                  errorWidget: fallback,
                ),
              ),
            ],
          ),
          const GtGap.ySectionSm(),
          _Section(
            title: 'GtSquareAvatar',
            caption:
                'Default: initials first, then the user glyph on a user '
                'avatar, then the default 3D artwork.',
            size: size,
            items: [
              (
                'Initials',
                GtSquareAvatar(
                  avatar: const AppImageData(GalleryBrokenImages.url),
                  initials: 'HS',
                  size: size,
                  errorWidget: fallback,
                ),
              ),
              (
                'User avatar',
                GtSquareAvatar(
                  avatar: const AppImageData(GalleryBrokenImages.url),
                  isUserAvatar: true,
                  size: size,
                  errorWidget: fallback,
                ),
              ),
              (
                'Neither',
                GtSquareAvatar(
                  avatar: const AppImageData(GalleryBrokenImages.url),
                  size: size,
                  errorWidget: fallback,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends GtStatelessWidget {
  final String title;
  final String caption;
  final List<(String, Widget)> items;
  final double size;
  final bool outlined;

  const _Section({
    required this.title,
    required this.caption,
    required this.items,
    required this.size,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GtText(title, style: context.textStyles.subHeadS()),
        const GtGap.yXs(),
        GtText(
          caption,
          style: context.textStyles.bodyXs(color: context.palette.text.sub),
        ),
        const GtGap.yMd(),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            for (final (label, child) in items)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GtImage and the avatars align themselves within whatever
                  // width they are given, so each tile pins its own square.
                  switch (outlined) {
                    true => DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: context.palette.stroke.soft),
                      ),
                      child: SizedBox.square(dimension: size, child: child),
                    ),
                    false => SizedBox.square(dimension: size, child: child),
                  },
                  const GtGap.yXs(),
                  GtText(
                    label,
                    style: context.textStyles.bodyXs(
                      color: context.palette.text.sub,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
