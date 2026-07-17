// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtVideoPlayer', type: GtVideoPlayer)
Widget gtVideoPlayerUseCase(BuildContext context) {
  final videoController = VideoPlayerController.networkUrl(
    Uri.parse(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ),
  );
  return GtWidgetDocPage(
    title: "Video Player",
    description: "A standard video player for remote or local video sources.",
    code: '''
GtVideoPlayer(
  VideoPlayerController.networkUrl(
    Uri.parse(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ),
  )
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtVideoPlayer"),
        GtInkWell(
          onTap: () => videoController.value.isPlaying
              ? videoController.pause()
              : videoController.play(),
          child: GtVideoPlayer(videoController),
        ),
      ],
    ),
  );
}
