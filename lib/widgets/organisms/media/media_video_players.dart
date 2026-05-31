// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A widget that renders standard video formats using the official [VideoPlayer].
///
/// It automatically handles pausing the global [MediaPlayerService] when disposed,
/// and dynamically adjusts its aspect ratio based on the video controller's initialization state.
class GtVideoPlayer extends GtStatefulWidget {
  /// The controller used to govern playback of the video.
  final VideoPlayerController controller;

  /// Creates a [GtVideoPlayer].
  const GtVideoPlayer(this.controller, {super.key});

  @override
  State<GtVideoPlayer> createState() {
    return _GtVideoPlayerState();
  }
}

class _GtVideoPlayerState extends State<GtVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (_, child) {
          final value = widget.controller.value;
          final isIntialised = value.isInitialized;

          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: isIntialised ? value.aspectRatio : 16 / 9,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.palette.bg.surface,
                    ),
                    child: child,
                  ),
                ),
              ),
              if (!isIntialised || value.isBuffering) const GtSpinner(),
            ],
          );
        },
        child: VideoPlayer(widget.controller),
      ),
    );
  }
}

/// A widget that renders YouTube videos using the [YoutubePlayer].
///
/// It integrates standard buffer indicators and directly utilizes the provided
/// [YoutubePlayerController] for playback management.
class GtYoutubePlayer extends GtStatefulWidget {
  /// The controller used to govern playback of the YouTube video.
  final YoutubePlayerController controller;

  /// Creates a [GtYoutubePlayer].
  const GtYoutubePlayer(this.controller, {super.key});

  @override
  State<GtYoutubePlayer> createState() {
    return _GtYoutubePlayerState();
  }
}

class _GtYoutubePlayerState extends State<GtYoutubePlayer> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: YoutubePlayer(
        controller: widget.controller,
        bufferIndicator: const GtSpinner(),
      ),
    );
  }
}
