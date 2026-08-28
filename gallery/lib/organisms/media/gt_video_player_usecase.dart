import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtVideoPlayer', type: GtVideoPlayer)
Widget gtVideoPlayerUseCase(BuildContext context) {
  return const _GtVideoPlayerPreview();
}

class _GtVideoPlayerPreview extends GtStatefulWidget {
  const _GtVideoPlayerPreview();

  @override
  State<_GtVideoPlayerPreview> createState() => _GtVideoPlayerPreviewState();
}

class _GtVideoPlayerPreviewState extends State<_GtVideoPlayerPreview> {
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );
    unawaited(_videoController.initialize());
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => _videoController.value.isPlaying
                ? _videoController.pause()
                : _videoController.play(),
            child: GtVideoPlayer(_videoController),
          ),
        ],
      ),
    );
  }
}
